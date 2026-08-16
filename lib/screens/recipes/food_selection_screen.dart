import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:yemek_tarifi_app/core/configs/router/app_routes.dart';
import 'package:yemek_tarifi_app/core/network/backend_service.dart';
import 'package:yemek_tarifi_app/models/recipe/food.dart';
import 'package:yemek_tarifi_app/widgets/recipes/food_image.dart';
import 'package:yemek_tarifi_app/models/recipe/ingredient.dart';
import 'package:yemek_tarifi_app/core/utils/checkstring.dart';
import 'package:yemek_tarifi_app/global/app_globals.dart';
import 'package:yemek_tarifi_app/widgets/recipes/food_selection_helpers.dart';
import 'package:yemek_tarifi_app/widgets/app_scaffold.dart';
import 'package:yemek_tarifi_app/widgets/main_app_bar.dart';
import 'package:yemek_tarifi_app/providers/recipes/food_selection_viewmodel.dart';
import 'package:yemek_tarifi_app/core/utils/form_decorations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:yemek_tarifi_app/global/app_theme.dart';
import 'package:yemek_tarifi_app/widgets/app_surface.dart';
import 'package:yemek_tarifi_app/widgets/recipes/ingredient_selection_sheet.dart';

class FoodSelectionScreen extends StatefulWidget {
  const FoodSelectionScreen({
    super.key,
    this.initialIngredients,
    this.openSearch = false,
  });

  final List<Ingredient>? initialIngredients;
  final bool openSearch;

  @override
  State<FoodSelectionScreen> createState() => _FoodSelectionScreenState();
}

class _FoodSelectionScreenState extends State<FoodSelectionScreen> {
  late final FoodSelectionViewModel _viewModel;
  late final ScrollController _scrollController;
  late final bool _isAutomaticSearchRoute;
  bool _isInitialFiltering = false;
  bool _openSearchConsumed = false;
  bool _isIngredientSheetOpen = false;

  bool get _isResultsFlow =>
      !_isAutomaticSearchRoute && widget.initialIngredients?.isNotEmpty == true;

