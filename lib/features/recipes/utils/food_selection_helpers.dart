// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:yemek_tarifi_app/core/services/backend_service.dart';
import 'package:yemek_tarifi_app/core/theme/app_theme.dart';
import 'package:yemek_tarifi_app/features/recipes/models/ingredient.dart';
import 'package:yemek_tarifi_app/core/utils/form_decorations.dart';
import 'package:easy_localization/easy_localization.dart'; // Easy Localization importu

class IngredientSearchDropdown extends StatefulWidget {
  final String tableName;
  final List<Ingredient> dropdownSelectedItems;
  final ValueChanged<List<Ingredient>> onItemsChanged;

  const IngredientSearchDropdown({super.key, this.tableName = 'Ingredients', required this.dropdownSelectedItems, required this.onItemsChanged});

  @override
  _IngredientSearchDropdownState createState() => _IngredientSearchDropdownState();
}

class _IngredientSearchDropdownState extends State<IngredientSearchDropdown> {
  final GlobalKey<DropdownSearchState<Ingredient>> _dropdownKey = GlobalKey<DropdownSearchState<Ingredient>>();
  late List<Ingredient> selectedItems;
  int? _totalIngredients;
  bool _isLoadingCount = false;

  @override
  void initState() {
    super.initState();
    selectedItems = List.from(widget.dropdownSelectedItems);
    _loadIngredientCount();
  }

  void _openPicker() {
    _dropdownKey.currentState?.openDropDownSearch();
  }

