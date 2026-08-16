import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:yemek_tarifi_app/core/network/backend_service.dart';
import 'package:yemek_tarifi_app/global/app_theme.dart';
import 'package:yemek_tarifi_app/models/recipe/ingredient.dart';
import 'package:yemek_tarifi_app/widgets/app_surface.dart';

Future<List<Ingredient>?> showIngredientSelectionSheet(
  BuildContext context, {
  required List<Ingredient> initialSelectedIngredients,
  required ValueChanged<List<Ingredient>> onSelectionChanged,
}) {
  return showModalBottomSheet<List<Ingredient>>(
    context: context,
    isScrollControlled: true,
    useSafeArea: false,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.34),
    builder: (sheetContext) {
      return DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.60,
        maxChildSize: 0.95,
        expand: false,
        snap: true,
        snapSizes: const [0.75, 0.95],
        builder: (context, scrollController) {
          return DecoratedBox(
            decoration: const BoxDecoration(
              color: AppTheme.parchment,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppTheme.radiusLarge),
              ),
            ),
            child: IngredientSelectionSheet(
              initialSelectedIngredients: initialSelectedIngredients,
              scrollController: scrollController,
              onSelectionChanged: onSelectionChanged,
            ),
          );
        },
      );
    },
  );
}

/// Ingredient search content hosted by the recipe discovery screen's sheet.
///
/// The parent owns the durable selection snapshot. This widget owns only the
/// short-lived search query and result list, so dismissing the sheet never
/// silently clears the user's selection.
class IngredientSelectionSheet extends StatefulWidget {
  const IngredientSelectionSheet({
    super.key,
    required this.initialSelectedIngredients,
    required this.scrollController,
    required this.onSelectionChanged,
  });

  final List<Ingredient> initialSelectedIngredients;
  final ScrollController scrollController;
  final ValueChanged<List<Ingredient>> onSelectionChanged;

  @override
  State<IngredientSelectionSheet> createState() =>
      _IngredientSelectionSheetState();
}

