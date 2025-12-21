// ignore_for_file: use_build_context_synchronously
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yemek_tarifi_app/classes/food_class.dart';
import 'package:yemek_tarifi_app/classes/food_image.dart';
import 'package:yemek_tarifi_app/classes/ingredient_class.dart';
import 'package:yemek_tarifi_app/functions/checkstring.dart';
import 'package:yemek_tarifi_app/global/global_variables.dart';
import 'package:yemek_tarifi_app/functions/foodselection_screen_functions.dart';
import '../viewmodels/food_selection_viewmodel.dart';
import '../functions/form_decorations.dart';
import '../global/global_functions.dart';
import 'selectedfood_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import '../global/app_theme.dart';

class FoodSelectionScreen extends StatefulWidget {
  const FoodSelectionScreen({super.key});

  @override
  State<FoodSelectionScreen> createState() => _FoodSelectionScreenState();
}

class _FoodSelectionScreenState extends State<FoodSelectionScreen> {
  late final FoodSelectionViewModel _viewModel;
  late final ScrollController _scrollController;

  @override
  void initState() {
    _viewModel = FoodSelectionViewModel()..init(initialIngredients: globalDataBase!.initialIngredients);
    _scrollController = ScrollController()..addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<FoodSelectionViewModel>(
        builder: (context, viewModel, _) => globalScaffold(
          appBar: globalAppBar('selectionScreen'.tr(), context),
          body: _selectIngredientsBody(context, viewModel),
        ),
      ),
    );
  }

  Widget _selectIngredientsBody(BuildContext context, FoodSelectionViewModel viewModel) {
    return Column(
      children: [
        _buildFilterHero(context, viewModel),
        const SizedBox(height: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: _buildFoodResults(context, viewModel),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterHero(BuildContext context, FoodSelectionViewModel viewModel) {
    final theme = Theme.of(context);
    final List<IngredientClass> selectedIngredients = viewModel.selectedIngredients;
    final bool hasResults = viewModel.filteredFoodList.isNotEmpty;
    final int totalCount = viewModel.totalMatches ?? viewModel.filteredFoodList.length;
    final String totalLabel = '$totalCount ${'recipes'.tr()}';
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 20, 12, 4),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF0EA5E9), Color(0xFF6366F1)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [BoxShadow(color: const Color(0xFF0EA5E9).withValues(alpha: 0.28), blurRadius: 26, offset: const Offset(0, 16))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: Text('clickFilterForMore'.tr(), style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.9)))),
                if (viewModel.isSearchedOnce)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(12)),
                    child: Text(
                      totalLabel,
                      style: theme.textTheme.labelMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
              ],
            ),
            if (selectedIngredients.isNotEmpty) ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: selectedIngredients.take(2).map((ingredient) {
                  final ingredientName = context.locale.languageCode == 'tr' && ingredient.Ingredient_tr.isNotEmpty ? ingredient.Ingredient_tr : ingredient.Ingredient;
                  return Chip(
                    backgroundColor: Colors.white,
                    label: Text(ingredientName, style: const TextStyle(color: AppTheme.seedColor, fontWeight: FontWeight.w600)),
                  );
                }).toList(),
              ),
              if (selectedIngredients.length > 2) Padding(padding: const EdgeInsets.only(top: 2), child: Text('+${selectedIngredients.length - 2} ${'ingredients'.tr()}', style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70))),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog.fullscreen(backgroundColor: Colors.transparent, child: _filterContent(context, viewModel)),
                    );
                  },
                  icon: const Icon(Icons.filter_list_rounded),
                  label: Text('filter'.tr(), style: buttonTextStyle()),
                ),
                const Spacer(),
                if (hasResults) Text('Scroll for more', style: theme.textTheme.labelMedium?.copyWith(color: Colors.white70)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodResults(BuildContext context, FoodSelectionViewModel viewModel) {
    final bool isEmpty = viewModel.filteredFoodList.isEmpty;
    return RefreshIndicator(
      onRefresh: () => _refreshResults(viewModel),
      displacement: 24,
      child: isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              padding: const EdgeInsets.only(bottom: 32, top: 24),
              children: [
                _EmptyState(
                  key: ValueKey<bool>(viewModel.isSearchedOnce),
                  icon: viewModel.isSearchedOnce ? Icons.search_off_rounded : Icons.local_dining,
                  message: viewModel.isSearchedOnce ? 'tryAnotherFilter'.tr() : 'pleaseStartSearch'.tr(),
                ),
              ],
            )
          : ListView.separated(
              controller: _scrollController,
              itemCount: viewModel.filteredFoodList.length + (viewModel.isLoadingMore ? 1 : 0),
              padding: const EdgeInsets.only(bottom: 32),
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              itemBuilder: (BuildContext context, int index) {
                if (index >= viewModel.filteredFoodList.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final Food food = viewModel.filteredFoodList[index];
                return FoodListItem(food: food, index: index);
              },
              separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 16),
            ),
    );
  }

  Widget _filterContent(BuildContext context, FoodSelectionViewModel viewModel) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    Text('filter'.tr(), style: Theme.of(context).textTheme.headlineMedium),
                    const Spacer(),
                    IconButton(
                      style: IconButton.styleFrom(backgroundColor: Colors.white.withValues(alpha: 0.2), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                      icon: const Icon(Icons.close_rounded),
                      color: Colors.black,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customCard('foodSelectionText1'.tr()),
                      const SizedBox(height: 20),
                      IngredientSearchDropdown(
                        dropdownSelectedItems: viewModel.selectedIngredients,
                        onItemsChanged: viewModel.updateSelectedIngredients,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async => await _handleStartFiltering(context, viewModel),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: Text('startSearch'.tr(), style: buttonTextStyle(fontSize: 16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleStartFiltering(BuildContext context, FoodSelectionViewModel viewModel) async {
    showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) => const _FilteringSpinnerDialog());
    final String? error = await viewModel.startFiltering();
    if (!mounted) return;
    Navigator.of(context).pop();
    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('success'.tr()), duration: const Duration(seconds: 1)));
      Navigator.of(context).pop();
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('error'.tr()),
        content: Text(error),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('OK'.tr()))],
      ),
    );
  }

  Future<void> _loadMore(FoodSelectionViewModel viewModel) async {
    await viewModel.loadMore();
  }

  Future<void> _refreshResults(FoodSelectionViewModel viewModel) async {
    await viewModel.refreshResults();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _loadMore(_viewModel);
    }
  }
}

