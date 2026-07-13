import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../core/utils/format_views.dart';

class TrendingCard extends StatefulWidget {
  final String title;
  final String thumbnailUrl;
  final String category;
  final int views;
  final String? articleId;
  final VoidCallback onTap;
  final bool isCompact;

  const TrendingCard({
    super.key,
    required this.title,
    required this.thumbnailUrl,
    required this.category,
    required this.views,
    this.articleId,
    required this.onTap,
    this.isCompact = false,
  });

  @override
  State<TrendingCard> createState() => _TrendingCardState();
}

class _TrendingCardState extends State<TrendingCard> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final compact = widget.isCompact;
    final cardWidth = compact ? 140.0 : 200.0;
    final cardHeight = compact ? 130.0 : 160.0;
    final maxWidth = compact ? 150.0 : 220.0;
    final minWidth = compact ? 120.0 : 180.0;
    final fontSize = compact ? 11.0 : 13.0;
    final badgeFontSize = compact ? 7.0 : 9.0;
    final badgeIconSize = compact ? 10.0 : 12.0;
    final chipIconSize = compact ? 9.0 : 10.0;
    final chipFontSize = compact ? 8.0 : 9.0;
    final topPadding = compact ? 6.0 : 8.0;
    final leftPadding = compact ? 6.0 : 8.0;
    final bottomPadding = compact ? 6.0 : 8.0;
    final titleMetaGap = compact ? 3.0 : 4.0;

    return GestureDetector(
      onTap: widget.onTap,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
          minWidth: minWidth,
          maxHeight: cardHeight,
        ),
        child: Container(
          width: cardWidth,
          height: cardHeight,
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: widget.thumbnailUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: isDark ? AppColors.cardDark : Colors.grey[200],
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: isDark ? AppColors.cardDark : Colors.grey[200],
                    child: const Icon(Icons.image_not_supported, size: 20),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.65),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: topPadding,
                  left: leftPadding,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: compact ? 4 : 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accentPeach,
                      borderRadius: BorderRadius.circular(compact ? 6 : 8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.whatshot,
                          color: Colors.white,
                          size: badgeIconSize,
                        ),
                        SizedBox(width: compact ? 1 : 2),
                        Text(
                          l10n.badgeTrending,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: badgeFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: bottomPadding,
                  left: leftPadding,
                  right: leftPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: fontSize,
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: titleMetaGap),
                      Row(
                        children: [
                          _buildMetadataChip(
                            Icons.visibility,
                            formatViews(widget.views),
                            Colors.white70,
                            chipIconSize,
                            chipFontSize,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetadataChip(
    IconData icon,
    String text,
    Color color,
    double iconSize,
    double fontSize,
  ) {
    final compact = widget.isCompact;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: compact ? 4 : 5, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(compact ? 4 : 6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: iconSize),
          const SizedBox(width: 2),
          Text(
            text,
            style: TextStyle(color: color, fontSize: fontSize),
          ),
        ],
      ),
    );
  }

}
