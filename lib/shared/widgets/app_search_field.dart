import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// A custom search field widget with consistent styling for the app
class AppSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String) onChanged;
  final VoidCallback? onClear;
  final bool autofocus;

  const AppSearchField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.onClear,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withAlpha(13), // 0.05 opacity = 13 alpha (0.05 * 255)
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        autofocus: autofocus,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: const Icon(Icons.search, color: AppColors.primary),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.primary),
                  onPressed: () {
                    controller.clear();
                    if (onClear != null) {
                      onClear!();
                    } else {
                      onChanged('');
                    }
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
