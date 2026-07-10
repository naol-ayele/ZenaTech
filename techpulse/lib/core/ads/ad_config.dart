class AdConfig {
  AdConfig._();

  static const bool _isProduction = bool.fromEnvironment('PRODUCTION');

  static bool get isProduction => _isProduction;

  static const String _devBannerAdUnit = 'ca-app-pub-3940256099942544/6300978111';
  static const String _devNativeAdUnit = 'ca-app-pub-3940256099942544/2247696110';
  static const String _devInterstitialAdUnit =
      'ca-app-pub-3940256099942544/1033173712';
  static const String _devRewardedAdUnit =
      'ca-app-pub-3940256099942544/5224354917';
  static const String _devAppId = 'ca-app-pub-3940256099942544~3347511713';

  static const String _prodBannerAdUnit = '';
  static const String _prodNativeAdUnit = '';
  static const String _prodInterstitialAdUnit = '';
  static const String _prodRewardedAdUnit = '';
  static const String _prodAppId = '';

  static String get bannerAdUnitId =>
      _isProduction ? _prodBannerAdUnit : _devBannerAdUnit;

  static String get nativeAdUnitId =>
      _isProduction ? _prodNativeAdUnit : _devNativeAdUnit;

  static String get interstitialAdUnitId =>
      _isProduction ? _prodInterstitialAdUnit : _devInterstitialAdUnit;

  static String get rewardedAdUnitId =>
      _isProduction ? _prodRewardedAdUnit : _devRewardedAdUnit;

  static String get appId => _isProduction ? _prodAppId : _devAppId;
}
