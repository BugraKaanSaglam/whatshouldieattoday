// ignore_for_file: use_build_context_synchronously, deprecated_member_use
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:yemek_tarifi_app/screens/credits_screen.dart';
import 'package:yemek_tarifi_app/screens/favorites_screen.dart';
import 'package:yemek_tarifi_app/screens/foodselection_screen.dart';
import 'package:yemek_tarifi_app/screens/initialingredientsselector_screen.dart';
import 'package:yemek_tarifi_app/screens/settings_screen.dart';
import 'package:yemek_tarifi_app/services/maintenance_service.dart';
import '../viewmodels/main_viewmodel.dart';
import '../global/global_functions.dart';
import '../global/global_variables.dart';
import '../global/media_query_size.dart';
import '../global/app_theme.dart';

class MainScreen extends StatefulWidget {
  final MaintenanceStatus? maintenanceStatus;

  const MainScreen({super.key, this.maintenanceStatus});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final MainViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = MainViewModel()..init();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.scheduleInitialPopup(() async {
        if (!mounted) return;
        await showDialog(context: context, builder: (context) => warntoAddInitIngredientsPopup(context));
      });
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = SizerMediaQuery.getH(context);
    screenWidth = SizerMediaQuery.getW(context);
    final bool isMaintenance = widget.maintenanceStatus?.isActive == true;
    final String maintenanceMessage = _maintenanceMessage(context);
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<MainViewModel>(
        builder: (context, viewModel, _) => globalScaffold(
          appBar: globalAppBar('appName'.tr(), context, hasBackButton: false),
          body: mainBody(context, isMaintenance, viewModel),
          bottomAppbar: isMaintenance ? _buildMaintenanceBar(context, maintenanceMessage) : null,
        ),
      ),
    );
  }

  Widget mainBody(BuildContext context, bool isMaintenance, MainViewModel viewModel) {
    final int ingredientsCount = globalDataBase?.initialIngredients.length ?? 0;
    final int? totalCount = viewModel.totalRecipeCount;
    final String totalRecipesLabel = totalCount == null ? 'loading'.tr() : '$totalCount ${'recipes'.tr()}';

    final List<_MenuItemData> menuItems = [
      _MenuItemData(
        title: 'startCooking'.tr(),
        destination: const FoodSelectionScreen(),
        icon: Icons.dining_outlined,
        gradientColors: const [Color(0xFFFF9A8B), Color(0xFFF97316)],
        chipLabel: totalRecipesLabel,
        chipBlinking: true,
        disabled: isMaintenance,
      ),
      _MenuItemData(
        title: 'favorites'.tr(),
        destination: const FavoritesScreen(),
        icon: Icons.favorite_border_outlined,
        gradientColors: const [Color(0xFFFB7185), Color(0xFFEC4899)],
        disabled: isMaintenance,
      ),
      _MenuItemData(
        title: 'initialIngredientsSelectorScreenTitle'.tr(),
        destination: const InitialIngredientsSelectorScreen(),
        icon: Icons.kitchen_outlined,
        gradientColors: const [Color(0xFF8B5CF6), Color(0xFF6366F1)],
        highlightIfEmpty: true,
        chipLabel: 'storedIngredientsCount'.tr(args: [ingredientsCount.toString()]),
        disabled: isMaintenance,
      ),
      _MenuItemData(
        title: 'settingsTitle'.tr(),
        destination: const SettingsScreen(),
        icon: Icons.settings,
        gradientColors: const [Color(0xFF38BDF8), Color(0xFF0EA5E9)],
      ),
      _MenuItemData(
        title: 'creditsTitle'.tr(),
        destination: const CreditsScreen(),
        icon: Icons.front_hand_outlined,
        gradientColors: const [Color(0xFF34D399), Color(0xFF22C55E)],
      ),
      _MenuItemData(
        title: 'exit'.tr(),
        icon: Icons.exit_to_app_outlined,
        gradientColors: const [Color(0xFFEF4444), Color(0xFFDC2626)],
        onTapOverride: _handleExit,
      ),
    ];

    return SingleChildScrollView(padding: const EdgeInsets.fromLTRB(20, 24, 20, 120), child: _buildMenuGrid(menuItems, viewModel.isBlinking));
  }

  Widget _buildMenuGrid(List<_MenuItemData> menuItems, bool isBlinking) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: menuItems.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        final item = menuItems[index];
        final bool shouldBlink = item.highlightIfEmpty && isBlinking;
        return _AnimatedMenuTile(
          index: index,
          child: _BlinkingMenuItem(
            isBlinking: shouldBlink,
            child: _DashboardTile(
              item: item,
              onTap: item.disabled
                  ? null
              : () async {
                  if (item.onTapOverride != null) {
                    item.onTapOverride!.call();
                    return;
                  }
                  if (item.destination == null) return;
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => item.destination!));
                  if (!mounted) return;
                  setState(() {});
                },
            ),
          ),
        );
      },
    );
  }

  String _maintenanceMessage(BuildContext context) {
    return 'maintenanceBody'.tr();
  }

  void _handleExit() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
      return;
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('closeAppHint'.tr()),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildMaintenanceBar(BuildContext context, String message) {
    final theme = Theme.of(context);
    const Color barColor = Color(0xFFF97316);
    final String staticDescription = 'maintenanceStaticDescription'.tr();
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: barColor.withValues(alpha: 0.26), blurRadius: 12, offset: const Offset(0, 6))],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.16), shape: BoxShape.circle),
                child: const Icon(Icons.build_circle_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('maintenanceBadge'.tr(), style: theme.textTheme.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(
                      staticDescription,
                      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Dialog warntoAddInitIngredientsPopup(BuildContext context) {
    return Dialog(
      elevation: 20,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), // Rounded corners
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade400, Colors.purple.shade600], // Modern gradient effect
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated icon
            TweenAnimationBuilder<double>(duration: const Duration(milliseconds: 800), tween: Tween(begin: 0.0, end: 1.0), builder: (context, value, child) => Transform.scale(scale: value, child: child), child: const Icon(Icons.kitchen, color: Colors.white, size: 50)),
            const SizedBox(height: 15),
            // Title
            Text('myKitchen'.tr(), style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2)),
            const SizedBox(height: 10),
            // Subtitle
            Text('IfYouSaveYourCookingIngredientsinMyKitchenYouWontHaveToSelectThemAgainEveryTime'.tr(), textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: Colors.white70, height: 1.5)),
            const SizedBox(height: 20),
            // Close Button
            ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.purple.shade700, padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), child: Text('Ok'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }
}

