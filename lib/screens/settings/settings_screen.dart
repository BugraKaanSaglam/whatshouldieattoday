// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yemek_tarifi_app/core/share/app_share_service.dart';
import 'package:yemek_tarifi_app/core/utils/form_decorations.dart';
import 'package:yemek_tarifi_app/core/utils/locale_utils.dart';
import 'package:yemek_tarifi_app/database/db_helper.dart';
import 'package:yemek_tarifi_app/enums/language_enum.dart';
import 'package:yemek_tarifi_app/global/app_globals.dart';
import 'package:yemek_tarifi_app/global/app_theme.dart';
import 'package:yemek_tarifi_app/widgets/app_scaffold.dart';
import 'package:yemek_tarifi_app/widgets/main_app_bar.dart';

typedef SettingsShareHandler =
    Future<void> Function(String subject, String text);
typedef SettingsUrlLauncher = Future<bool> Function(Uri uri);

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, this.shareHandler, this.urlLauncher});

  final SettingsShareHandler? shareHandler;
  final SettingsUrlLauncher? urlLauncher;

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
    _selectedLanguage = Language.getLanguageFromString(
      context.locale.languageCode,
    ).value;
    _didInitLocale = true;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: MainAppBar(title: 'settingsTitle'.tr()),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        children: [
          _buildHeroCard(context),
          const SizedBox(height: 18),
          _buildSectionCard(
            context,
            icon: Icons.tune_rounded,
            title: 'settingsPreferencesTitle'.tr(),
            body: 'settingsPreferencesBody'.tr(),
            child: _buildLanguageField(context),
          ),
          const SizedBox(height: 18),
          _buildSectionCard(
            context,
            icon: Icons.ios_share_rounded,
            title: 'shareAppTitle'.tr(),
            body: 'shareAppBody'.tr(),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: _shareApp,
                  icon: const Icon(Icons.send_rounded),
                  label: Text(
                    'shareAppAction'.tr(),
                    style: buttonTextStyle(fontSize: 15),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => _launchStoreUrl(AppShareService.appStoreUri),
                  icon: const Icon(Icons.apple_rounded),
                  label: Text('openAppStore'.tr()),
                ),
                OutlinedButton.icon(
                  onPressed: () =>
                      _launchStoreUrl(AppShareService.playStoreUri),
                  icon: const Icon(Icons.android_rounded),
                  label: Text('openPlayStore'.tr()),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _saveSettings,
              icon: const Icon(Icons.save_alt_rounded),
              label: Text('save'.tr(), style: buttonTextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    final theme = Theme.of(context);
    final int favoritesCount = globalDataBase?.favorites.length ?? 0;
    final int ingredientsCount = globalDataBase?.initialIngredients.length ?? 0;

    return Container(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF111827), Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D4ED8).withValues(alpha: 0.24),
            blurRadius: 24,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  'settingsHeroTitle'.tr(),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'settingsHeroBody'.tr(),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.82),
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _HeroStatChip(
                icon: Icons.favorite_rounded,
                label: 'settingsFavoritesStat'.tr(
                  args: [favoritesCount.toString()],
                ),
              ),
              _HeroStatChip(
                icon: Icons.kitchen_rounded,
                label: 'storedIngredientsCount'.tr(
                  args: [ingredientsCount.toString()],
                ),
              ),
              _HeroStatChip(
                icon: Icons.cloud_done_rounded,
                label: 'favoritesOfflineHintTitle'.tr(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String body,
    required Widget child,
  }) {
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.seedColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: AppTheme.seedColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(body, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }

  Widget _buildLanguageField(BuildContext context) {
    return DropdownButtonFormField<int>(
      dropdownColor: Colors.white,
      initialValue: _selectedLanguage,
      decoration: formDecoration().copyWith(labelText: 'select_language'.tr()),
      items: [
        DropdownMenuItem<int>(value: 0, child: Text('Turkish'.tr())),
        DropdownMenuItem<int>(value: 1, child: Text('English'.tr())),
      ],
      onChanged: (value) {
        if (value == null) return;
        setState(() => _selectedLanguage = value);
      },
    );
  }

  String _buildShareText() {
    return 'shareAppMessage'.tr(
      args: [
        AppShareService.appStoreUri.toString(),
        AppShareService.playStoreUri.toString(),
      ],
    );
  }

  Future<void> _shareApp() async {
    await AppShareService.shareApp(
      subject: 'appName'.tr(),
      text: _buildShareText(),
      shareRunner: widget.shareHandler,
    );
  }

  Future<void> _launchStoreUrl(Uri uri) async {
    final SettingsUrlLauncher launcher =
        widget.urlLauncher ??
        (Uri url) => launchUrl(url, mode: LaunchMode.externalApplication);
    final bool opened = await launcher(uri);
    if (opened || !mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('couldNotOpenLink'.tr())));
  }

  Future<void> _saveSettings() async {
    globalDataBase?.languageCode = _selectedLanguage;
    if (globalDataBase != null) {
      await DBHelper().update(globalDataBase!);
    }
    await context.setLocale(
      languageToLocale(Language.getLanguageFromValue(_selectedLanguage)),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 10),
            Text('languageSaved'.tr()),
          ],
        ),
        backgroundColor: AppTheme.seedColor,
        elevation: 10,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _HeroStatChip extends StatelessWidget {
  const _HeroStatChip({required this.icon, required this.label});

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