class FoodListItem extends StatelessWidget {
  final Food food;
  final int index;
  const FoodListItem({super.key, required this.food, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTurkish = context.locale.languageCode == 'tr';
    final String title = isTurkish ? food.name_tr : food.name;
    final int? rawDuration = food.totalTimeMinutes ?? food.cookTimeMinutes ?? food.prepTimeMinutes;
    final String timeText = formatDuration(rawDuration);
    final String? servingsValue = _normalizedServings(food.servings);
    final String servingsText = servingsValue != null ? '$servingsValue ${'person'.tr()}' : '? ${'person'.tr()}';
    final String heroTag = 'food-${food.recipeId}';
    final String category = food.categories.isNotEmpty ? food.categories.first : '';
    final String cuisine = food.cuisines.isNotEmpty ? food.cuisines.first : '';
    final String cuisineFlag = _flagForCuisine(cuisine);
    final String coverUrl = BackendService.recipeImagePublicUrl(food.recipeId);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 420 + index * 60),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Transform.translate(offset: Offset(0, (1 - value) * 24), child: Opacity(opacity: value, child: child)),
      child: InkWell(
        borderRadius: BorderRadius.circular(26),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SelectedFoodScreen(food, recipeId: 0, category: ""))),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            color: Colors.white.withValues(alpha: 0.95),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 18, offset: const Offset(0, 12))],
          ),
          child: SizedBox(
            height: 150,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(26)),
                  child: Hero(
                    tag: heroTag,
                    child: SizedBox(width: 90, height: 150, child: FoodImage(imageUrls: [coverUrl], cacheKey: 'recipe-${food.recipeId}')),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: Text(title, style: theme.textTheme.titleLarge?.copyWith(fontSize: 17), maxLines: 2, overflow: TextOverflow.ellipsis)),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_rounded, size: 20, color: AppTheme.seedColor),
                          ],
                        ),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            _chip(theme, icon: Icons.category_rounded, label: category.isNotEmpty ? category : '—'),
                            if (cuisine.isNotEmpty || cuisineFlag.isNotEmpty) _cuisineChip(theme, flag: cuisineFlag, cuisine: cuisine),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.group_outlined, size: 18, color: AppTheme.seedColor),
                            const SizedBox(width: 6),
                            Flexible(child: Text(servingsText, style: theme.textTheme.bodySmall?.copyWith(color: Colors.black54), overflow: TextOverflow.ellipsis)),
                            if (timeText.isNotEmpty) ...[
                              const SizedBox(width: 12),
                              const Icon(Icons.schedule_rounded, size: 18, color: AppTheme.seedColor),
                              const SizedBox(width: 6),
                              Flexible(child: Text(timeText, style: theme.textTheme.bodySmall?.copyWith(color: Colors.black54), overflow: TextOverflow.ellipsis)),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextStyle _badgeTextStyle(ThemeData theme) {
    return theme.textTheme.labelMedium?.copyWith(color: Colors.black87) ?? const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87);
  }

  Widget _cuisineChip(ThemeData theme, {required String flag, required String cuisine}) {
    final TextStyle baseStyle = _badgeTextStyle(theme);
    final double flagSize = (baseStyle.fontSize ?? 13) + 6;
    final bool showFlag = flag.isNotEmpty;
    final bool showCuisine = cuisine.isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppTheme.seedColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.seedColor.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showFlag) ...[
            Text(flag, style: baseStyle.copyWith(fontSize: flagSize)),
            if (showCuisine) const SizedBox(width: 6),
          ],
          if (showCuisine) Text(cuisine, style: baseStyle),
          if (!showFlag && !showCuisine) Text('Cuisine', style: baseStyle.copyWith(color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _chip(ThemeData theme, {IconData? icon, required String label}) {
    final TextStyle baseStyle = _badgeTextStyle(theme);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppTheme.seedColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.seedColor.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: AppTheme.seedColor),
            const SizedBox(width: 6),
          ],
          Text(label, style: baseStyle),
        ],
      ),
    );
  }

  String _flagForCuisine(String cuisine) {
    final lower = cuisine.toLowerCase();
    const map = {
      'american': '🇺🇸',
      'asian': '🌏',
      'italian': '🇮🇹',
      'mexican': '🇲🇽',
      'chinese': '🇨🇳',
      'indian': '🇮🇳',
      'turkish': '🇹🇷',
      'french': '🇫🇷',
      'german': '🇩🇪',
      'japanese': '🇯🇵',
      'thai': '🇹🇭',
      'spanish': '🇪🇸',
      'mediterranean': '🌊',
      'middle eastern': '🌙',
    };
    for (final entry in map.entries) {
      if (lower.contains(entry.key)) return entry.value;
    }
    return '';
  }

  String? _normalizedServings(String? rawServings) {
    if (rawServings == null) return null;
    final String trimmed = rawServings.trim();
    if (trimmed.isEmpty) return null;

    String firstEntry = trimmed;
    if (trimmed.startsWith('[') && trimmed.endsWith(']')) {
      final inner = trimmed.substring(1, trimmed.length - 1);
      final List<String> parts = inner.split(',').map((e) => e.trim().replaceAll(RegExp(r'''^['"]|['"]$'''), '')).where((e) => e.isNotEmpty).toList();
      if (parts.isNotEmpty) firstEntry = parts.first;
    }

    final RegExpMatch? match = RegExp(r'\d+').firstMatch(firstEntry);
    if (match != null) return match.group(0);

    final String fallback = firstEntry.replaceAll(RegExp(r'''^['"]|['"]$'''), '').trim();
    return fallback.isNotEmpty ? fallback : null;
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyState({super.key, required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.35),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 6))],
            ),
            child: const Icon(Icons.local_dining, size: 40, color: AppTheme.seedColor),
          ),
          const SizedBox(height: 20),
          Text(message, style: theme.textTheme.bodyLarge?.copyWith(color: const Color(0xFF475569))),
        ],
      ),
    );
  }
}