  @override
  void initState() {
    super.initState();
    _isAutomaticSearchRoute = widget.openSearch;
    final List<Ingredient> initialIngredients =
        widget.initialIngredients ?? globalDataBase!.initialIngredients;
    _viewModel = FoodSelectionViewModel()
      ..init(initialIngredients: initialIngredients);
    _scrollController = ScrollController()..addListener(_onScroll);
    if (_isAutomaticSearchRoute) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _consumeOpenSearchIntent();
      });
    } else if (_isResultsFlow && initialIngredients.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startInitialFiltering();
      });
    }
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
        builder: (context, viewModel, _) => AppScaffold(
          appBar: MainAppBar(title: 'selectionScreen'.tr()),
          body: _selectIngredientsBody(context, viewModel),
        ),
      ),
    );
  }

  Widget _selectIngredientsBody(
    BuildContext context,
    FoodSelectionViewModel viewModel,
  ) {
    return RefreshIndicator(
      onRefresh: () => _refreshResults(viewModel),
      displacement: 24,
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          SliverToBoxAdapter(child: _buildSelectionHero(context, viewModel)),
          if (!_isAutomaticSearchRoute && !_isResultsFlow) ...[
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(
              child: IngredientSearchDropdown(
                dropdownSelectedItems: viewModel.selectedIngredients,
                onItemsChanged: viewModel.updateSelectedIngredients,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: _buildSelectionActions(context, viewModel),
              ),
            ),
          ],
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: _buildResultsSummary(context, viewModel),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          if (_isInitialFiltering)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: AppLoadingIndicator()),
            )
          else
            ..._buildFoodResultSlivers(context, viewModel),
        ],
      ),
    );
  }

  Future<void> _startInitialFiltering() async {
    await _runFiltering();
  }

  Future<void> _runFiltering() async {
    if (!mounted) return;
    setState(() => _isInitialFiltering = true);
    final String? error = await _viewModel.startFiltering();
    if (!mounted) return;
    setState(() => _isInitialFiltering = false);
    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  Future<void> _consumeOpenSearchIntent() async {
    if (!mounted || _openSearchConsumed) return;
    _openSearchConsumed = true;
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;
    _clearOpenSearchRouteIntent();
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;
    await _openIngredientSheet();
  }

  void _clearOpenSearchRouteIntent() {
    if (GoRouter.maybeOf(context) == null) return;
    final GoRouterState routeState = GoRouterState.of(context);
    if (routeState.uri.queryParameters['openSearch'] != 'true') return;
    final Map<String, String> queryParameters = Map<String, String>.from(
      routeState.uri.queryParameters,
    )..remove('openSearch');
    context.replace(
      routeState.uri.replace(queryParameters: queryParameters).toString(),
      extra: List<Ingredient>.from(_viewModel.selectedIngredients),
    );
  }

  Future<void> _openIngredientSheet() async {
    if (!mounted || _isIngredientSheetOpen) return;
    _isIngredientSheetOpen = true;
    try {
      final List<Ingredient>? selected = await showIngredientSelectionSheet(
        context,
        initialSelectedIngredients: _viewModel.selectedIngredients,
        onSelectionChanged: _viewModel.updateSelectedIngredients,
      );
      if (!mounted || selected == null) return;
      _viewModel.updateSelectedIngredients(selected);
      await _runFiltering();
    } finally {
      _isIngredientSheetOpen = false;
    }
  }

  List<Widget> _buildFoodResultSlivers(
    BuildContext context,
    FoodSelectionViewModel viewModel,
  ) {
    if (viewModel.filteredFoodList.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          fillOverscroll: true,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            child: _EmptyState(
              key: ValueKey<bool>(viewModel.isSearchedOnce),
              icon: viewModel.isSearchedOnce
                  ? Icons.search_off_rounded
                  : Icons.local_dining,
              message: viewModel.isSearchedOnce
                  ? 'selectionResultsEmpty'.tr()
                  : 'selectionResultsIdle'.tr(),
            ),
          ),
        ),
      ];
    }

    return [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        sliver: SliverList.separated(
          itemCount:
              viewModel.filteredFoodList.length +
              (viewModel.isLoadingMore ? 1 : 0),
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
          separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(height: 16),
        ),
      ),
    ];
  }

  Widget _buildSelectionHero(
    BuildContext context,
    FoodSelectionViewModel viewModel,
  ) {
    final ThemeData theme = Theme.of(context);
    final int selectedCount = viewModel.selectedIngredients.length;
    final int totalCount =
        viewModel.totalMatches ?? viewModel.filteredFoodList.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF251914), Color(0xFF7B4A38)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7B4A38).withValues(alpha: 0.22),
              blurRadius: 24,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'selectionHeroTitle'.tr(),
              style: theme.textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'selectionHeroBody'.tr(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.84),
              ),
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _HeroChip(
                  icon: Icons.shopping_basket_rounded,
                  label: 'selectionSelectedCount'.tr(
                    args: [selectedCount.toString()],
                  ),
                ),
                _HeroChip(
                  icon: Icons.menu_book_rounded,
                  label: viewModel.isSearchedOnce
                      ? 'selectionResultsReady'.tr(
                          args: [totalCount.toString()],
                        )
                      : 'clickFilterForMore'.tr(),
                ),
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _openIngredientSheet,
                icon: const Icon(Icons.search_rounded),
                label: Text('searchForIngredients'.tr()),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.42)),
                  minimumSize: const Size.fromHeight(46),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionActions(
    BuildContext context,
    FoodSelectionViewModel viewModel,
  ) {
    final bool hasSelection = viewModel.selectedIngredients.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed: hasSelection
              ? () => viewModel.updateSelectedIngredients(const <Ingredient>[])
              : null,
          icon: const Icon(Icons.clear_rounded),
          label: Text('selectionSecondaryAction'.tr()),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: hasSelection
              ? () async => _handleStartFiltering(context, viewModel)
              : null,
          icon: const Icon(Icons.search_rounded),
          label: Text(
            'selectionPrimaryAction'.tr(),
            style: buttonTextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildResultsSummary(
    BuildContext context,
    FoodSelectionViewModel viewModel,
  ) {
    final bool hasResults = viewModel.filteredFoodList.isNotEmpty;
    final String message = !viewModel.isSearchedOnce
        ? 'selectionResultsIdle'.tr()
        : hasResults
        ? 'selectionResultsReady'.tr(
            args: [viewModel.filteredFoodList.length.toString()],
          )
        : 'selectionResultsEmpty'.tr();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.seedColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              hasResults
                  ? Icons.check_circle_outline_rounded
                  : Icons.info_outline_rounded,
              color: AppTheme.seedColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'selectionResultsTitle'.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(message, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleStartFiltering(
    BuildContext context,
    FoodSelectionViewModel viewModel,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const _FilteringSpinnerDialog(),
    );
    final String? error = await viewModel.startFiltering();
    if (!context.mounted) return;
    Navigator.of(context).pop();
    if (error == null) {
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('error'.tr()),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'.tr()),
          ),
        ],
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
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore(_viewModel);
    }
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
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
    final String title = isTurkish ? food.nameTr : food.name;
    final int? rawDuration =
        food.totalTimeMinutes ?? food.cookTimeMinutes ?? food.prepTimeMinutes;
    final String timeText = formatDuration(rawDuration);
    final String? servingsValue = _normalizedServings(food.servings);
    final String servingsText = servingsValue != null
        ? '$servingsValue ${'person'.tr()}'
        : '? ${'person'.tr()}';
    final String heroTag = 'food-${food.recipeId}';
    final String category = food.categories.isNotEmpty
        ? food.categories.first
        : '';
    final String cuisine = food.cuisines.isNotEmpty ? food.cuisines.first : '';
    final String cuisineFlag = _flagForCuisine(cuisine);
    final String coverUrl = BackendService.recipeImagePublicUrl(food.recipeId);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 420 + index * 60),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Transform.translate(
        offset: Offset(0, (1 - value) * 24),
        child: Opacity(opacity: value, child: child),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(26),
        onTap: () =>
            context.push(AppRoutes.recipeById(food.recipeId), extra: food),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            color: AppTheme.surface.withValues(alpha: 0.96),
            border: Border.all(color: AppTheme.line),
            boxShadow: AppTheme.softShadow,
          ),
          child: SizedBox(
            height: 170,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(26),
                  ),
                  child: Hero(
                    tag: heroTag,
                    child: SizedBox(
                      width: 124,
                      height: 170,
                      child: FoodImage(
                        imageUrls: [coverUrl],
                        cacheKey: 'recipe-${food.recipeId}',
                        cacheWidth: 360,
                        cacheHeight: 560,
                      ),
                    ),
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
                            Expanded(
                              child: Text(
                                title,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontSize: 17,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              size: 20,
                              color: AppTheme.seedColor,
                            ),
                          ],
                        ),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            _chip(
                              theme,
                              icon: Icons.category_rounded,
                              label: category.isNotEmpty ? category : '—',
                            ),
                            if (cuisine.isNotEmpty || cuisineFlag.isNotEmpty)
                              _cuisineChip(
                                theme,
                                flag: cuisineFlag,
                                cuisine: cuisine,
                              ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.group_outlined,
                              size: 18,
                              color: AppTheme.seedColor,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                servingsText,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.black54,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (timeText.isNotEmpty) ...[
                              const SizedBox(width: 12),
                              const Icon(
                                Icons.schedule_rounded,
                                size: 18,
                                color: AppTheme.seedColor,
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  timeText,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.black54,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                            const Spacer(),
                            Text(
                              'viewRecipe'.tr(),
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: AppTheme.seedColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
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
    return theme.textTheme.labelMedium?.copyWith(color: Colors.black87) ??
        const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        );
  }

  Widget _cuisineChip(
    ThemeData theme, {
    required String flag,
    required String cuisine,
  }) {
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
          if (!showFlag && !showCuisine)
            Text(
              'cuisineLabel'.tr(),
              style: baseStyle.copyWith(color: Colors.black54),
            ),
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
      final List<String> parts = inner
          .split(',')
          .map((e) => e.trim().replaceAll(RegExp(r'''^['"]|['"]$'''), ''))
          .where((e) => e.isNotEmpty)
          .toList();
      if (parts.isNotEmpty) firstEntry = parts.first;
    }

    final RegExpMatch? match = RegExp(r'\d+').firstMatch(firstEntry);
    if (match != null) return match.group(0);

    final String fallback = firstEntry
        .replaceAll(RegExp(r'''^['"]|['"]$'''), '')
        .trim();
    return fallback.isNotEmpty ? fallback : null;
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyState({super.key, required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppSurface(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.local_dining, size: 36, color: AppTheme.seedColor),
            const SizedBox(height: 14),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _FilteringSpinnerDialog extends StatefulWidget {
  const _FilteringSpinnerDialog();

  @override
  State<_FilteringSpinnerDialog> createState() =>
      _FilteringSpinnerDialogState();
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
    _messages = _localizedMessages(
      context,
    ).where((text) => text.trim().isNotEmpty).toList();
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
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: AppSurface(
              color: AppTheme.surface,
              borderRadius: AppTheme.radiusLarge,
              shadow: AppTheme.softShadow,
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 90,
                    width: 90,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFF8D6E53), Color(0xFFB65C45)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
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
                    transitionBuilder: (child, animation) =>
                        FadeTransition(opacity: animation, child: child),
                    child: Text(
                      currentMessage,
                      key: ValueKey<String>(currentMessage),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.blueGrey.shade900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'filteringDialogSubtitle'.tr(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.blueGrey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
