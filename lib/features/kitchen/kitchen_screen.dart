// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:yemek_tarifi_app/core/database/db_helper.dart';
import 'package:yemek_tarifi_app/features/recipes/utils/food_selection_helpers.dart';
import 'package:yemek_tarifi_app/core/widgets/app_scaffold.dart';
import 'package:yemek_tarifi_app/core/widgets/main_app_bar.dart';
import 'package:yemek_tarifi_app/features/recipes/models/ingredient.dart';
import 'package:yemek_tarifi_app/core/utils/form_decorations.dart';
import 'package:yemek_tarifi_app/core/utils/ui_helpers.dart';
import 'package:yemek_tarifi_app/core/constants/app_globals.dart';
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
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
              physics: const BouncingScrollPhysics(),
              children: [
                //* Informational card
                customCard('initialIngredientsText1'.tr()),
                const SizedBox(height: 12),
                //* Ingredient search field
                IngredientSearchDropdown(
                  key: _dropdownKey,
                  dropdownSelectedItems: _selectedIngredients,
                  onItemsChanged: (List<Ingredient> selectedItems) {
                    setState(() => _selectedIngredients = selectedItems);
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                saveButton(),
                deleteAllSavedIngredients(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ElevatedButton saveButton() {
    return ElevatedButton.icon(
      onPressed: () {
        globalDataBase!.initialIngredients = _selectedIngredients;
        DBHelper().update(globalDataBase!);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(children: [const Icon(Icons.check_circle, color: Colors.green), const SizedBox(width: 10), Text('success'.tr())]), backgroundColor: Colors.green.withValues(alpha: 0.9), elevation: 10, duration: const Duration(seconds: 2)));
      },
      icon: const Icon(Icons.save, color: Colors.white),
      label: Text("save".tr(), style: buttonTextStyle()),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
    );
  }

  ElevatedButton deleteAllSavedIngredients() {
    return ElevatedButton.icon(
      onPressed: () => showDialog(context: context, builder: (context) => warningDialog()),
      icon: const Icon(Icons.delete_forever, color: Colors.white),
      label: Text("deleteAllSavedIngredients".tr(), style: buttonTextStyle()),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
    );
  }

  AlertDialog warningDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Row(children: [const Icon(Icons.warning, color: Colors.orange, size: 28), const SizedBox(width: 10), Text('warning'.tr(), style: const TextStyle(fontWeight: FontWeight.bold))]),
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
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(children: [const Icon(Icons.check, color: Colors.green), const SizedBox(width: 10), Text('success'.tr())]), backgroundColor: Colors.redAccent.withValues(alpha: 0.9), elevation: 10, duration: const Duration(seconds: 2)));
          },
          icon: const Icon(Icons.check_circle, color: Colors.green),
          label: Text('yes'.tr()),
        ),
        //* No
        TextButton.icon(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.cancel, color: Colors.grey), label: Text('no'.tr())),
      ],
    );
  }
}
