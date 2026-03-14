// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:yemek_tarifi_app/database/db_helper.dart';
import 'package:yemek_tarifi_app/widgets/recipes/food_selection_helpers.dart';
import 'package:yemek_tarifi_app/widgets/app_scaffold.dart';
import 'package:yemek_tarifi_app/widgets/main_app_bar.dart';
import 'package:yemek_tarifi_app/models/recipe/ingredient.dart';
import 'package:yemek_tarifi_app/core/utils/form_decorations.dart';
import 'package:yemek_tarifi_app/global/app_globals.dart';
import 'package:easy_localization/easy_localization.dart';

class KitchenScreen extends StatefulWidget {
  const KitchenScreen({super.key});

  @override
  State<KitchenScreen> createState() => _KitchenScreenState();
}

class _KitchenScreenState extends State<KitchenScreen> {
  List<Ingredient> _selectedIngredients = [];
  Key _dropdownKey = UniqueKey(); // Dropdown'ı yeniden oluşturmak için bir key

  @override
  void initState() {
    super.initState();
    _selectedIngredients = globalDataBase!.initialIngredients;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: MainAppBar(title: 'initialIngredientsSelectorScreenTitle'.tr()),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          _buildHeroCard(context),
          const SizedBox(height: 16),
          IngredientSearchDropdown(
            key: _dropdownKey,
            dropdownSelectedItems: _selectedIngredients,
            onItemsChanged: (List<Ingredient> selectedItems) {
              setState(() => _selectedIngredients = selectedItems);
            },
          ),
          const SizedBox(height: 16),
          _buildActionCard(context),
        ],
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F766E).withValues(alpha: 0.18),
            blurRadius: 20,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.kitchen_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'initialIngredientsSelectorScreenTitle'.tr(),
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'kitchenHeroBody'.tr(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.86),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _KitchenStatChip(
                icon: Icons.bookmark_added_rounded,
                label: 'storedIngredientsCount'.tr(
                  args: [_selectedIngredients.length.toString()],
                ),
              ),
              _KitchenStatChip(
                icon: Icons.cloud_done_rounded,
                label: 'favoritesOfflineHintTitle'.tr(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('save'.tr(), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            'kitchenSaveActionBody'.tr(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: saveButton()),
          const SizedBox(height: 18),
          Text(
            'deleteAllSavedIngredients'.tr(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            'kitchenDeleteActionBody'.tr(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: deleteAllSavedIngredients()),
        ],
      ),
    );
  }

  ElevatedButton saveButton() {
    return ElevatedButton.icon(
      onPressed: () {
        globalDataBase!.initialIngredients = _selectedIngredients;
        DBHelper().update(globalDataBase!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 10),
                Text('success'.tr()),
              ],
            ),
            backgroundColor: Colors.green.withValues(alpha: 0.9),
            elevation: 10,
            duration: const Duration(seconds: 2),
          ),
        );
      },
      icon: const Icon(Icons.save, color: Colors.white),
      label: Text("save".tr(), style: buttonTextStyle()),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        minimumSize: const Size.fromHeight(54),
      ),
    );
  }

  ElevatedButton deleteAllSavedIngredients() {
    return ElevatedButton.icon(
      onPressed: () =>
          showDialog(context: context, builder: (context) => warningDialog()),
      icon: const Icon(Icons.delete_forever, color: Colors.white),
      label: Text("deleteAllSavedIngredients".tr(), style: buttonTextStyle()),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        minimumSize: const Size.fromHeight(54),
      ),
    );
  }

  AlertDialog warningDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Row(
        children: [
          const Icon(Icons.warning, color: Colors.orange, size: 28),
          const SizedBox(width: 10),
          Text(
            'warning'.tr(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Text('areYouSureYouWanttoDeleteAllSavedIngredients'.tr()),
      actions: [
        //* Yes Button
        TextButton.icon(
          onPressed: () {
            globalDataBase!.initialIngredients = [];
            DBHelper().update(globalDataBase!);
            setState(() {
              _selectedIngredients = []; // Yerel listede temizle
              _dropdownKey = UniqueKey(); // Dropdown'u yeniden oluştur
            });
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check, color: Colors.green),
                    const SizedBox(width: 10),
                    Text('success'.tr()),
                  ],
                ),
                backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
                elevation: 10,
                duration: const Duration(seconds: 2),
              ),
            );
          },
          icon: const Icon(Icons.check_circle, color: Colors.green),
          label: Text('yes'.tr()),
        ),
        //* No
        TextButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.cancel, color: Colors.grey),
          label: Text('no'.tr()),
        ),
      ],
    );
  }
}

class _KitchenStatChip extends StatelessWidget {
  const _KitchenStatChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
