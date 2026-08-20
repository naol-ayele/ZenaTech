import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import '../../providers/article_providers.dart';
import '../../providers/favorites_providers.dart';
import '../../widgets/banner_ad_widget.dart';
import '../../widgets/native_ad_widget.dart';
import '../../widgets/sliver_error_widget.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/user_service.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/utils/time_ago.dart';
import '../../../domain/entities/article.dart';
import 'package:techpulse/l10n/app_localizations.dart';

class TrendingScreen extends ConsumerWidget {
  const TrendingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendingAsync = ref.watch(trendingArticlesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(trendingArticlesProvider);
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
              floating: true,
              pinned: true,
              backgroundColor: isDark
                  ? AppColors.surfaceDark
                  : AppColors.surfaceLight,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                title: Row(
                  children: [
                    const Icon(
                      Icons.whatshot,
                      color: AppColors.accentPeach,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.navTrending,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                  onPressed: () => context.push('/search'),
                ),
                const SizedBox(width: 8),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Text(
                  AppLocalizations.of(context)!.sectionTopCharts,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
            trendingAsync.when(
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stack) => SliverErrorWidget(
                error: error.toString(),
                onRetry: () => ref.invalidate(trendingArticlesProvider),
                isDark: isDark,
              ),
              data: (articles) => articles.isEmpty
                  ? SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.whatshot_outlined, size: 64),
                            const SizedBox(height: 16),
                            Text(AppLocalizations.of(context)!.emptyNoTrending),
                          ],
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        // Ad slot every 4th item (indices 3, 7, 11...)
                        if (index > 0 && index % 4 == 3) {
                          if (index == 3 || index == 7) {
                            return NativeAdWidget(isDark: isDark);
                          }
                          return const Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: BannerAdWidget(),
                          );
                        }

                        // Calculate actual article index (accounting for ad slots)
                        final articleIndex = index - (index ~/ 4);

                        // Safety check for bounds
                        if (articleIndex >= articles.length) {
                          return const SizedBox.shrink();
                        }

                        final article = articles[articleIndex];
                        return _buildHeroCard(
                          context,
                          ref,
                          article,
                          index + 1,
                          isDark,
                          isCompact: true,
                        );
                      }, childCount: articles.length + (articles.length ~/ 4)),
                    ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard(
    BuildContext context,
    WidgetRef ref,
    Article article,
    int rank,
    bool isDark, {
    bool isCompact = false,
  }) {
    final minRead = _calculateReadTime(article.content);
    final timeAgoStr = timeAgo(article.publishedDate, context);
    final isFavorite = ref.watch(
      isFavoriteProvider(article.id).select(
        (asyncValue) => asyncValue.maybeWhen(
          data: (fav) => fav,
          orElse: () => false,
        ),
      ),
    );

    return GestureDetector(
      onTap: () async {
        userService.trackCategoryInterest(article.category);

        // Track view
        try {
          final dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
          await dio.patch('/articles/${article.id}/view');
        } catch (e) {
          debugPrint('View tracking error: $e');
        }

        context.push('/article/${article.id}');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        height: isCompact ? 130 : 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(isCompact ? 16 : 24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.15),
              blurRadius: isCompact ? 10 : 16,
              offset: Offset(0, isCompact ? 5 : 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isCompact ? 16 : 24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: article.thumbnailUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: isDark ? AppColors.cardDark : Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: isDark ? AppColors.cardDark : Colors.grey[200],
                  child: const Icon(Icons.image_not_supported, size: 48),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.3),
                      Colors.black.withValues(alpha: 0.85),
                    ],
                    stops: const [0.0, 0.4, 1.0],
                  ),
                ),
              ),
              Positioned(
                top: isCompact ? 10 : 16,
                right: isCompact ? 10 : 16,
                child: Container(
                  width: isCompact ? 30 : 40,
                  height: isCompact ? 30 : 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      isFavorite ? Icons.bookmark : Icons.bookmark_border,
                      color: isFavorite ? AppColors.vibrantCyan : Colors.white,
                      size: isCompact ? 16 : 22,
                    ),
                    onPressed: () {
                      ref
                          .read(favoritesNotifierProvider.notifier)
                          .toggleFavorite(article);
                    },
                  ),
                ),
              ),
              Positioned(
                top: isCompact ? 10 : 16,
                left: isCompact ? 10 : 16,
                child: Container(
                  width: isCompact ? 28 : 36,
                  height: isCompact ? 28 : 36,
                  decoration: BoxDecoration(
                    color: _getRankColor(rank),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '#$rank',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isCompact ? 9 : 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: isCompact ? 10 : 16,
                right: isCompact ? 10 : 16,
                bottom: isCompact ? 40 : 60,
                child: Text(
                  article.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isCompact ? 14 : 18,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Positioned(
                left: isCompact ? 10 : 16,
                right: isCompact ? 10 : 16,
                bottom: isCompact ? 10 : 16,
                child: Row(
                  children: [
                    _buildMetadataChip(
                      Icons.schedule,
                      AppLocalizations.of(context)!.labelMinRead(minRead),
                      isCompact: isCompact,
                    ),
                    const Spacer(),
                    Text(
                      timeAgoStr,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: isCompact ? 10 : 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetadataChip(
    IconData icon,
    String text, {
    bool isCompact = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 6 : 8,
        vertical: isCompact ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(isCompact ? 8 : 12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: isCompact ? 10 : 12),
          SizedBox(width: isCompact ? 3 : 4),
          Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: isCompact ? 9 : 11),
          ),
        ],
      ),
    );
  }

  int _calculateReadTime(String content) {
    if (content.isEmpty) return 1;
    final wordCount = content.split(RegExp(r'\s+')).length;
    final minutes = (wordCount / 200).ceil();
    return minutes < 1 ? 1 : minutes;
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700);
      case 2:
        return const Color(0xFFC0C0C0);
      case 3:
        return const Color(0xFFCD7F32);
      default:
        return AppColors.textSecondaryDark;
    }
  }
}
