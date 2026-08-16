import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:yemek_tarifi_app/core/network/backend_service.dart';
import 'package:yemek_tarifi_app/core/utils/form_decorations.dart';
import 'package:yemek_tarifi_app/global/app_theme.dart';
import 'package:yemek_tarifi_app/models/recipe/ingredient.dart';
import 'package:yemek_tarifi_app/widgets/app_surface.dart';

class IngredientSearchDropdown extends StatefulWidget {
  const IngredientSearchDropdown({
    super.key,
    this.tableName = 'Ingredients',
    required this.dropdownSelectedItems,
    required this.onItemsChanged,
  });

  final String tableName;
  final List<Ingredient> dropdownSelectedItems;
  final ValueChanged<List<Ingredient>> onItemsChanged;

  @override
  State<IngredientSearchDropdown> createState() =>
      _IngredientSearchDropdownState();
}

class _IngredientSearchDropdownState extends State<IngredientSearchDropdown> {
  final GlobalKey<DropdownSearchState<Ingredient>> _dropdownKey =
      GlobalKey<DropdownSearchState<Ingredient>>();
  late List<Ingredient> selectedItems;
  int? _totalIngredients;
  bool _isLoadingCount = false;

  @override
  void initState() {
    super.initState();
    selectedItems = List<Ingredient>.from(widget.dropdownSelectedItems);
    _loadIngredientCount();
  }

