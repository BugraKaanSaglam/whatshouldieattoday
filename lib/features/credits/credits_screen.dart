// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yemek_tarifi_app/core/widgets/app_scaffold.dart';
import 'package:yemek_tarifi_app/core/widgets/main_app_bar.dart';
import 'package:yemek_tarifi_app/core/utils/ui_helpers.dart';

const String _odblUrl = 'https://opendatacommons.org/licenses/odbl/1-0/';

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  Future<void> _openLicense(BuildContext context) async {
    final Uri uri = Uri.parse(_odblUrl);
    final bool launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('couldNotOpenLink'.tr())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: MainAppBar(title: 'creditsTitle'.tr()),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CreditsCard(
              title: 'creditsTitle2'.tr(),
              children: [
                Text('creatorName1'.tr(), style: normalTextStyle()),
              ],
            ),
            const SizedBox(height: 14),
            _CreditsCard(
              title: 'dataSourceTitle'.tr(),
              subtitle: 'dataSourceSubtitle'.tr(),
              children: [
                _InfoBlock(label: 'dataSourceNameLabel'.tr(), value: 'dataSourceNameValue'.tr()),
                const SizedBox(height: 10),
                _InfoBlock(label: 'dataSourceLicenseLabel'.tr(), value: 'dataSourceLicenseValue'.tr()),
                const SizedBox(height: 12),
                SelectableText('dataSourceShortAttribution'.tr(), style: normalTextStyle()),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton.icon(
                    onPressed: () async => _openLicense(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      foregroundColor: const Color(0xFF2563EB),
                      side: const BorderSide(color: Color(0xFF2563EB)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.launch_rounded, size: 18),
                    label: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('viewLicense'.tr(), style: labelTextStyle().copyWith(color: const Color(0xFF2563EB))),
                        const SizedBox(height: 2),
                        Text('viewLicenseDescription'.tr(), style: normalTextStyle().copyWith(fontSize: 13, color: const Color(0xFF1F2937))),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'dataSourceAffiliationNote'.tr(),
                  style: normalTextStyle().copyWith(color: const Color(0xFF374151), fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CreditsCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> children;

  const _CreditsCard({required this.title, this.subtitle, required this.children});

  @override
  Widget build(BuildContext context) {
    final TextStyle baseTextStyle = normalTextStyle();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: labelTextStyle()),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle!, style: baseTextStyle.copyWith(color: const Color(0xFF4B5563), fontSize: 15)),
          ],
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final String label;
  final String value;

  const _InfoBlock({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: labelTextStyle()),
        const SizedBox(height: 4),
        SelectableText(value, style: normalTextStyle()),
      ],
    );
  }
}
