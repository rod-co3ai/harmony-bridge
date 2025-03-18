import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// A customizable card widget for the Harmony Bridge app
class AppCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final double elevation;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final VoidCallback? onTap;
  final bool hasShadow;
  final BorderRadius? customBorderRadius;
  final Gradient? gradient;

  const AppCard({
    super.key,
    required this.child,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 16.0,
    this.elevation = 2.0,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = const EdgeInsets.all(8.0),
    this.onTap,
    this.hasShadow = true,
    this.customBorderRadius,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadiusValue =
        customBorderRadius ?? BorderRadius.circular(borderRadius);

    final BoxDecoration decoration = BoxDecoration(
      color: backgroundColor ?? AppColors.surface,
      borderRadius: borderRadiusValue,
      border: borderColor != null ? Border.all(color: borderColor!) : null,
      gradient: gradient,
      boxShadow: hasShadow
          ? [
              BoxShadow(
                color: Colors.black.withAlpha((0.1 * 255).round()),
                blurRadius: elevation * 2,
                offset: Offset(0, elevation),
              ),
            ]
          : null,
    );

    final Widget cardContent = Container(
      padding: padding,
      decoration: decoration,
      child: child,
    );

    return Container(
      margin: margin,
      child: onTap != null
          ? Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: borderRadiusValue,
                child: cardContent,
              ),
            )
          : cardContent,
    );
  }
}

/// A card with a header, used for sections in the app
class AppSectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onMoreTap;
  final Color? backgroundColor;
  final Color? headerColor;
  final double borderRadius;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final bool hasDivider;

  const AppSectionCard({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
    this.onTap,
    this.onMoreTap,
    this.backgroundColor,
    this.headerColor,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = const EdgeInsets.all(8.0),
    this.hasDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      padding: EdgeInsets.zero,
      margin: margin,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: headerColor ??
                  AppColors.primary.withAlpha((0.05 * 255).round()),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderRadius),
                topRight: Radius.circular(borderRadius),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (trailing != null)
                  trailing!
                else if (onMoreTap != null)
                  TextButton(
                    onPressed: onMoreTap,
                    child: const Text(
                      'See All',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (hasDivider) const Divider(height: 1, thickness: 1),
          Padding(padding: padding, child: child),
        ],
      ),
    );
  }
}

/// A card specifically designed for event displays
class EventCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? time;
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final VoidCallback? onActionTap;
  final String? actionText;
  final bool isActive;

  const EventCard({
    super.key,
    required this.title,
    this.subtitle,
    this.time,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
    this.onTap,
    this.onActionTap,
    this.actionText,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color cardColor = backgroundColor ??
        (isActive
            ? AppColors.primary.withAlpha((0.1 * 255).round())
            : AppColors.surface);

    final Color actualIconColor =
        iconColor ?? (isActive ? AppColors.primary : AppColors.textSecondary);

    return AppCard(
      backgroundColor: cardColor,
      borderRadius: 12.0,
      elevation: 1.0,
      padding: const EdgeInsets.all(12.0),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 48.0,
            height: 48.0,
            decoration: BoxDecoration(
              color: actualIconColor.withAlpha((0.1 * 255).round()),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Icon(icon, color: actualIconColor, size: 24.0),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4.0),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                if (time != null) ...[
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 14.0,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        time!,
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (actionText != null && onActionTap != null)
            TextButton(
              onPressed: onActionTap,
              child: Text(
                actionText!,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
