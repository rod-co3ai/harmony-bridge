import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// A customizable button widget for the Harmony Bridge app
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final AppButtonType type;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final double? width;
  final double height;
  final double borderRadius;
  final EdgeInsets padding;
  final Color? backgroundColor;
  final Color? textColor;
  final double fontSize;
  final FontWeight fontWeight;

  const AppButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.type = AppButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.width,
    this.height = 48.0,
    this.borderRadius = 12.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    this.backgroundColor,
    this.textColor,
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.w600,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine button colors based on type
    Color bgColor = backgroundColor ?? _getBackgroundColor();
    Color txtColor = textColor ?? _getTextColor();
    Color borderColor = _getBorderColor();

    // Create the button content
    Widget buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(txtColor),
              ),
            ),
          )
        else if (icon != null)
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Icon(icon, color: txtColor, size: 20),
          ),
        Text(
          text,
          style: TextStyle(
            color: txtColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );

    // Create the button based on type
    Widget button;
    switch (type) {
      case AppButtonType.primary:
      case AppButtonType.secondary:
      case AppButtonType.accent:
      case AppButtonType.success:
      case AppButtonType.warning:
      case AppButtonType.error:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            foregroundColor: txtColor,
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            elevation: type == AppButtonType.primary ? 2 : 0,
            minimumSize: Size(isFullWidth ? double.infinity : (width ?? 0), height),
            disabledBackgroundColor: bgColor.withOpacity(0.6),
            disabledForegroundColor: txtColor.withOpacity(0.6),
          ),
          child: buttonContent,
        );
        break;
      case AppButtonType.outlined:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: txtColor,
            padding: padding,
            side: BorderSide(color: borderColor, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            minimumSize: Size(isFullWidth ? double.infinity : (width ?? 0), height),
          ),
          child: buttonContent,
        );
        break;
      case AppButtonType.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: txtColor,
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            minimumSize: Size(isFullWidth ? double.infinity : (width ?? 0), height),
          ),
          child: buttonContent,
        );
        break;
    }

    return button;
  }

  Color _getBackgroundColor() {
    switch (type) {
      case AppButtonType.primary:
        return AppColors.primary;
      case AppButtonType.secondary:
        return AppColors.secondary;
      case AppButtonType.accent:
        return AppColors.accent;
      case AppButtonType.success:
        return AppColors.success;
      case AppButtonType.warning:
        return AppColors.warning;
      case AppButtonType.error:
        return AppColors.error;
      case AppButtonType.outlined:
      case AppButtonType.text:
        return Colors.transparent;
    }
  }

  Color _getTextColor() {
    switch (type) {
      case AppButtonType.primary:
      case AppButtonType.secondary:
      case AppButtonType.accent:
      case AppButtonType.success:
      case AppButtonType.warning:
      case AppButtonType.error:
        return Colors.white;
      case AppButtonType.outlined:
        return AppColors.primary;
      case AppButtonType.text:
        return AppColors.primary;
    }
  }

  Color _getBorderColor() {
    switch (type) {
      case AppButtonType.outlined:
        return AppColors.primary;
      default:
        return Colors.transparent;
    }
  }
}

/// Enum representing the type of button
enum AppButtonType {
  primary,
  secondary,
  accent,
  outlined,
  text,
  success,
  warning,
  error,
}
