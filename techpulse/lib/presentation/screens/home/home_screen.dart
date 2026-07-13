import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/article.dart';
import '../../providers/category_providers.dart';
import '../../providers/theme_provider.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/tech_pulse_news_card.dart';
import '../../widgets/trending_card.dart';
import '../../widgets/banner_ad_widget.dart';
import '../../widgets/category_chips_strip.dart';
import '../../widgets/native_ad_widget.dart';
import '../../widgets/sliver_error_widget.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/user_service.dart';
import 'package:techpulse/l10n/app_localizations.dart';

final selectedHomeCategoryProvider = StateProvider<String?>((ref) => null);

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  List<Article>? _displayedArticles;
  List<Article>? _latestArticles;
  List<Article>? _trendingArticles;
  int _newArticleCount = 0;
  DateTime? _lastFetchTime;
  bool _isInitialLoading = true;
  String? _initialError;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadInitialData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _onResume();
    }
  }

  Future<void> _loadInitialData() async {
    _isInitialLoading = true;
    setState(() {});
    try {
      final repo = ref.read(articleRepositoryProvider);
      final articles = await repo.getArticles(page: 1);
      _displayedArticles = articles;
      _latestArticles = articles;
      _lastFetchTime = DateTime.now();
    } catch (e) {
      _initialError = e.toString();
    }
    try {
      final repo = ref.read(articleRepositoryProvider);
      _trendingArticles = await repo.getTrendingArticles();
    } catch (_) {}
    _isInitialLoading = false;
    if (mounted) setState(() {});
  }

  void _onResume() {
    if (_lastFetchTime == null) return;
    if (DateTime.now().difference(_lastFetchTime!) <=
        const Duration(minutes: 2)) {
      return;
    }
    _backgroundRefresh();
  }

  Future<void> _backgroundRefresh() async {
    try {
      final repo = ref.read(articleRepositoryProvider);
      final freshArticles = await repo.getArticles(page: 1);
      final freshTrending = await repo.getTrendingArticles();
      _latestArticles = freshArticles;
      _trendingArticles = freshTrending;
      _lastFetchTime = DateTime.now();
      if (_displayedArticles != null && freshArticles.isNotEmpty) {
        final displayedIds = _displayedArticles!.map((a) => a.id).toSet();
        int count = 0;
        for (final article in freshArticles) {
          if (displayedIds.contains(article.id)) break;
          count++;
        }
        _newArticleCount = count;
      }
      if (mounted) setState(() {});
    } catch (_) {}
  }

  Future<void> _onPullToRefresh() async {
    try {
      final repo = ref.read(articleRepositoryProvider);
      final freshArticles = await repo.getArticles(page: 1);
      final freshTrending = await repo.getTrendingArticles();
      _displayedArticles = freshArticles;
      _latestArticles = freshArticles;
      _trendingArticles = freshTrending;
      _newArticleCount = 0;
      _lastFetchTime = DateTime.now();
    } catch (_) {}
    if (mounted) setState(() {});
  }

  void _onPillTap() {
    if (_latestArticles == null) return;
    _displayedArticles = _latestArticles;
    _newArticleCount = 0;
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedHomeCategoryProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onPullToRefresh,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: _buildSlivers(
            context,
            isDark,
            themeMode,
            selectedCategory,
            categoriesAsync,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSlivers(
    BuildContext context,
    bool isDark,
    ThemeMode themeMode,
    String? selectedCategory,
    AsyncValue<List<Category>> categoriesAsync,
  ) {
    if (_isInitialLoading) {
      return [
        const SliverFillRemaining(
          child: Center(child: CircularProgressIndicator()),
        ),
      ];
    }

    if (_initialError != null && _displayedArticles == null) {
      return [
        SliverErrorWidget(
          error: _initialError!,
          onRetry: _loadInitialData,
          isDark: isDark,
        ),
      ];
    }

    final articles = _buildFilteredArticles(selectedCategory);
    final l10n = AppLocalizations.of(context)!;

    return [
      _buildAppBar(context, isDark, themeMode),
      const SliverToBoxAdapter(child: BannerAdWidget()),
      _buildCategoryChips(context, categoriesAsync),
      _buildTrendingHeader(l10n, isDark),
      _buildTrendingStrip(l10n, isDark),
      if (_newArticleCount > 0) _buildPill(_newArticleCount, l10n, isDark),
      _buildLatestNewsHeader(l10n, selectedCategory),
      _buildArticleList(articles, isDark),
    ];
  }

  List<Article> _buildFilteredArticles(String? selectedCategory) {
    if (_displayedArticles == null) return [];
    if (selectedCategory == null || selectedCategory == 'All') {
      return _displayedArticles!;
    }
    return _displayedArticles!
        .where(
          (a) => a.category.toLowerCase() == selectedCategory.toLowerCase(),
        )
        .toList();
  }

  Widget _buildAppBar(
    BuildContext context,
    bool isDark,
    ThemeMode themeMode,
  ) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      backgroundColor:
          isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        title: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color:
                    isDark ? AppColors.vibrantCyan : AppColors.primaryBlue,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'ZenaTech',
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
    );
  }

  Widget _buildCategoryChips(
    BuildContext context,
    AsyncValue<List<Category>> categoriesAsync,
  ) {
    return SliverToBoxAdapter(
      child: categoriesAsync.when(
        loading: () => const SizedBox.shrink(),
        error: (_, _) => const SizedBox.shrink(),
        data: (categories) {
          final allCategories = [
            AppLocalizations.of(context)!.categoryAll,
            ...categories.map((c) => c.id),
          ];
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
                        .state = category;
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTrendingHeader(AppLocalizations l10n, bool isDark) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: Text(
          l10n.sectionTrendingNow,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }

  Widget _buildTrendingStrip(AppLocalizations l10n, bool isDark) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 160,
        child: _trendingArticles == null
            ? Center(
                child: Text(
                  l10n.errorFailedToLoadTrending,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              )
            : _trendingArticles!.isEmpty
                ? Center(
                    child: Text(
                      l10n.emptyNoTrending,
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _trendingArticles!.length > 5
                        ? 5
                        : _trendingArticles!.length,
                    itemBuilder: (context, index) {
                      final article = _trendingArticles![index];
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
    );
  }

  Widget _buildPill(int count, AppLocalizations l10n, bool isDark) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Material(
          color:
              isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(24),
          elevation: 2,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: _onPillTap,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isDark
                      ? AppColors.vibrantCyan.withValues(alpha: 0.3)
                      : AppColors.primaryBlue.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.new_releases,
                    size: 16,
                    color: isDark
                        ? AppColors.vibrantCyan
                        : AppColors.primaryBlue,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.pillNewArticles(count),
                    style: TextStyle(
                      color: isDark
                          ? AppColors.vibrantCyan
                          : AppColors.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLatestNewsHeader(
    AppLocalizations l10n,
    String? selectedCategory,
  ) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
        child: Text(
          selectedCategory == null || selectedCategory == 'All'
              ? l10n.sectionLatestNews
              : _formatCategoryName(context, selectedCategory),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }

  Widget _buildArticleList(List<Article> articles, bool isDark) {
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
                AppLocalizations.of(context)!.emptyCategoryEmpty,
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
  }

  String _formatCategoryName(BuildContext context, String id) {
    final l10n = AppLocalizations.of(context)!;
    final names = {
      'programming': l10n.categoryProgramming,
      'mobile': l10n.categoryMobile,
      'ai': l10n.categoryAiMl,
      'security': l10n.categorySecurity,
      'cloud': l10n.categoryCloud,
      'tech': l10n.categoryTechnology,
    };
    return names[id] ?? id;
  }
}
