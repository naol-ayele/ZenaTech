import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/article_providers.dart';
import '../../providers/category_providers.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/tech_pulse_news_card.dart';
import '../../widgets/trending_card.dart';
import '../../widgets/banner_ad_widget.dart';
import '../../widgets/category_chips_strip.dart';
import '../../widgets/native_ad_widget.dart';
import '../../widgets/sliver_error_widget.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/user_service.dart';

final selectedHomeCategoryProvider = StateProvider<String?>((ref) => null);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articlesAsync = ref.watch(articlesProvider(1));
    final trendingAsync = ref.watch(trendingArticlesProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedHomeCategoryProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(articlesProvider(1));
          await ref.read(articlesProvider(1).future);
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
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.vibrantCyan
                            : AppColors.primaryBlue,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'TechPulse',
                      style: TextStyle(
                        fontFamily: 'Merriweather',
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
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
                IconButton(
                  icon: Icon(
                    themeMode == ThemeMode.dark
                        ? Icons.light_mode
                        : Icons.dark_mode,
                    color: AppColors.vibrantCyan,
                  ),
                  onPressed: () {
                    ref.read(themeModeProvider.notifier).toggleTheme();
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
            const SliverToBoxAdapter(child: BannerAdWidget()),
            SliverToBoxAdapter(
              child: categoriesAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (categories) {
                  final allCategories = ['All', ...categories.map((c) => c.id)];
                  return Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        CategoryChipsStrip(
                          categories: allCategories,
                          onCategorySelected: (category) {
                            ref
                                    .read(selectedHomeCategoryProvider.notifier)
                                    .state =
                                category;
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Text(
                  'Trending Now',
                  style: TextStyle(
                    fontFamily: 'Merriweather',
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 160,
                child: trendingAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(
                    child: Text(
                      'Failed to load trending',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ),
                  data: (articles) => articles.isEmpty
                      ? Center(
                          child: Text(
                            'No trending articles',
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: articles.length > 5 ? 5 : articles.length,
                          itemBuilder: (context, index) {
                            final article = articles[index];
                            return TrendingCard(
                              title: article.title,
                              thumbnailUrl: article.thumbnailUrl,
                              category: article.category,
                              views: article.views,
                              onTap: () {
                                userService.trackCategoryInterest(
                                  article.category,
                                );
                                context.push('/article/${article.id}');
                              },
                            );
                          },
                        ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
                child: Text(
                  selectedCategory == null || selectedCategory == 'All'
                      ? 'Latest News'
                      : _formatCategoryName(selectedCategory),
                  style: TextStyle(
                    fontFamily: 'Merriweather',
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
              error: (error, stack) => SliverErrorWidget(
                error: error.toString(),
                onRetry: () => ref.invalidate(articlesProvider(1)),
                isDark: isDark,
              ),
              data: (allArticles) {
                final articles =
                    selectedCategory == null || selectedCategory == 'All'
                    ? allArticles
                    : allArticles
                          .where(
                            (a) =>
                                a.category.toLowerCase() ==
                                selectedCategory.toLowerCase(),
                          )
                          .toList();

                if (articles.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.article_outlined,
                            size: 64,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No articles in this category',
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.only(bottom: 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      if (index == 3 || index == 7) {
                        return NativeAdWidget(isDark: isDark);
                      }
                      if (index > 0 && index % 5 == 4) {
                        return const Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: BannerAdWidget(),
                        );
                      }
                      final articleIndex = index - (index ~/ 5);
                      if (articleIndex >= articles.length) {
                        return const SizedBox();
                      }
                      final article = articles[articleIndex];
                      final now = DateTime.now();
                      final isLive =
                          now.difference(article.publishedDate).inHours < 6;
                      return TechPulseNewsCard(
                        layoutType: NewsCardLayout.standard,
                        title: article.title,
                        category: article.category,
                        thumbnailUrl: article.thumbnailUrl,
                        publishedDate: article.publishedDate,
                        isLive: isLive,
                        onTap: () {
                          userService.trackCategoryInterest(article.category);
                          context.push('/article/${article.id}');
                        },
                      );
                    }, childCount: articles.length + (articles.length ~/ 4)),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatCategoryName(String id) {
    final names = {
      'programming': 'Programming',
      'mobile': 'Mobile',
      'ai': 'AI & ML',
      'security': 'Security',
      'cloud': 'Cloud',
      'tech': 'Technology',
    };
    return names[id] ?? id;
  }
}
