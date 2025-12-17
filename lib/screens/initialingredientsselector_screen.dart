// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:yemek_tarifi_app/database/db_helper.dart';
import 'package:yemek_tarifi_app/functions/foodselection_screen_functions.dart';
import '../classes/ingredient_class.dart';
import '../functions/form_decorations.dart';
import '../global/global_functions.dart';
import '../global/global_variables.dart';
import 'package:easy_localization/easy_localization.dart';

class InitialIngredientsSelectorScreen extends StatefulWidget {
  const InitialIngredientsSelectorScreen({super.key});

  @override
  State<InitialIngredientsSelectorScreen> createState() => _InitialIngredientsSelectorScreenState();
}

class _InitialIngredientsSelectorScreenState extends State<InitialIngredientsSelectorScreen> {
  List<IngredientClass> _selectedIngredients = [];
  Key _dropdownKey = UniqueKey(); // Dropdown'ı yeniden oluşturmak için bir key

  @override
  void initState() {
    super.initState();
    _selectedIngredients = globalDataBase!.initialIngredients;
  }

  @override
  Widget build(BuildContext context) {
    return globalScaffold(
      appBar: globalAppBar('initialIngredientsSelectorScreenTitle'.tr(), context),
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
                  onItemsChanged: (List<IngredientClass> selectedItems) {
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
