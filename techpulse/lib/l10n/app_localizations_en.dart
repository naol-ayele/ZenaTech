// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navHome => 'Home';

  @override
  String get navExplore => 'Explore';

  @override
  String get navTrending => 'Trending';

  @override
  String get navFavorite => 'Favorite';

  @override
  String get navSettings => 'Settings';

  @override
  String get screenSearch => 'Search';

  @override
  String get screenFavorites => 'Favorites';

  @override
  String get screenCategories => 'Categories';

  @override
  String get sectionTrendingNow => 'Trending Now';

  @override
  String get sectionLatestNews => 'Latest News';

  @override
  String get sectionTopCharts => 'Top Charts';

  @override
  String get sectionRecentSearches => 'Recent Searches';

  @override
  String get sectionAppearance => 'Appearance';

  @override
  String get sectionAbout => 'About';

  @override
  String get sectionAffiliateLinks => 'Affiliate Links';

  @override
  String get sectionLanguage => 'Language';

  @override
  String get labelDarkMode => 'Dark Mode';

  @override
  String get labelCurrentlyDark => 'Currently dark';

  @override
  String get labelCurrentlyLight => 'Currently light';

  @override
  String get labelVersion => 'Version';

  @override
  String get labelDeveloper => 'Developer';

  @override
  String get labelPrivacyPolicy => 'Privacy Policy';

  @override
  String get badgeLive => 'LIVE';

  @override
  String get badgeNew => 'NEW';

  @override
  String get badgeTrending => 'Trending';

  @override
  String get badgePremium => 'PREMIUM';

  @override
  String get badgePremiumContent => 'Premium Content';

  @override
  String get badgeSponsored => 'Sponsored';

  @override
  String get badgeAdShort => 'Ad';

  @override
  String get labelAdvertisement => 'Advertisement';

  @override
  String get labelDeepDive => 'Deep Dive';

  @override
  String get labelFeatured => 'Featured';

  @override
  String labelMinRead(int minutes) {
    return '$minutes min read';
  }

  @override
  String labelViews(int count) {
    return '$count views';
  }

  @override
  String labelArticles(int count) {
    return '$count articles';
  }

  @override
  String get emptyNoTrending => 'No trending articles';

  @override
  String get emptyNoFavorites => 'No favorites yet';

  @override
  String get emptyNoSearches => 'No recent searches';

  @override
  String get emptyNoResults => 'No results found';

  @override
  String get emptyNoArticles => 'No articles yet';

  @override
  String get emptySubtitleSaveArticles => 'Start saving articles you love';

  @override
  String get emptySubtitleTryDifferent => 'Try a different search term';

  @override
  String get emptySubtitleCheckBack => 'Check back later for new content';

  @override
  String get emptySubtitleCheckBackCategory => 'Check back later';

  @override
  String get emptyCategoryEmpty => 'No articles in this category';

  @override
  String get errorOffline => 'You\'re offline';

  @override
  String get errorServerUnavailable => 'Server unavailable';

  @override
  String get errorSomethingWrong => 'Something went wrong';

  @override
  String get errorNoInternetConnection => 'No Internet Connection';

  @override
  String get errorSearchFailed => 'Search failed';

  @override
  String get errorLoadingHistory => 'Error loading history';

  @override
  String get errorFailedToLoadTrending => 'Failed to load trending';

  @override
  String get errorFailedToLoadArticles => 'Failed to load articles';

  @override
  String get errorOfflineSubtitle =>
      'Please check your connection and try again';

  @override
  String get errorServerSubtitle => 'Pull down to refresh';

  @override
  String get errorNetworkSubtitle => 'Please check your network and try again';

  @override
  String get errorRetrySubtitle => 'Tap retry to load again';

  @override
  String get btnRetry => 'Retry';

  @override
  String get btnTryAgain => 'Try Again';

  @override
  String get btnClearAll => 'Clear all';

  @override
  String get btnCancel => 'Cancel';

  @override
  String get btnWatchAd => 'Watch Ad';

  @override
  String get btnWatchVideo => 'Watch Video';

  @override
  String get btnUnlockAd => 'Unlock via Ad';

  @override
  String get promptWatchAd => 'Watch a short ad to continue reading';

  @override
  String get promptUnlockPremium => 'Unlock Premium Content';

  @override
  String get promptWatchVideo =>
      'Watch a short video to unlock this article for free!';

  @override
  String get promptUnlock => 'Unlock to read the full article';

  @override
  String get promptContinueAd => 'Continue reading by watching a short ad...';

  @override
  String get contentUnlocked => 'Content unlocked!';

  @override
  String get searchHintArticles => 'Search articles...';

  @override
  String get searchHintTopics => 'Search articles, topics...';

  @override
  String get connectionRestored => 'Connection restored. Refreshing content...';

  @override
  String get timeJustNow => 'Just now';

  @override
  String timeMinutesAgo(int minutes) {
    return '${minutes}m ago';
  }

  @override
  String timeHoursAgo(int hours) {
    return '${hours}h ago';
  }

  @override
  String timeDaysAgo(int days) {
    return '${days}d ago';
  }

  @override
  String get categoryAll => 'All';

  @override
  String get categoryProgramming => 'Programming';

  @override
  String get categoryMobile => 'Mobile';

  @override
  String get categoryAiMl => 'AI & ML';

  @override
  String get categorySecurity => 'Security';

  @override
  String get categoryCloud => 'Cloud';

  @override
  String get categoryTechnology => 'Technology';

  @override
  String get categoryWebDev => 'Web Dev';

  @override
  String get categoryDevOps => 'DevOps';

  @override
  String get categoryData => 'Data';

  @override
  String get categorySports => 'Sports';

  @override
  String get categoryBusiness => 'Business';

  @override
  String get categoryEntertainment => 'Entertainment';

  @override
  String get version => '1.0.0';

  @override
  String get channelName => 'ZenaTech Notifications';

  @override
  String get channelDescription => 'Notifications from ZenaTech';

  @override
  String get semanticsRemoveFavorite => 'Remove from favorites';

  @override
  String get semanticsAddFavorite => 'Add to favorites';

  @override
  String semanticsReadArticle(String title) {
    return 'Read article: $title';
  }
}
