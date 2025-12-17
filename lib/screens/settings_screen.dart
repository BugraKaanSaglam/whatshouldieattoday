// ignore_for_file: must_be_immutable, use_build_context_synchronously, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:yemek_tarifi_app/enums/language_enum.dart';
import 'package:yemek_tarifi_app/functions/form_decorations.dart';
import 'package:yemek_tarifi_app/main.dart';
import '../database/db_helper.dart';
import '../global/global_functions.dart';
import '../global/global_variables.dart';
import 'package:easy_localization/easy_localization.dart';
import '../global/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late int _selectedLanguage;
  bool _didInitLocale = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInitLocale) return;
    _selectedLanguage = Language.getLanguageFromString(context.locale.languageCode).value;
    _didInitLocale = true;
  }

  @override
  Widget build(BuildContext context) {
    return globalScaffold(
      appBar: globalAppBar('settingsTitle'.tr(), context),
      body: settingsBody(context),
    );
  }

  Widget settingsBody(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('settingsTitle'.tr(), style: theme.textTheme.headlineMedium?.copyWith(color: Colors.white)),
                    const SizedBox(height: 8),
                    Text('select_language'.tr(), style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                  ],
                ),
                const SizedBox(height: 24),
                languageDropDownFormField(),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity, child: saveButton()),
        ],
      ),
    );
  }

  Widget languageDropDownFormField() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 18, offset: const Offset(0, 12))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppTheme.seedColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(14)),
                child: const Icon(Icons.language, color: AppTheme.seedColor),
              ),
              const SizedBox(width: 12),
              Text('select_language'.tr(), style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            dropdownColor: Colors.white,
            value: _selectedLanguage,
            decoration: formDecoration(),
            items: [
              DropdownMenuItem<int>(value: 0, child: Text('Turkish'.tr())),
              DropdownMenuItem<int>(value: 1, child: Text('English'.tr())),
            ],
            onChanged: (v) {
              if (v == null) return;
              setState(() => _selectedLanguage = v);
            },
          ),
        ],
      ),
    );
  }

  ElevatedButton saveButton() {
    return ElevatedButton.icon(
      onPressed: () async {
        globalDataBase?.languageCode = _selectedLanguage;
        DBHelper().update(globalDataBase!);
        await MainApp.of(context)!.setLocale(
          Language.getLanguageFromValue(_selectedLanguage),
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(children: [const Icon(Icons.check_circle, color: Colors.white), const SizedBox(width: 10), Text('success'.tr())]),
            backgroundColor: AppTheme.seedColor,
            elevation: 10,
            duration: const Duration(seconds: 2),
          ),
        );
      },
      icon: const Icon(Icons.save_alt_rounded),
      label: Text('save'.tr(), style: buttonTextStyle(fontSize: 16)),
    );
  }
}