  Future<void> _loadIngredientCount() async {
    if (_isLoadingCount) return;
    setState(() => _isLoadingCount = true);
    final int? count = await BackendService.fetchTableCount(tableName: widget.tableName);
    if (!mounted) return;
    setState(() {
      _totalIngredients = count;
      _isLoadingCount = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isTurkish = Localizations.localeOf(context).languageCode == 'tr';
    final theme = Theme.of(context);
    // Supabase column names: "Ingredients", "Ingredients_tr"
    return StatefulBuilder(
      builder: (context, setStateDropdown) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
          child: SafeArea(
            bottom: true,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blueGrey.shade50),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('selectionScreen'.tr(), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(width: 8),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: _openPicker,
                          icon: const Icon(Icons.add_circle_rounded, size: 18),
                          label: Text('addIngredient'.tr()),
                          style: TextButton.styleFrom(
                            foregroundColor: AppTheme.seedColor,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            backgroundColor: AppTheme.seedColor.withValues(alpha: 0.08),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    DropdownSearch<Ingredient>.multiSelection(
                      key: _dropdownKey,
                      items: (filter, loadProps) => fetchFilteredData(query: filter.trim(), tableName: widget.tableName, context: context),
                      popupProps: PopupPropsMultiSelection.modalBottomSheet(
                        showSelectedItems: false,
                        showSearchBox: true,
                        modalBottomSheetProps: const ModalBottomSheetProps(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
                          useSafeArea: true,
                        ),
                        validationBuilder: (ctx, items) {
                          return Builder(
                            builder: (innerContext) {
                              final popupState = innerContext.findAncestorStateOfType<DropdownSearchPopupState<Ingredient>>();
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
                                      setStateDropdown(() => selectedItems = List.from(items));
                                      widget.onItemsChanged(List.from(items));
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
                          final String ingredientName = isTurkish ? ingredient.nameTr : ingredient.name;
                          return ListTile(
                            dense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                            leading: CircleAvatar(
                              radius: 18,
                              backgroundColor: (isSelected ? AppTheme.seedColor : Colors.blueGrey.shade100).withValues(alpha: 0.15),
                              child: Icon(isSelected ? Icons.check_rounded : Icons.add_rounded, color: isSelected ? Colors.white : Colors.black87, size: 18),
                            ),
                            title: Text(ingredientName, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500)),
                            trailing: const SizedBox.shrink(),
                          );
                        },
                        emptyBuilder: (context, searchEntry) => Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text('noIngredientsFound'.tr(), style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700, color: Colors.blueGrey), textAlign: TextAlign.center),
                          ),
                        ),
                      ),
                      decoratorProps: DropDownDecoratorProps(
                        decoration: formDecoration().copyWith(
                          labelText: 'searchForIngredients'.tr(),
                          hintText: 'tapToAddIngredients'.tr(),
                          prefixIcon: const Icon(Icons.playlist_add_rounded, color: AppTheme.seedColor),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                      suffixProps: DropdownSuffixProps(
                        dropdownButtonProps: DropdownButtonProps(
                          iconClosed: Icon(Icons.expand_more_rounded, color: AppTheme.seedColor.withValues(alpha: 0.9)),
                          iconOpened: Icon(Icons.expand_less_rounded, color: AppTheme.seedColor.withValues(alpha: 0.9)),
                        ),
                      ),
                      compareFn: (item, selectedItem) => item.name == selectedItem.name && item.nameTr == selectedItem.nameTr,
                      onChanged: (newSelectedItems) {
                        setStateDropdown(() {
                          selectedItems = List.from(newSelectedItems);
                        });
                        widget.onItemsChanged(List.from(selectedItems));
                      },
                      selectedItems: selectedItems,
                      itemAsString: (Ingredient ingredient) => isTurkish ? ingredient.nameTr : ingredient.name,
                      dropdownBuilder: (context, _) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: _openPicker,
                          child: Row(
                            children: [
                              Icon(Icons.list_alt_rounded, color: AppTheme.seedColor.withValues(alpha: 0.9)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  selectedItems.isEmpty ? 'tapToAddIngredients'.tr() : 'selectedIngredients'.tr(),
                                  style: formTextStyle(textColor: Colors.blueGrey.shade700),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _SelectedIngredientsList(
                      items: selectedItems,
                      isTurkish: isTurkish,
                      onRemove: (ingredient) {
                        setStateDropdown(() => selectedItems.remove(ingredient));
                        widget.onItemsChanged(List.from(selectedItems));
                      },
                      onAddTap: _openPicker,
                      totalAvailable: _totalIngredients,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SelectedIngredientsList extends StatelessWidget {
  final List<Ingredient> items;
  final bool isTurkish;
  final ValueChanged<Ingredient> onRemove;
  final VoidCallback onAddTap;
  final int? totalAvailable;

  const _SelectedIngredientsList({required this.items, required this.isTurkish, required this.onRemove, required this.onAddTap, required this.totalAvailable});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return InkWell(
        onTap: onAddTap,
        borderRadius: BorderRadius.circular(14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.blueGrey.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.inventory_2_outlined, color: Colors.blueGrey),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text('tapToAddIngredients'.tr(), style: formTextStyle(textColor: Colors.blueGrey.shade700))),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6.0),
          child: Row(
            children: [
              Text('selectedIngredients'.tr(), style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.blueGrey.shade800)),
              const Spacer(),
              Text(
                totalAvailable == null ? '' : '${'totalIngredients'.tr()}: $totalAvailable',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.blueGrey.shade700),
              ),
            ],
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 320),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 4),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: items.map((ingredient) {
                final String ingredientName = isTurkish ? ingredient.nameTr : ingredient.name;
                return InputChip(
                  label: Text(ingredientName, overflow: TextOverflow.ellipsis),
                  onDeleted: () => onRemove(ingredient),
                  deleteIcon: const Icon(Icons.close_rounded, size: 18),
                  backgroundColor: Colors.blueGrey.withValues(alpha: 0.08),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

Future<List<Ingredient>> fetchFilteredData({required String query, required String tableName, required BuildContext context}) async {
  if (query.isEmpty) return [];
  try {
    final bool isTurkish = Localizations.localeOf(context).languageCode == 'tr';
    return BackendService.searchIngredients(query: query, tableName: tableName, isTurkish: isTurkish);
  } catch (e) {
    showDialog(context: context, builder: (context) => AlertDialog(title: Text("Error".tr(), style: formTextStyle()), content: Text(e.toString(), style: formTextStyle())));
    return [];
  }
}
