import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/api_constants.dart';
import '../../l10n/app_localizations.dart';
import '../../core/utils/time_ago.dart';

enum NewsCardLayout { hero, standard, compact }

class LiveBadge extends StatefulWidget {
  final bool isLive;

  const LiveBadge({super.key, required this.isLive});

  @override
  State<LiveBadge> createState() => _LiveBadgeState();
}

class _LiveBadgeState extends State<LiveBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    if (widget.isLive) _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: widget.isLive ? AppColors.accentPeach : AppColors.vibrantCyan,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.isLive) ...[
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) => Opacity(
                opacity: _animation.value,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
          ],
          Text(
            widget.isLive ? l10n.badgeLive : l10n.badgeNew,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class TechPulseNewsCard extends StatefulWidget {
  final NewsCardLayout layoutType;
  final String title;
  final String thumbnailUrl;
  final String category;
  final DateTime publishedDate;
  final int views;
  final bool? isLive;
  final String? articleId;
  final VoidCallback onTap;

  const TechPulseNewsCard({
    super.key,
    required this.layoutType,
    required this.title,
    required this.thumbnailUrl,
    required this.category,
    required this.publishedDate,
    this.views = 0,
    this.isLive,
    this.articleId,
    required this.onTap,
  });

  @override
  State<TechPulseNewsCard> createState() => _TechPulseNewsCardState();
}

class _TechPulseNewsCardState extends State<TechPulseNewsCard> {
  Future<void> _trackView() async {
    if (widget.articleId == null) return;
    try {
      await Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      ).patch('/articles/${widget.articleId}/view');
    } catch (e) {
      debugPrint('View tracking error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (widget.layoutType) {
      case NewsCardLayout.hero:
        return _buildHeroCard(context, isDark);
      case NewsCardLayout.standard:
        return _buildStandardCard(context, isDark);
      case NewsCardLayout.compact:
        return _buildCompactCard(context, isDark);
    }
  }

  Widget _chip(IconData icon, String text, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color ?? Colors.white70, size: 12),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(color: color ?? Colors.white70, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    return Semantics(
      button: true,
      label: l10n.semanticsReadArticle(widget.title),
      child: GestureDetector(
        onTap: () {
          _trackView();
          widget.onTap();
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          height: 280,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: widget.thumbnailUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    color: isDark ? AppColors.cardDark : Colors.grey[200],
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: isDark ? AppColors.cardDark : Colors.grey[200],
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          widget.category.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      if (widget.isLive == true) ...[
                        const SizedBox(width: 8),
                        LiveBadge(isLive: true),
                      ],
                    ],
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 20,
                  right: 20,
                  child: Row(children: [_chip(Icons.schedule, timeAgo(widget.publishedDate, context))]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStandardCard(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () {
        _trackView();
        widget.onTap();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.vibrantCyan.withValues(
                              alpha: 0.15,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            widget.category.toUpperCase(),
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.vibrantCyan
                                  : AppColors.primaryBlue,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (widget.isLive == true) ...[
                          const SizedBox(width: 8),
                          LiveBadge(isLive: true),
                        ],
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      timeAgo(widget.publishedDate, context),
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
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: SizedBox(
                width: 120,
                height: 120,
                child: CachedNetworkImage(
                  imageUrl: widget.thumbnailUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactCard(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () {
        _trackView();
        widget.onTap();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: SizedBox(
                width: 100,
                height: 100,
                child: CachedNetworkImage(
                  imageUrl: widget.thumbnailUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.vibrantCyan.withValues(
                              alpha: 0.15,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            widget.category.toUpperCase(),
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.vibrantCyan
                                  : AppColors.primaryBlue,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (widget.isLive == true) ...[
                          const SizedBox(width: 8),
                          LiveBadge(isLive: true),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      timeAgo(widget.publishedDate, context),
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
          ],
        ),
      ),
    );
  }
}