class _IngredientSelectionSheetState extends State<IngredientSelectionSheet> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  late List<Ingredient> _selectedIngredients;
  List<Ingredient> _results = const <Ingredient>[];
  Timer? _searchDebounce;
  int _searchRequestId = 0;
  bool _isSearching = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _selectedIngredients = List<Ingredient>.from(
      widget.initialSelectedIngredients,
    );
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _searchIngredients(String rawQuery) async {
    _searchDebounce?.cancel();
    final int requestId = ++_searchRequestId;
    final String query = rawQuery.trim();

    if (query.isEmpty) {
      setState(() {
        _results = const <Ingredient>[];
        _errorMessage = null;
        _isSearching = false;
      });
      return;
    }

    _searchDebounce = Timer(const Duration(milliseconds: 220), () async {
      if (!mounted) return;
      setState(() {
        _isSearching = true;
        _errorMessage = null;
      });
      try {
        final bool isTurkish =
            Localizations.localeOf(context).languageCode == 'tr';
        final List<Ingredient> results = await BackendService.searchIngredients(
          query: query,
          tableName: 'Ingredients',
          isTurkish: isTurkish,
        );
        if (!mounted || requestId != _searchRequestId) return;
        setState(() {
          _results = results;
          _isSearching = false;
        });
      } catch (error) {
        if (!mounted || requestId != _searchRequestId) return;
        setState(() {
          _results = const <Ingredient>[];
          _isSearching = false;
          _errorMessage = error.toString().replaceFirst('Exception: ', '');
        });
      }
    });
  }

  bool _isSelected(Ingredient ingredient) {
    return _selectedIngredients.any(
      (selected) =>
          selected.name == ingredient.name &&
          selected.nameTr == ingredient.nameTr,
    );
  }

  void _toggleIngredient(Ingredient ingredient) {
    final List<Ingredient> next = List<Ingredient>.from(_selectedIngredients);
    final int existingIndex = next.indexWhere(
      (selected) =>
          selected.name == ingredient.name &&
          selected.nameTr == ingredient.nameTr,
    );
    if (existingIndex >= 0) {
      next.removeAt(existingIndex);
    } else {
      next.add(ingredient);
    }
    setState(() => _selectedIngredients = next);
    widget.onSelectionChanged(List<Ingredient>.from(next));
  }

  void _removeIngredient(Ingredient ingredient) {
    final List<Ingredient> next = List<Ingredient>.from(_selectedIngredients)
      ..removeWhere(
        (selected) =>
            selected.name == ingredient.name &&
            selected.nameTr == ingredient.nameTr,
      );
    setState(() => _selectedIngredients = next);
    widget.onSelectionChanged(List<Ingredient>.from(next));
  }

  void _submit() {
    if (_selectedIngredients.isEmpty) return;
    widget.onSelectionChanged(List<Ingredient>.from(_selectedIngredients));
    Navigator.of(context).pop(List<Ingredient>.from(_selectedIngredients));
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bool hasQuery = _searchController.text.trim().isNotEmpty;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildDragHandle(),
            Expanded(
              child: CustomScrollView(
                controller: widget.scrollController,
                slivers: [
                  SliverToBoxAdapter(child: _buildHeader(context)),
                  SliverToBoxAdapter(child: _buildSearchField(context)),
                  SliverToBoxAdapter(child: _buildSelectedArea(context)),
                  if (_isSearching)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: SizedBox(
                          width: 26,
                          height: 26,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: AppTheme.seedColor,
                          ),
                        ),
                      ),
                    )
                  else if (_errorMessage != null)
                    SliverToBoxAdapter(child: _buildErrorState(context))
                  else if (!hasQuery)
                    SliverToBoxAdapter(child: _buildSearchPrompt(context))
                  else if (_results.isEmpty)
                    SliverToBoxAdapter(child: _buildEmptyState(context))
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 18),
                      sliver: SliverList.builder(
                        itemCount: _results.length,
                        itemBuilder: (context, index) =>
                            _buildIngredientRow(context, _results[index]),
                      ),
                    ),
                ],
              ),
            ),
            _buildBottomAction(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return ExcludeSemantics(
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 4),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppTheme.mutedInk.withValues(alpha: 0.38),
            borderRadius: BorderRadius.circular(99),
          ),
          child: const SizedBox(width: 42, height: 4),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 12, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: AppSectionHeader(
              icon: Icons.shopping_basket_outlined,
              title: 'select_ingredients'.tr(),
              description: 'selectionIngredientHelper'.tr(),
            ),
          ),
          IconButton(
            tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded),
            color: AppTheme.mutedInk,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        textInputAction: TextInputAction.search,
        keyboardType: TextInputType.text,
        onChanged: (value) {
          setState(() {});
          _searchIngredients(value);
        },
        onSubmitted: _searchIngredients,
        decoration: InputDecoration(
          labelText: 'searchForIngredients'.tr(),
          hintText: 'tapToAddIngredients'.tr(),
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: _searchController.text.isEmpty
              ? null
              : IconButton(
                  tooltip: MaterialLocalizations.of(
                    context,
                  ).deleteButtonTooltip,
                  onPressed: () {
                    _searchController.clear();
                    _searchIngredients('');
                    _searchFocusNode.requestFocus();
                    setState(() {});
                  },
                  icon: const Icon(Icons.close_rounded),
                ),
        ),
      ),
    );
  }

  Widget _buildSelectedArea(BuildContext context) {
    if (_selectedIngredients.isEmpty) return const SizedBox(height: 18);
    final bool isTurkish = Localizations.localeOf(context).languageCode == 'tr';
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'selectedIngredients'.tr(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 104),
            child: SingleChildScrollView(
              primary: false,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedIngredients
                    .map(
                      (ingredient) =>
                          _buildSelectedPill(context, ingredient, isTurkish),
                    )
                    .toList(growable: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedPill(
    BuildContext context,
    Ingredient ingredient,
    bool isTurkish,
  ) {
    final String name = isTurkish && ingredient.nameTr.isNotEmpty
        ? ingredient.nameTr
        : ingredient.name;
    return Semantics(
      label: '$name, ${MaterialLocalizations.of(context).deleteButtonTooltip}',
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _removeIngredient(ingredient),
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          child: Container(
            constraints: const BoxConstraints(minHeight: 44, maxWidth: 280),
            padding: const EdgeInsets.fromLTRB(12, 7, 10, 7),
            decoration: BoxDecoration(
              color: AppTheme.surfaceMuted,
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              border: Border.all(color: AppTheme.line),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_rounded, size: 16, color: AppTheme.herb),
                const SizedBox(width: 7),
                Flexible(
                  child: Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium?.copyWith(color: AppTheme.ink),
                  ),
                ),
                const SizedBox(width: 7),
                const Icon(
                  Icons.close_rounded,
                  size: 17,
                  color: AppTheme.mutedInk,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchPrompt(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 26, 20, 20),
      child: Column(
        children: [
          Icon(Icons.search_rounded, size: 30, color: AppTheme.mutedInk),
          const SizedBox(height: 10),
          Text(
            'tapToAddIngredients'.tr(),
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded, size: 30, color: AppTheme.mutedInk),
          const SizedBox(height: 10),
          Text(
            'noIngredientsFound'.tr(),
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Text(
        _errorMessage ?? 'unknownError'.tr(),
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: AppTheme.danger),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildIngredientRow(BuildContext context, Ingredient ingredient) {
    final bool isTurkish = Localizations.localeOf(context).languageCode == 'tr';
    final String name = isTurkish && ingredient.nameTr.isNotEmpty
        ? ingredient.nameTr
        : ingredient.name;
    final bool selected = _isSelected(ingredient);
    return Semantics(
      selected: selected,
      button: true,
      label: selected ? '$name, ${'selectedIngredients'.tr()}' : name,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _toggleIngredient(ingredient),
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOutCubic,
            constraints: const BoxConstraints(minHeight: 56),
            margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: selected
                  ? AppTheme.seedColor.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              border: Border.all(
                color: selected
                    ? AppTheme.seedColor.withValues(alpha: 0.28)
                    : Colors.transparent,
              ),
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: selected
                        ? AppTheme.seedColor
                        : AppTheme.surfaceMuted,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    selected ? Icons.check_rounded : Icons.add_rounded,
                    size: 19,
                    color: selected ? Colors.white : AppTheme.secondaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    name,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.ink,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
                if (selected)
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 20,
                    color: AppTheme.herb,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    final bool canSubmit = _selectedIngredients.isNotEmpty;
    return AppSurface(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      borderRadius: 0,
      shadow: const [
        BoxShadow(
          color: Color(0x180F0A06),
          blurRadius: 16,
          offset: Offset(0, -5),
        ),
      ],
      child: Row(
        children: [
          Expanded(
            child: Text(
              'selectionSelectedCount'.tr(
                args: [_selectedIngredients.length.toString()],
              ),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ElevatedButton.icon(
            onPressed: canSubmit ? _submit : null,
            icon: const Icon(Icons.arrow_forward_rounded, size: 19),
            label: Text('selectionPrimaryAction'.tr()),
          ),
        ],
      ),
    );
  }
}
