import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// A customizable avatar widget for the Harmony Bridge app
class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double size;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final VoidCallback? onTap;
  final bool isOnline;
  final Widget? badge;
  final BoxFit fit;

  const AppAvatar({
    Key? key,
    this.imageUrl,
    this.name,
    this.size = 48.0,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 0.0,
    this.onTap,
    this.isOnline = false,
    this.badge,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine the background color based on the name
    Color avatarColor = backgroundColor ?? _getColorFromName(name);
    
    // Create the avatar content
    Widget avatarContent;
    
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      // Image avatar
      avatarContent = ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: Image.network(
          imageUrl!,
          width: size,
          height: size,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            // Fallback to initials if image fails to load
            return _buildInitialsAvatar(avatarColor);
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: size,
              height: size,
              color: avatarColor,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                  strokeWidth: 2.0,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      );
    } else {
      // Initials avatar
      avatarContent = _buildInitialsAvatar(avatarColor);
    }
    
    // Create the avatar with border if needed
    Widget avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: borderWidth > 0
            ? Border.all(
                color: borderColor ?? AppColors.primary,
                width: borderWidth,
              )
            : null,
      ),
      child: avatarContent,
    );
    
    // Add online indicator if needed
    if (isOnline || badge != null) {
      avatar = Stack(
        children: [
          avatar,
          if (isOnline)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: size / 4,
                height: size / 4,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
              ),
            ),
          if (badge != null)
            Positioned(
              right: 0,
              bottom: 0,
              child: badge!,
            ),
        ],
      );
    }
    
    // Make it tappable if needed
    if (onTap != null) {
      avatar = GestureDetector(
        onTap: onTap,
        child: avatar,
      );
    }
    
    return avatar;
  }
  
  Widget _buildInitialsAvatar(Color backgroundColor) {
    String initials = _getInitials(name);
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: size / 2.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  
  String _getInitials(String? name) {
    if (name == null || name.isEmpty) {
      return '?';
    }
    
    final List<String> nameParts = name.trim().split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else {
      return name.substring(0, 1).toUpperCase();
    }
  }
  
  Color _getColorFromName(String? name) {
    if (name == null || name.isEmpty) {
      return AppColors.primary;
    }
    
    // Generate a color based on the name
    final int hashCode = name.hashCode;
    final List<Color> colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.accent,
      Colors.teal,
      Colors.purple,
      Colors.indigo,
      Colors.pink,
      Colors.orange,
      Colors.cyan,
      Colors.brown,
    ];
    
    return colors[hashCode.abs() % colors.length];
  }
}

/// A group avatar that displays multiple avatars in an overlapping layout
class AppGroupAvatar extends StatelessWidget {
  final List<String> imageUrls;
  final List<String>? names;
  final double size;
  final double overlap;
  final double borderWidth;
  final Color borderColor;
  final int maxDisplayed;
  final VoidCallback? onTap;

  const AppGroupAvatar({
    Key? key,
    required this.imageUrls,
    this.names,
    this.size = 48.0,
    this.overlap = 0.3,
    this.borderWidth = 2.0,
    this.borderColor = Colors.white,
    this.maxDisplayed = 3,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int totalCount = imageUrls.length;
    final int displayCount = totalCount > maxDisplayed ? maxDisplayed : totalCount;
    final double stackWidth = size + (size * (1 - overlap) * (displayCount - 1));
    
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: stackWidth,
        height: size,
        child: Stack(
          children: [
            for (int i = 0; i < displayCount; i++)
              Positioned(
                left: i * size * (1 - overlap),
                child: AppAvatar(
                  imageUrl: imageUrls[i],
                  name: names != null && i < names!.length ? names![i] : null,
                  size: size,
                  borderColor: borderColor,
                  borderWidth: borderWidth,
                ),
              ),
            if (totalCount > maxDisplayed)
              Positioned(
                left: displayCount * size * (1 - overlap),
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: borderColor,
                      width: borderWidth,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '+${totalCount - maxDisplayed}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size / 3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
