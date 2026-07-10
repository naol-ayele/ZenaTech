import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_config.dart';

class AdManager {
  static final AdManager _instance = AdManager._internal();
  factory AdManager() => _instance;
  AdManager._internal();
  static const String _nativeFactoryId = 'default';

  bool _isInitialized = false;
  int _interstitialShowCount = 0;
  InterstitialAd? _interstitialAd;

  Future<void> initialize() async {
    if (_isInitialized) return;

    await MobileAds.instance.initialize();

    debugPrint('AdManager: ===== INITIALIZED =====');
    debugPrint('AdManager: Banner Ad Unit: ${AdConfig.bannerAdUnitId}');
    debugPrint('AdManager: Interstitial Ad Unit: ${AdConfig.interstitialAdUnitId}');
    debugPrint('AdManager: Native Ad Unit: ${AdConfig.nativeAdUnitId}');
    debugPrint('AdManager: Rewarded Ad Unit: ${AdConfig.rewardedAdUnitId}');

    _isInitialized = true;

    await _loadInterstitialAd();
  }

  Future<void> _loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: AdConfig.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          debugPrint('AdManager: Interstitial ad loaded successfully');
        },
        onAdFailedToLoad: (error) {
          debugPrint(
            'AdManager: Failed to load interstitial: ${error.message}',
          );
          _interstitialAd = null;
        },
      ),
    );
  }

  Future<void> loadInterstitialAd() => _loadInterstitialAd();

  Future<void> showInterstitialAd({VoidCallback? onAdClosed}) async {
    _interstitialShowCount++;

    if (_interstitialShowCount % 3 != 0) {
      onAdClosed?.call();
      return;
    }

    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          _interstitialAd?.dispose();
          _interstitialAd = null;
          onAdClosed?.call();
          _loadInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          _interstitialAd?.dispose();
          _interstitialAd = null;
          onAdClosed?.call();
          _loadInterstitialAd();
        },
      );

      await _interstitialAd!.show();
    } else {
      _loadInterstitialAd();
      onAdClosed?.call();
    }
  }

  Future<RewardedAd?> loadRewardedAd() {
    debugPrint('AdManager: Loading rewarded ad...');
    final completer = Completer<RewardedAd?>();

    RewardedAd.load(
      adUnitId: AdConfig.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('AdManager: Rewarded ad loaded');
          completer.complete(ad);
        },
        onAdFailedToLoad: (error) {
          debugPrint(
            'AdManager: Failed to load rewarded ad: ${error.message}',
          );
          completer.complete(null);
        },
      ),
    );

    return completer.future;
  }

  Future<void> showRewardedAd({required void Function() onReward}) async {
    debugPrint('AdManager: showRewardedAd called');

    final rewardedAd = await loadRewardedAd();

    if (rewardedAd == null) {
      debugPrint('AdManager: No rewarded ad available, calling onReward anyway');
      onReward();
      return;
    }

    rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('AdManager: Rewarded ad dismissed');
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint(
          'AdManager: Failed to show rewarded ad: ${error.message}',
        );
        ad.dispose();
        onReward();
      },
    );

    await rewardedAd.show(
      onUserEarnedReward: (ad, reward) {
        debugPrint(
          'AdManager: User earned reward: ${reward.amount} ${reward.type}',
        );
        onReward();
      },
    );
  }

  NativeAd loadNativeAd({
    required NativeAdListener listener,
  }) {
    debugPrint('AdManager: Creating native ad request...');

    return NativeAd(
      adUnitId: AdConfig.nativeAdUnitId,
      listener: listener,
      request: const AdRequest(),
      nativeAdOptions: NativeAdOptions(
        mediaAspectRatio: MediaAspectRatio.landscape,
        adChoicesPlacement: AdChoicesPlacement.topRightCorner,
      ),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
      ),
    );
  }

  String get bannerAdUnitId => AdConfig.bannerAdUnitId;
  String get nativeAdUnitId => AdConfig.nativeAdUnitId;
  String get nativeFactoryId => _nativeFactoryId;

  int get interstitialShowCount => _interstitialShowCount;

  void resetInterstitialCount() {
    _interstitialShowCount = 0;
    debugPrint('AdManager: interstitial counter reset to 0');
  }
}

final adManager = AdManager();
