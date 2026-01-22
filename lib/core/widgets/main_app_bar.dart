import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:yemek_tarifi_app/core/theme/app_theme.dart';
import 'package:yemek_tarifi_app/core/constants/app_globals.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({
    super.key,
    required this.title,
    this.hasBackButton = true,
    this.actions,
    this.height,
  });

  final String title;
  final bool hasBackButton;
  final List<Widget>? actions;
  final double? height;

  @override
  Size get preferredSize => Size.fromHeight(height ?? appBarHeight + 16);

  @override
  Widget build(BuildContext context) {
    final bool showBackButton = hasBackButton && Navigator.of(context).canPop();
    final double toolbarHeight = height ?? appBarHeight + 16;

    return AppBar(
      toolbarHeight: toolbarHeight,
      automaticallyImplyLeading: false,
      leadingWidth: 72,
      backgroundColor: AppTheme.appBarStart,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      leading: showBackButton
          ? Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            )
          : null,
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
      ),
      centerTitle: true,
      actions: actions,
      flexibleSpace: const DecoratedBox(
        decoration: BoxDecoration(gradient: AppTheme.appBarGradient),
      ),
    );
  }
}
