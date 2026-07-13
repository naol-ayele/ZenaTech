import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../providers/article_providers.dart';
import '../../../core/theme/app_theme.dart';
import 'package:techpulse/l10n/app_localizations.dart';

class CategoryDetailScreen extends ConsumerWidget {
  final String categoryId;

  const CategoryDetailScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articlesAsync = ref.watch(categoryArticlesProvider(categoryId));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final categoryName = _getCategoryName(context, categoryId);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: isDark
                ? AppColors.surfaceDark
                : AppColors.surfaceLight,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Text(
                categoryName,
                style: TextStyle(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          articlesAsync.when(
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: AppColors.error),
                    const SizedBox(height: 16),
                    Text(AppLocalizations.of(context)!.errorFailedToLoadArticles),
                    ElevatedButton(
                      onPressed: () =>
                          ref.invalidate(categoryArticlesProvider(categoryId)),
                      child: Text(AppLocalizations.of(context)!.btnRetry),
                    ),
                  ],
                ),
              ),
            ),
            data: (articles) => articles.isEmpty
                ? SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.article_outlined, size: 64),
                          const SizedBox(height: 16),
                          Text(AppLocalizations.of(context)!.emptyCategoryEmpty),
                        ],
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final article = articles[index];
                      return _buildArticleTile(context, article, isDark);
                    }, childCount: articles.length),
                  ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  String _getCategoryName(BuildContext context, String id) {
    final l10n = AppLocalizations.of(context)!;
    switch (id) {
      case 'programming': return l10n.categoryProgramming;
      case 'mobile': return l10n.categoryMobile;
      case 'ai': return l10n.categoryAiMl;
      case 'security': return l10n.categorySecurity;
      case 'cloud': return l10n.categoryCloud;
      default: return id;
    }
  }

  Widget _buildArticleTile(BuildContext context, dynamic article, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: () => context.push('/article/${article.id}'),
        contentPadding: const EdgeInsets.all(16),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 80,
            height: 80,
            child: CachedNetworkImage(
              imageUrl: article.thumbnailUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          article.title,
          style: TextStyle(
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              Icon(
                Icons.visibility_outlined,
                size: 14,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
              const SizedBox(width: 4),
              Text(
                '${article.views}',
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
      ),
    );
  }
}
