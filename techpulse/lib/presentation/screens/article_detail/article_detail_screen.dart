import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/article_providers.dart';
import '../../providers/favorites_providers.dart';
import '../../providers/ad_supported_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ads/ad_manager.dart';
import '../../../domain/entities/article.dart';

class ArticleDetailScreen extends ConsumerWidget {
  final String articleId;

  const ArticleDetailScreen({super.key, required this.articleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articleAsync = ref.watch(articleDetailProvider(articleId));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isFavoriteAsync = ref.watch(isFavoriteProvider(articleId));
    final isUnlocked = ref.watch(
      adSupportedContentProvider.select((set) => set.contains(articleId)),
    );

    return PopScope(
      canPop: true,
      child: Scaffold(
        body: articleAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    error.toString().contains('No internet connection')
                        ? Icons.wifi_off
                        : Icons.error_outline,
                    size: 60,
                    color: error.toString().contains('No internet connection')
                        ? AppColors.vibrantCyan
                        : AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    error.toString().contains('No internet connection')
                        ? "You're offline"
                        : error.toString().contains('SocketException') ||
                              error.toString().contains('DioException') ||
                              error.toString().contains('Connection') ||
                              error.toString().contains('Connection refused') ||
                              error.toString().contains(
                                'Connection timed out',
                              ) ||
                              error.toString().contains('Failed')
                        ? 'Server unavailable'
                        : 'Something went wrong',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString().contains('No internet connection')
                        ? 'Please check your connection and try again'
                        : 'Tap retry to load again',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () =>
                        ref.invalidate(articleDetailProvider(articleId)),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
          data: (article) => CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: isDark
                    ? AppColors.surfaceDark
                    : AppColors.surfaceLight,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    adManager.showInterstitialAd(
                      onAdClosed: () => Navigator.of(context).pop(),
                    );
                  },
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: article.thumbnailUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: isDark ? AppColors.cardDark : Colors.grey[200],
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: isDark ? AppColors.cardDark : Colors.grey[200],
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 64,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.7),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                title: Text(
                  article.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                actions: [
                  isFavoriteAsync.when(
                    data: (isFav) {
                      return Semantics(
                        button: true,
                        label: isFav ? 'Remove from favorites' : 'Add to favorites',
                        child: IconButton(
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : Colors.white,
                          ),
                          onPressed: () => ref
                              .read(favoritesNotifierProvider.notifier)
                              .toggleFavorite(article),
                        ),
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.vibrantCyan.withValues(
                                alpha: 0.15,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              article.category.toUpperCase(),
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.vibrantCyan
                                    : AppColors.primaryBlue,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.grey[800]
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 14,
                                      color: isDark
                                          ? AppColors.textSecondaryDark
                                          : AppColors.textSecondaryLight,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${article.readingTime} min',
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
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.grey[800]
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
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
                                      _formatViews(article.views),
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
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (_requiresAd(article) && !isUnlocked) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue.withValues(
                              alpha: 0.15,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.primaryBlue.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                article.articleType == ArticleType.deepDive
                                    ? Icons.menu_book
                                    : Icons.star,
                                color: AppColors.primaryBlue,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      article.articleType ==
                                              ArticleType.deepDive
                                          ? 'Deep Dive'
                                          : 'Featured',
                                      style: const TextStyle(
                                        color: AppColors.primaryBlue,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Watch a short ad to continue reading',
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
                              ElevatedButton(
                                onPressed: () async {
                                  await adManager.showRewardedAd(
                                    onReward: () {
                                      ref
                                          .read(
                                            adSupportedContentProvider.notifier,
                                          )
                                          .unlockArticle(article.id);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Content unlocked!'),
                                          backgroundColor: AppColors.success,
                                        ),
                                      );
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryBlue,
                                ),
                                child: const Text('Watch Ad'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: isDark ? 0.2 : 0.06,
                              ),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Html(
                          data: _getContent(article, isUnlocked),
                          style: {
                            "body": Style(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: FontSize(15.0),
                              lineHeight: LineHeight(1.6),
                            ),
                          },
                        ),
                      ),
                      if (article.affiliateLinks.isNotEmpty) ...[
                        const SizedBox(height: 32),
                        Text(
                          'Affiliate Links',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...article.affiliateLinks.map(
                          (link) => Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              onTap: () => _launchUrl(link.url),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              tileColor: isDark
                                  ? AppColors.cardDark
                                  : Colors.white,
                              leading: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppColors.vibrantCyan.withValues(
                                    alpha: 0.15,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.link,
                                  color: AppColors.vibrantCyan,
                                ),
                              ),
                              title: Text(
                                link.label,
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              trailing: const Icon(Icons.open_in_new),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _requiresAd(Article article) {
    return article.articleType == ArticleType.featured ||
        article.articleType == ArticleType.deepDive;
  }

  String _getContent(Article article, bool isUnlocked) {
    if (_requiresAd(article) && !isUnlocked) {
      final teaserLength = article.content.length > 500
          ? 500
          : (article.content.length * 0.5).round();
      return '${article.content.substring(0, teaserLength)}...<br><br>'
          '<p style="color: #666; font-style: italic;">'
          'Continue reading by watching a short ad...</p>';
    }
    return article.content;
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _formatViews(int views) {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K';
    }
    return '$views';
  }
}
