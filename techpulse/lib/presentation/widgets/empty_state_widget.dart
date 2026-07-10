import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Widget? action;

  const EmptyStateWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.inbox_outlined,
    this.action,
  });

  factory EmptyStateWidget.favorites(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return EmptyStateWidget(
      icon: Icons.favorite_outline,
      title: 'No favorites yet',
      subtitle: 'Start saving articles you love',
      action: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: AppColors.vibrantCyan.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.favorite_outline,
          size: 32,
          color: AppColors.vibrantCyan,
        ),
      ),
    );
  }

  factory EmptyStateWidget.search(BuildContext context) {
    return const EmptyStateWidget(
      icon: Icons.search_off,
      title: 'No results found',
      subtitle: 'Try a different search term',
    );
  }

  factory EmptyStateWidget.articles(BuildContext context) {
    return const EmptyStateWidget(
      icon: Icons.article_outlined,
      title: 'No articles yet',
      subtitle: 'Check back later for new content',
    );
  }

  factory EmptyStateWidget.category(BuildContext context) {
    return const EmptyStateWidget(
      icon: Icons.folder_outlined,
      title: 'No articles in this category',
      subtitle: 'Check back later',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (action != null) ...[
              action!,
              const SizedBox(height: 24),
            ] else ...[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.vibrantCyan.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 40, color: AppColors.vibrantCyan),
              ),
              const SizedBox(height: 24),
            ],
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
