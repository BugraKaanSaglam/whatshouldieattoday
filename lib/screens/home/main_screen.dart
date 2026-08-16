import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:yemek_tarifi_app/core/configs/router/app_routes.dart';
import 'package:yemek_tarifi_app/core/network/connection_monitor.dart';
import 'package:yemek_tarifi_app/core/network/maintenance_service.dart';
import 'package:yemek_tarifi_app/providers/home/main_viewmodel.dart';
import 'package:yemek_tarifi_app/global/app_globals.dart';
import 'package:yemek_tarifi_app/core/utils/media_query_size.dart';
import 'package:yemek_tarifi_app/widgets/app_scaffold.dart';
import 'package:yemek_tarifi_app/widgets/main_app_bar.dart';
import 'package:yemek_tarifi_app/widgets/offline/offline_favorites_view.dart';

class MainScreen extends StatefulWidget {
  final MaintenanceStatus? maintenanceStatus;
  final MainViewModel? viewModel;
  final ConnectionMonitor? connectionMonitor;

  const MainScreen({
    super.key,
    this.maintenanceStatus,
    this.viewModel,
    this.connectionMonitor,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final MainViewModel _viewModel;
  late final ConnectionMonitor _connectionMonitor;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel ?? MainViewModel();
    _connectionMonitor = widget.connectionMonitor ?? ConnectionMonitor.shared;
    _viewModel.init();
  }

  @override
  void dispose() {
    if (widget.viewModel == null) {
      _viewModel.dispose();
    }
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
        builder: (context, viewModel, _) => AnimatedBuilder(
          animation: _connectionMonitor,
          builder: (context, _) => AppScaffold(
            appBar: MainAppBar(title: 'appName'.tr(), hasBackButton: false),
            body: _connectionMonitor.isOnline
                ? mainBody(context, isMaintenance, viewModel)
                : OfflineFavoritesView(
                    onFavoritesChanged: () => setState(() {}),
                  ),
            bottomBar: isMaintenance
                ? _buildMaintenanceBar(context, maintenanceMessage)
                : null,
          ),
        ),
      ),
    );
  }

  Widget mainBody(
    BuildContext context,
    bool isMaintenance,
    MainViewModel viewModel,
  ) {
    final List<_MenuItemData> menuItems = [
      _MenuItemData(
        title: 'favorites'.tr(),
        routePath: AppRoutes.favorites,
        icon: Icons.favorite_border_outlined,
        gradientColors: const [Color(0xFFE9B8A4), Color(0xFFB65C45)],
        disabled: isMaintenance,
      ),
      _MenuItemData(
        title: 'initialIngredientsSelectorScreenTitle'.tr(),
        routePath: AppRoutes.kitchen,
        icon: Icons.kitchen_outlined,
        gradientColors: const [Color(0xFFD8C3A5), Color(0xFF8D6E53)],
        highlightIfEmpty: true,
        disabled: isMaintenance,
      ),
      _MenuItemData(
        title: 'settingsTitle'.tr(),
        routePath: AppRoutes.settings,
        icon: Icons.settings,
        gradientColors: const [Color(0xFFD3D0C9), Color(0xFF70665A)],
      ),
      _MenuItemData(
        title: 'creditsTitle'.tr(),
        routePath: AppRoutes.credits,
        icon: Icons.front_hand_outlined,
        gradientColors: const [Color(0xFFD1B9A7), Color(0xFF8E5E4D)],
      ),
      _MenuItemData(
        title: 'exit'.tr(),
        icon: Icons.exit_to_app_outlined,
        gradientColors: const [Color(0xFFE4B5AA), Color(0xFFB34B43)],
        onTapOverride: _handleExit,
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHomeHero(context, isMaintenance: isMaintenance),
          const SizedBox(height: 20),
          _buildMenuGrid(menuItems, viewModel.isBlinking),
        ],
      ),
    );
  }

  Widget _buildHomeHero(BuildContext context, {required bool isMaintenance}) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF251914), Color(0xFF6A392B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6A392B).withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -52,
            top: -64,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),
          ),
          Positioned(
            left: -42,
            bottom: -86,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withValues(alpha: 0.08),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.asset(
                        'assets/icon/icon.png',
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 52,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3D8A8).withValues(alpha: 0.72),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'homeHeroTitle'.tr(),
                  style: theme.textTheme.displayLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 28,
                    height: 1.08,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'homeHeroBody'.tr(),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.78),
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: isMaintenance
                        ? null
                        : () => context.push(AppRoutes.recipes),
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: Text('startCooking'.tr()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF3D8A8),
                      foregroundColor: const Color(0xFF2B1D17),
                      disabledBackgroundColor: Colors.white24,
                      disabledForegroundColor: Colors.white54,
                      elevation: 0,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid(List<_MenuItemData> menuItems, bool isBlinking) {
    return Column(
      children: List.generate(menuItems.length, (index) {
        final item = menuItems[index];
        final bool shouldBlink = item.highlightIfEmpty && isBlinking;
        return Padding(
          padding: EdgeInsets.only(
            bottom: index == menuItems.length - 1 ? 0 : 10,
          ),
          child: SizedBox(
            width: double.infinity,
            height: 92,
            child: _AnimatedMenuTile(
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
                          if (item.routePath == null) return;
                          await context.push(item.routePath!);
                          if (!mounted) return;
                          setState(() {});
                        },
                ),
              ),
            ),
          ),
        );
      }),
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
            boxShadow: [
              BoxShadow(
                color: barColor.withValues(alpha: 0.26),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.build_circle_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'maintenanceBadge'.tr(),
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      staticDescription,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
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
}

class _MenuItemData {
  final String title;
  final String? routePath;
  final IconData icon;
  final List<Color> gradientColors;
  final bool highlightIfEmpty;
  final VoidCallback? onTapOverride;
  final bool disabled;

  const _MenuItemData({
    required this.title,
    required this.icon,
    required this.gradientColors,
    this.routePath,
    this.highlightIfEmpty = false,
    this.onTapOverride,
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
      duration: Duration(milliseconds: 360 + (index * 50)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        final double opacity = value.clamp(0, 1);
        return Transform.translate(
          offset: Offset(0, (1 - value) * 24),
          child: Transform.scale(
            scale: 0.98 + (0.02 * value),
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
    final Color accent = disabled
        ? const Color(0xFF9CA3AF)
        : item.gradientColors.last;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap == null ? null : () async => await onTap!(),
      child: Container(
        decoration: BoxDecoration(
          color: disabled
              ? const Color(0xFFE8E2DC)
              : Colors.white.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: accent.withValues(alpha: 0.24)),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.12),
              blurRadius: 18,
              offset: const Offset(0, 9),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -24,
              top: -42,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.06),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: -36,
              bottom: -54,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.04),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(item.icon, color: accent, size: 23),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: textTheme.titleMedium?.copyWith(
                            color: const Color(0xFF2B211C),
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (disabled)
                          Text(
                            'maintenanceBadge'.tr(),
                            style: textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF7A6E65),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 17,
                    color: accent,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
