import 'package:flutter/material.dart';

import 'package:yemek_tarifi_app/global/app_theme.dart';

/// A quiet, reusable surface for content that needs separation from the
/// photographic background without looking like a default Material card.
class AppSurface extends StatelessWidget {
  const AppSurface({
    super.key,
    required this.child,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.all(20),
    this.color,
    this.borderRadius = AppTheme.radiusLarge,
    this.border,
    this.shadow = AppTheme.softShadow,
    this.clipBehavior = Clip.none,
  });

  final Widget child;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final double borderRadius;
  final Border? border;
  final List<BoxShadow>? shadow;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      clipBehavior: clipBehavior,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? AppTheme.surface.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(borderRadius),
        border:
            border ?? Border.all(color: AppTheme.line.withValues(alpha: 0.8)),
        boxShadow: shadow,
      ),
      child: child,
    );
  }
}

class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    super.key,
    required this.title,
    this.description,
    this.icon,
  });

  final String title;
  final String? description;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppTheme.seedColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(icon, color: AppTheme.seedColor, size: 20),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleLarge),
              if (description != null) ...[
                const SizedBox(height: 4),
                Text(description!, style: theme.textTheme.bodyMedium),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({super.key, this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.4,
            color: AppTheme.seedColor,
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: 12),
          Text(label!, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ],
    );
  }
}

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final String? message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return AppSurface(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppTheme.seedColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Icon(icon, size: 32, color: AppTheme.seedColor),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          if (message != null) ...[
            const SizedBox(height: 8),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
          if (action != null) ...[const SizedBox(height: 18), action!],
        ],
      ),
    );
  }
}