class _MenuItemData {
  final String title;
  final Widget? destination;
  final IconData icon;
  final List<Color> gradientColors;
  final bool highlightIfEmpty;
  final VoidCallback? onTapOverride;
  final String? chipLabel;
  final bool chipBlinking;
  final bool disabled;

  const _MenuItemData({
    required this.title,
    required this.icon,
    required this.gradientColors,
    this.destination,
    this.highlightIfEmpty = false,
    this.onTapOverride,
    this.chipLabel,
    this.chipBlinking = false,
    this.disabled = false,
  });
}

class _AnimatedMenuTile extends StatelessWidget {
  final int index;
  final Widget child;

  const _AnimatedMenuTile({required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 450 + (index * 80)),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        final double opacity = value.clamp(0, 1);
        return Transform.translate(
          offset: Offset(0, (1 - value) * 24),
          child: Transform.scale(
            scale: 0.94 + (0.06 * value),
            child: Opacity(opacity: opacity, child: child),
          ),
        );
      },
      child: child,
    );
  }
}

class _DashboardTile extends StatelessWidget {
  final _MenuItemData item;
  final Future<void> Function()? onTap;

  const _DashboardTile({required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bool disabled = item.disabled;
    final List<Color> colors = disabled ? [Colors.grey.shade400, Colors.grey.shade500] : item.gradientColors;
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: onTap == null ? null : () async => await onTap!(),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(color: (disabled ? Colors.grey : item.gradientColors.last).withValues(alpha: 0.28), blurRadius: 24, offset: const Offset(0, 12)),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -18,
              top: -18,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), shape: BoxShape.circle),
              ),
            ),
            Positioned(
              left: -24,
              bottom: -24,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), shape: BoxShape.circle),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.22), shape: BoxShape.circle),
                      child: Icon(item.icon, color: Colors.white, size: 28),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      item.title,
                      style: textTheme.titleLarge?.copyWith(color: Colors.white, fontSize: 17),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (disabled) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.25), borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.lock_clock_rounded, size: 14, color: Colors.white),
                            const SizedBox(width: 6),
                            Text(
                              'maintenanceBadge'.tr(),
                              style: textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (item.chipLabel != null) ...[
                      const SizedBox(height: 12),
                      _PulsingBadge(
                        enabled: item.chipBlinking,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                          child: Text(
                            item.chipLabel!,
                            style: textTheme.bodySmall?.copyWith(color: AppTheme.seedColor, fontWeight: FontWeight.w700, fontSize: 12),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PulsingBadge extends StatefulWidget {
  final Widget child;
  final bool enabled;

  const _PulsingBadge({required this.child, required this.enabled});

  @override
  State<_PulsingBadge> createState() => _PulsingBadgeState();
}

class _PulsingBadgeState extends State<_PulsingBadge> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    if (widget.enabled) _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant _PulsingBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.enabled && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double scale = 0.96 + (0.08 * (_controller.value));
        final double opacity = 0.7 + (0.3 * (_controller.value));
        return Opacity(
          opacity: widget.enabled ? opacity : 1,
          child: Transform.scale(scale: widget.enabled ? scale : 1, child: child),
        );
      },
      child: widget.child,
    );
  }
}

class _BlinkingMenuItem extends StatefulWidget {
  final Widget child;
  final bool isBlinking;

  const _BlinkingMenuItem({required this.child, required this.isBlinking});

  @override
  __BlinkingMenuItemState createState() => __BlinkingMenuItemState();
}

class __BlinkingMenuItemState extends State<_BlinkingMenuItem> {
  double _opacity = 1.0;
  double _scale = 1.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.isBlinking) _startBlinking();
  }

  @override
  void didUpdateWidget(covariant _BlinkingMenuItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isBlinking && _timer == null) {
      _startBlinking();
    } else if (!widget.isBlinking && _timer != null) {
      _timer?.cancel();
      _timer = null;
      setState(() {
        _opacity = 1.0;
        _scale = 1.0;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startBlinking() {
    _timer = Timer.periodic(const Duration(milliseconds: 700), (timer) {
      setState(() {
        _opacity = _opacity == 1.0 ? 0.45 : 1.0;
        _scale = _scale == 1.0 ? 0.94 : 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 360),
      opacity: widget.isBlinking ? _opacity : 1.0,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 360),
        scale: widget.isBlinking ? _scale : 1.0,
        child: widget.child,
      ),
    );
  }
}
