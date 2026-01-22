import 'package:flutter/material.dart';

import 'package:yemek_tarifi_app/core/utils/form_decorations.dart';
import 'package:yemek_tarifi_app/widgets/app_scaffold.dart';
import 'package:yemek_tarifi_app/widgets/main_app_bar.dart';
import 'package:yemek_tarifi_app/global/app_theme.dart';

@Deprecated('Use MainAppBar instead.')
PreferredSizeWidget globalAppBar(String title, BuildContext _, {bool hasBackButton = true}) {
  return MainAppBar(title: title, hasBackButton: hasBackButton);
}

@Deprecated('Use AppScaffold instead.')
Widget globalScaffold({PreferredSizeWidget? appBar, Widget? body, Widget? bottomAppbar}) {
  return AppScaffold(appBar: appBar, body: body, bottomBar: bottomAppbar);
}

TextStyle labelTextStyle() => const TextStyle(fontSize: 18, color: AppTheme.seedColor, fontWeight: FontWeight.bold);
TextStyle normalTextStyle() => const TextStyle(fontSize: 16, color: Color(0xFF1F2937), fontWeight: FontWeight.w400);

Card customCard(String cardString) {
  return Card(
    margin: const EdgeInsets.all(8.0),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(cardString, style: formTextStyle(textColor: const Color(0xFF1F2937), fontSize: 16)),
    ),
  );
}