class _FilteringSpinnerDialog extends StatefulWidget {
  const _FilteringSpinnerDialog();

  @override
  State<_FilteringSpinnerDialog> createState() => _FilteringSpinnerDialogState();
}

class _FilteringSpinnerDialogState extends State<_FilteringSpinnerDialog> {
  Timer? _timer;
  int _messageIndex = 0;
  List<String> _messages = const [];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (!mounted || _messages.isEmpty) return;
      setState(() => _messageIndex = (_messageIndex + 1) % _messages.length);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _messages = _localizedMessages(context).where((text) => text.trim().isNotEmpty).toList();
    if (_messages.isEmpty) _messages = ['loading'.tr()];
    if (_messageIndex >= _messages.length) _messageIndex = 0;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  List<String> _localizedMessages(BuildContext context) {
    return [
      'filteringMessage1'.tr(),
      'filteringMessage2'.tr(),
      'filteringMessage3'.tr(),
      'filteringMessage4'.tr(),
      'filteringMessage5'.tr(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String currentMessage = _messages[_messageIndex % _messages.length];

    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 360),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 24, offset: const Offset(0, 12))],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 90,
                  width: 90,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [Color(0xFF0EA5E9), Color(0xFF6366F1)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      backgroundColor: Colors.white24,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 420),
                  transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
                  child: Text(
                    currentMessage,
                    key: ValueKey<String>(currentMessage),
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: Colors.blueGrey.shade900),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'filteringDialogSubtitle'.tr(),
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.blueGrey.shade600),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
