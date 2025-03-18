import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// Theme configuration for Harmony Bridge
class AppTheme {
  // Light theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.textOnPrimary,
        primaryContainer: AppColors.primaryLight,
        onPrimaryContainer: AppColors.textOnPrimary,
        secondary: AppColors.secondary,
        onSecondary: AppColors.textOnSecondary,
        secondaryContainer: AppColors.secondaryLight,
        onSecondaryContainer: AppColors.textOnSecondary,
        tertiary: AppColors.accent,
        onTertiary: Colors.white,
        tertiaryContainer: AppColors.accentLight,
        onTertiaryContainer: Colors.white,
        error: AppColors.error,
        onError: Colors.white,
        errorContainer: AppColors.error.withAlpha(25),
        onErrorContainer: AppColors.error,
        surface: AppColors.background,
        onSurface: AppColors.textPrimary,
        surfaceContainerHighest: Colors.grey[100]!,
        onSurfaceVariant: AppColors.textSecondary,
        outline: AppColors.border,
        outlineVariant: AppColors.divider,
        shadow: Colors.black.withAlpha(25),
        scrim: Colors.black.withAlpha(77),
        inverseSurface: Colors.grey[900]!,
        onInverseSurface: Colors.white,
        inversePrimary: AppColors.primaryLight,
        surfaceTint: AppColors.primary.withAlpha(13),
      ),
      textTheme: AppTypography.textTheme,
      
      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.textTheme.titleLarge,
      ),
      
      // Card theme
      cardTheme: CardTheme(
        color: AppColors.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.all(8),
      ),
      
      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTypography.textTheme.labelLarge,
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(color: AppColors.primary, width: 1.5),
          textStyle: AppTypography.textTheme.labelLarge,
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: AppTypography.textTheme.labelLarge,
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
        hintStyle: AppTypography.textTheme.bodyMedium?.copyWith(
          color: AppColors.textHint,
        ),
        errorStyle: AppTypography.textTheme.bodySmall?.copyWith(
          color: AppColors.error,
        ),
      ),
      
      // Dialog theme
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.surface,
        elevation: 24,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      
      // Bottom sheet theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        elevation: 16,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
      ),
      
      // Snackbar theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.grey[900],
        contentTextStyle: AppTypography.textTheme.bodyMedium?.copyWith(
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      
      // Divider theme
      dividerTheme: DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 16,
      ),
      
      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        disabledColor: Colors.grey[200],
        selectedColor: AppColors.primary.withAlpha(25),
        secondarySelectedColor: AppColors.primary.withAlpha(25),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: AppTypography.textTheme.bodySmall,
        secondaryLabelStyle: AppTypography.textTheme.bodySmall,
        brightness: Brightness.light,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.border),
        ),
      ),
      
      // Tab bar theme
      tabBarTheme: TabBarTheme(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primary,
        labelStyle: AppTypography.textTheme.labelLarge,
        unselectedLabelStyle: AppTypography.textTheme.labelLarge,
      ),
    );
  }
  
  // Dark theme (can be implemented later)
  static ThemeData get darkTheme {
    // For now, just return light theme
    // Will implement dark theme in future iterations
    return lightTheme;
  }
}
