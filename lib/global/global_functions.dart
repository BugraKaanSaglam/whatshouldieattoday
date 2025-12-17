import 'package:flutter/material.dart';

import '../functions/form_decorations.dart';
import 'app_theme.dart';
import 'global_variables.dart';

AppBar globalAppBar(String title, BuildContext context, {bool hasBackButton = true}) {
  final bool showBackButton = hasBackButton && Navigator.of(context).canPop();
  return AppBar(
    toolbarHeight: appBarHeight + 16,
    automaticallyImplyLeading: false,
    leadingWidth: 72,
    leading: showBackButton
        ? Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(14)),
              child: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18), onPressed: () => Navigator.pop(context)),
            ),
          )
        : null,
    title: Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
    centerTitle: true,
    flexibleSpace: Container(decoration: const BoxDecoration(gradient: AppTheme.appBarGradient)),
  );
}

SafeArea globalScaffold({AppBar? appBar, Widget? body, Widget? bottomAppbar}) {
  return SafeArea(
    child: Container(
      decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        appBar: appBar,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: body ?? const SizedBox(),
        ),
        bottomNavigationBar: bottomAppbar == null
            ? null
            : DecoratedBox(
                decoration: BoxDecoration(
                  gradient: AppTheme.appBarGradient,
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, -2))],
                ),
                child: bottomAppbar,
              ),
      ),
    ),
  );
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
