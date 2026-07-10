import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class GlassCategoryTile extends StatelessWidget {
  final String name;
  final String icon;
  final int articleCount;
  final VoidCallback onTap;

  const GlassCategoryTile({
    super.key,
    required this.name,
    required this.icon,
    required this.articleCount,
    required this.onTap,
  });

  IconData _getIcon() {
    switch (icon.toLowerCase()) {
      case 'code':
        return Icons.code;
      case 'phone_android':
        return Icons.phone_android;
      case 'psychology':
        return Icons.psychology;
      case 'security':
        return Icons.security;
      case 'cloud':
        return Icons.cloud;
      default:
        return Icons.category;
    }
  }

  Color _getColor() {
    switch (icon.toLowerCase()) {
      case 'code':
        return const Color(0xFF6366F1);
      case 'phone_android':
        return const Color(0xFF10B981);
      case 'psychology':
        return const Color(0xFF8B5CF6);
      case 'security':
        return const Color(0xFFEF4444);
      case 'cloud':
        return const Color(0xFF0EA5E9);
      default:
        return AppColors.vibrantCyan;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = _getColor();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [color.withValues(alpha: 0.3), color.withValues(alpha: 0.15)]
                : [Colors.white, color.withValues(alpha: 0.05)],
          ),
          border: Border.all(
            color: isDark
                ? color.withValues(alpha: 0.3)
                : color.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: isDark ? 0.2 : 0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(_getIcon(), color: color, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: TextStyle(
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$articleCount articles',
              style: TextStyle(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HighContrastCategoryTile extends StatelessWidget {
  final String name;
  final String icon;
  final int articleCount;
  final VoidCallback onTap;

  const HighContrastCategoryTile({
    super.key,
    required this.name,
    required this.icon,
    required this.articleCount,
    required this.onTap,
  });

  IconData _getIcon() {
    switch (icon.toLowerCase()) {
      case 'code':
        return Icons.code;
      case 'phone_android':
        return Icons.phone_android;
      case 'psychology':
        return Icons.psychology;
      case 'security':
        return Icons.security;
      case 'cloud':
        return Icons.cloud;
      default:
        return Icons.category;
    }
  }

  Color _getColor() {
    switch (icon.toLowerCase()) {
      case 'code':
        return const Color(0xFF6366F1);
      case 'phone_android':
        return const Color(0xFF10B981);
      case 'psychology':
        return const Color(0xFF8B5CF6);
      case 'security':
        return const Color(0xFFEF4444);
      case 'cloud':
        return const Color(0xFF0EA5E9);
      default:
        return AppColors.vibrantCyan;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = _getColor();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? color.withValues(alpha: 0.2) : color,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_getIcon(), color: Colors.white, size: 36),
            const SizedBox(height: 12),
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$articleCount articles',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