  @override
  void didUpdateWidget(covariant IngredientSearchDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dropdownSelectedItems != widget.dropdownSelectedItems) {
      selectedItems = List<Ingredient>.from(widget.dropdownSelectedItems);
    }
  }

  void _openPicker() {
    _dropdownKey.currentState?.openDropDownSearch();
  }

  Future<void> _loadIngredientCount() async {
    if (_isLoadingCount) return;
    setState(() => _isLoadingCount = true);
    final int? count = await BackendService.fetchTableCount(
      tableName: widget.tableName,
    );
    if (!mounted) return;
    setState(() {
      _totalIngredients = count;
      _isLoadingCount = false;
    });
  }

  void _updateSelection(List<Ingredient> items) {
    setState(() => selectedItems = List<Ingredient>.from(items));
    widget.onItemsChanged(List<Ingredient>.from(items));
  }

  @override
  Widget build(BuildContext context) {
    final bool isTurkish = Localizations.localeOf(context).languageCode == 'tr';
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: AppSurface(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppSectionHeader(
                    title: 'select_ingredients'.tr(),
                    description: 'selectionIngredientHelper'.tr(),
                    icon: Icons.shopping_basket_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                _CountBadge(
                  label: 'selectionSelectedCount'.tr(
                    args: [selectedItems.length.toString()],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            DropdownSearch<Ingredient>.multiSelection(
              key: _dropdownKey,
              items: (filter, loadProps) => fetchFilteredData(
                query: filter.trim(),
                tableName: widget.tableName,
                context: context,
              ),
              popupProps: MultiSelectionPopupProps.modalBottomSheet(
                showSelectedItems: false,
                showSearchBox: true,
                modalBottomSheetProps: const ModalBottomSheetProps(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  useSafeArea: true,
                ),
                validationBuilder: (ctx, items) {
                  return Builder(
                    builder: (innerContext) {
                      final popupState = innerContext
                          .findAncestorStateOfType<
                            DropdownSearchPopupState<Ingredient>
                          >();
                      return SafeArea(
                        minimum: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              if (popupState != null) {
                                popupState.onValidate();
                                return;
                              }
                              _updateSelection(items);
                              Navigator.of(innerContext).pop();
                            },
                            child: Text('OK'.tr()),
                          ),
                        ),
                      );
                    },
                  );
                },
                searchFieldProps: TextFieldProps(
                  decoration: formDecoration().copyWith(
                    labelText: 'searchForIngredients'.tr(),
                    hintText: 'searchForIngredients'.tr(),
                    prefixIcon: const Icon(Icons.search_rounded),
                  ),
                ),
                itemBuilder: (context, ingredient, isDisabled, isSelected) {
                  final String ingredientName = isTurkish
                      ? ingredient.nameTr
                      : ingredient.name;
                  return ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 6,
                    ),
                    leading: CircleAvatar(
                      radius: 18,
                      backgroundColor:
                          (isSelected
                                  ? AppTheme.seedColor
                                  : Colors.blueGrey.shade100)
                              .withValues(alpha: 0.15),
                      child: Icon(
                        isSelected ? Icons.check_rounded : Icons.add_rounded,
                        color: isSelected ? Colors.white : Colors.black87,
                        size: 18,
                      ),
                    ),
                    title: Text(
                      ingredientName,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                  );
                },
                emptyBuilder: (context, searchEntry) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'noIngredientsFound'.tr(),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.blueGrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              decoratorProps: DropDownDecoratorProps(
                decoration: formDecoration().copyWith(
                  labelText: 'searchForIngredients'.tr(),
                  hintText: 'tapToAddIngredients'.tr(),
                  prefixIcon: const Icon(
                    Icons.playlist_add_rounded,
                    color: AppTheme.seedColor,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              suffixProps: DropdownSuffixProps(
                dropdownButtonProps: DropdownButtonProps(
                  iconClosed: Icon(
                    Icons.expand_more_rounded,
                    color: AppTheme.seedColor.withValues(alpha: 0.9),
                  ),
                  iconOpened: Icon(
                    Icons.expand_less_rounded,
                    color: AppTheme.seedColor.withValues(alpha: 0.9),
                  ),
                ),
              ),
              compareFn: (item, selectedItem) =>
                  item.name == selectedItem.name &&
                  item.nameTr == selectedItem.nameTr,
              onSelected: _updateSelection,
              selectedItems: selectedItems,
              itemAsString: (Ingredient ingredient) =>
                  isTurkish ? ingredient.nameTr : ingredient.name,
              dropdownBuilder: (context, _) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _openPicker,
                  child: Row(
                    children: [
                      Icon(
                        Icons.list_alt_rounded,
                        color: AppTheme.seedColor.withValues(alpha: 0.9),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          selectedItems.isEmpty
                              ? 'tapToAddIngredients'.tr()
                              : 'selectedIngredients'.tr(),
                          style: formTextStyle(
                            textColor: Colors.blueGrey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'selectedIngredients'.tr(),
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (_totalIngredients != null)
                      Text(
                        '${'totalIngredients'.tr()}: $_totalIngredients',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: Colors.blueGrey.shade700,
                        ),
                      ),
                    if (selectedItems.isNotEmpty)
                      TextButton.icon(
                        onPressed: () => _updateSelection(const <Ingredient>[]),
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        label: Text('selectionSecondaryAction'.tr()),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            _SelectedIngredientsList(
              items: selectedItems,
              isTurkish: isTurkish,
              onRemove: (ingredient) {
                final List<Ingredient> next = List<Ingredient>.from(
                  selectedItems,
                )..remove(ingredient);
                _updateSelection(next);
              },
              onAddTap: _openPicker,
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectedIngredientsList extends StatelessWidget {
  const _SelectedIngredientsList({
    required this.items,
    required this.isTurkish,
    required this.onRemove,
    required this.onAddTap,
  });

  final List<Ingredient> items;
  final bool isTurkish;
  final ValueChanged<Ingredient> onRemove;
  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return InkWell(
        onTap: onAddTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.blueGrey.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.blueGrey.withValues(alpha: 0.08)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.inventory_2_outlined,
                  color: AppTheme.seedColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'selectionIngredientEmpty'.tr(),
                  style: formTextStyle(textColor: Colors.blueGrey.shade700),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 140),
      child: SingleChildScrollView(
        primary: false,
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((ingredient) {
            final String ingredientName = isTurkish
                ? ingredient.nameTr
                : ingredient.name;
            return Container(
              constraints: const BoxConstraints(maxWidth: 260),
              padding: const EdgeInsets.fromLTRB(12, 8, 6, 8),
              decoration: BoxDecoration(
                color: AppTheme.surfaceMuted,
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                border: Border.all(color: AppTheme.line),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_rounded,
                    size: 16,
                    color: AppTheme.herb,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      ingredientName,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.labelMedium?.copyWith(color: AppTheme.ink),
                    ),
                  ),
                  const SizedBox(width: 2),
                  IconButton(
                    tooltip: 'remove'.tr(),
                    visualDensity: VisualDensity.compact,
                    onPressed: () => onRemove(ingredient),
                    icon: const Icon(Icons.close_rounded, size: 17),
                    color: AppTheme.mutedInk,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.seedColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppTheme.seedColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

Future<List<Ingredient>> fetchFilteredData({
  required String query,
  required String tableName,
  required BuildContext context,
}) async {
  if (query.isEmpty) return <Ingredient>[];
  try {
    final bool isTurkish = Localizations.localeOf(context).languageCode == 'tr';
    return await BackendService.searchIngredients(
      query: query,
      tableName: tableName,
      isTurkish: isTurkish,
    );
  } catch (e) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("error".tr(), style: formTextStyle()),
        content: Text(e.toString(), style: formTextStyle()),
      ),
    );
    return <Ingredient>[];
  }
}
