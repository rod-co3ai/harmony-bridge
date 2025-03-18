import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Bottom navigation bar widget for the Harmony Bridge app
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool showLabels;
  final double height;
  final double iconSize;
  final double selectedFontSize;
  final double unselectedFontSize;

  const AppBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    this.showLabels = true,
    this.height = 60.0,
    this.iconSize = 24.0,
    this.selectedFontSize = 12.0,
    this.unselectedFontSize = 10.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        showSelectedLabels: showLabels,
        showUnselectedLabels: showLabels,
        selectedFontSize: selectedFontSize,
        unselectedFontSize: unselectedFontSize,
        iconSize: iconSize,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            activeIcon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

/// A more modern bottom navigation bar with a floating action button
class AppBottomNavWithFab extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback onFabPressed;
  final Widget fabIcon;
  final String fabTooltip;
  final double height;
  final double iconSize;
  final double fabSize;

  const AppBottomNavWithFab({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.onFabPressed,
    this.fabIcon = const Icon(Icons.add, color: Colors.white),
    this.fabTooltip = 'Add',
    this.height = 60.0,
    this.iconSize = 24.0,
    this.fabSize = 56.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_outlined, Icons.home, 'Home'),
              _buildNavItem(1, Icons.calendar_today_outlined, Icons.calendar_today, 'Calendar'),
              // Empty space for FAB
              SizedBox(width: fabSize + 16),
              _buildNavItem(2, Icons.message_outlined, Icons.message, 'Messages'),
              _buildNavItem(3, Icons.person_outline, Icons.person, 'Profile'),
            ],
          ),
        ),
        Positioned(
          top: -(fabSize / 3),
          child: SizedBox(
            width: fabSize,
            height: fabSize,
            child: FloatingActionButton(
              onPressed: onFabPressed,
              tooltip: fabTooltip,
              backgroundColor: AppColors.primary,
              elevation: 4,
              child: fabIcon,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label) {
    final bool isSelected = currentIndex == index;
    
    return InkWell(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSelected ? activeIcon : icon,
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
            size: iconSize,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
