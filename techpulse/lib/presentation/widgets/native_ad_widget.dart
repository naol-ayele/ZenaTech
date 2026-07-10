import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/theme/app_theme.dart';
import '../../core/ads/ad_manager.dart';

class NativeAdWidget extends StatefulWidget {
  final bool isDark;

  const NativeAdWidget({super.key, this.isDark = false});

  @override
  State<NativeAdWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  NativeAd? _nativeAd;
  bool _isAdLoaded = false;
  bool _adFailed = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    final ad = adManager.loadNativeAd(
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          debugPrint('NativeAdWidget: Native ad loaded');
          if (mounted) {
            setState(() {
              _nativeAd = ad as NativeAd;
              _isAdLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint(
            'NativeAdWidget: Failed to load native ad: ${error.message}',
          );
          ad.dispose();
          if (mounted) {
            setState(() {
              _adFailed = true;
            });
          }
        },
        onAdImpression: (ad) {
          debugPrint('NativeAdWidget: Native ad impression');
        },
        onAdClicked: (ad) {
          debugPrint('NativeAdWidget: Native ad clicked');
        },
      ),
    );

    ad.load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_adFailed) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.isDark ? AppColors.dividerDark : AppColors.dividerLight,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: widget.isDark ? 0.2 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: _isAdLoaded && _nativeAd != null
          ? Column(
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
                        color: widget.isDark
                            ? AppColors.vibrantCyan.withValues(alpha: 0.2)
                            : AppColors.primaryBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Sponsored',
                        style: TextStyle(
                          color: widget.isDark
                              ? AppColors.vibrantCyan
                              : AppColors.primaryBlue,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: const Text(
                        'Ad',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AdWidget(ad: _nativeAd!),
                ),
                const SizedBox(height: 8),
                Text(
                  'Advertisement',
                  style: TextStyle(
                    color: widget.isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                    fontSize: 10,
                  ),
                ),
              ],
            )
          : _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: widget.isDark
                    ? AppColors.vibrantCyan.withValues(alpha: 0.2)
                    : AppColors.primaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Sponsored',
                style: TextStyle(
                  color: widget.isDark
                      ? AppColors.vibrantCyan
                      : AppColors.primaryBlue,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
              child: const Text(
                'Ad',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: widget.isDark ? AppColors.surfaceDark : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: widget.isDark
                  ? AppColors.vibrantCyan
                  : AppColors.primaryBlue,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Advertisement',
          style: TextStyle(
            color: widget.isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
