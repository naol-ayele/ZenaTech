import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_am.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('am'),
    Locale('en'),
  ];

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get navExplore;

  /// No description provided for @navTrending.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get navTrending;

  /// No description provided for @navFavorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get navFavorite;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @screenSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get screenSearch;

  /// No description provided for @screenFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get screenFavorites;

  /// No description provided for @screenCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get screenCategories;

  /// No description provided for @sectionTrendingNow.
  ///
  /// In en, this message translates to:
  /// **'Trending Now'**
  String get sectionTrendingNow;

  /// No description provided for @sectionLatestNews.
  ///
  /// In en, this message translates to:
  /// **'Latest News'**
  String get sectionLatestNews;

  /// No description provided for @sectionTopCharts.
  ///
  /// In en, this message translates to:
  /// **'Top Charts'**
  String get sectionTopCharts;

  /// No description provided for @sectionRecentSearches.
  ///
  /// In en, this message translates to:
  /// **'Recent Searches'**
  String get sectionRecentSearches;

  /// No description provided for @sectionAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get sectionAppearance;

  /// No description provided for @sectionAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get sectionAbout;

  /// No description provided for @sectionAffiliateLinks.
  ///
  /// In en, this message translates to:
  /// **'Affiliate Links'**
  String get sectionAffiliateLinks;

  /// No description provided for @sectionLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get sectionLanguage;

  /// No description provided for @labelDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get labelDarkMode;

  /// No description provided for @labelCurrentlyDark.
  ///
  /// In en, this message translates to:
  /// **'Currently dark'**
  String get labelCurrentlyDark;

  /// No description provided for @labelCurrentlyLight.
  ///
  /// In en, this message translates to:
  /// **'Currently light'**
  String get labelCurrentlyLight;

  /// No description provided for @labelVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get labelVersion;

  /// No description provided for @labelDeveloper.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get labelDeveloper;

  /// No description provided for @labelPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get labelPrivacyPolicy;

  /// No description provided for @badgeLive.
  ///
  /// In en, this message translates to:
  /// **'LIVE'**
  String get badgeLive;

  /// No description provided for @badgeNew.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get badgeNew;

  /// No description provided for @badgeTrending.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get badgeTrending;

  /// No description provided for @badgePremium.
  ///
  /// In en, this message translates to:
  /// **'PREMIUM'**
  String get badgePremium;

  /// No description provided for @badgePremiumContent.
  ///
  /// In en, this message translates to:
  /// **'Premium Content'**
  String get badgePremiumContent;

  /// No description provided for @badgeSponsored.
  ///
  /// In en, this message translates to:
  /// **'Sponsored'**
  String get badgeSponsored;

  /// No description provided for @badgeAdShort.
  ///
  /// In en, this message translates to:
  /// **'Ad'**
  String get badgeAdShort;

  /// No description provided for @labelAdvertisement.
  ///
  /// In en, this message translates to:
  /// **'Advertisement'**
  String get labelAdvertisement;

  /// No description provided for @labelDeepDive.
  ///
  /// In en, this message translates to:
  /// **'Deep Dive'**
  String get labelDeepDive;

  /// No description provided for @labelFeatured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get labelFeatured;

  /// No description provided for @labelMinRead.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min read'**
  String labelMinRead(int minutes);

  /// No description provided for @labelViews.
  ///
  /// In en, this message translates to:
  /// **'{count} views'**
  String labelViews(int count);

  /// No description provided for @labelArticles.
  ///
  /// In en, this message translates to:
  /// **'{count} articles'**
  String labelArticles(int count);

  /// No description provided for @emptyNoTrending.
  ///
  /// In en, this message translates to:
  /// **'No trending articles'**
  String get emptyNoTrending;

  /// No description provided for @emptyNoFavorites.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get emptyNoFavorites;

  /// No description provided for @emptyNoSearches.
  ///
  /// In en, this message translates to:
  /// **'No recent searches'**
  String get emptyNoSearches;

  /// No description provided for @emptyNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get emptyNoResults;

  /// No description provided for @emptyNoArticles.
  ///
  /// In en, this message translates to:
  /// **'No articles yet'**
  String get emptyNoArticles;

  /// No description provided for @emptySubtitleSaveArticles.
  ///
  /// In en, this message translates to:
  /// **'Start saving articles you love'**
  String get emptySubtitleSaveArticles;

  /// No description provided for @emptySubtitleTryDifferent.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get emptySubtitleTryDifferent;

  /// No description provided for @emptySubtitleCheckBack.
  ///
  /// In en, this message translates to:
  /// **'Check back later for new content'**
  String get emptySubtitleCheckBack;

  /// No description provided for @emptySubtitleCheckBackCategory.
  ///
  /// In en, this message translates to:
  /// **'Check back later'**
  String get emptySubtitleCheckBackCategory;

  /// No description provided for @emptyCategoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No articles in this category'**
  String get emptyCategoryEmpty;

  /// No description provided for @errorOffline.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline'**
  String get errorOffline;

  /// No description provided for @errorServerUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Server unavailable'**
  String get errorServerUnavailable;

  /// No description provided for @errorSomethingWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorSomethingWrong;

  /// No description provided for @errorNoInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get errorNoInternetConnection;

  /// No description provided for @errorSearchFailed.
  ///
  /// In en, this message translates to:
  /// **'Search failed'**
  String get errorSearchFailed;

  /// No description provided for @errorLoadingHistory.
  ///
  /// In en, this message translates to:
  /// **'Error loading history'**
  String get errorLoadingHistory;

  /// No description provided for @errorFailedToLoadTrending.
  ///
  /// In en, this message translates to:
  /// **'Failed to load trending'**
  String get errorFailedToLoadTrending;

  /// No description provided for @errorFailedToLoadArticles.
  ///
  /// In en, this message translates to:
  /// **'Failed to load articles'**
  String get errorFailedToLoadArticles;

  /// No description provided for @errorOfflineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please check your connection and try again'**
  String get errorOfflineSubtitle;

  /// No description provided for @errorServerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pull down to refresh'**
  String get errorServerSubtitle;

  /// No description provided for @errorNetworkSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please check your network and try again'**
  String get errorNetworkSubtitle;

  /// No description provided for @errorRetrySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap retry to load again'**
  String get errorRetrySubtitle;

  /// No description provided for @btnRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get btnRetry;

  /// No description provided for @btnTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get btnTryAgain;

  /// No description provided for @btnClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get btnClearAll;

  /// No description provided for @btnCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get btnCancel;

  /// No description provided for @btnWatchAd.
  ///
  /// In en, this message translates to:
  /// **'Watch Ad'**
  String get btnWatchAd;

  /// No description provided for @btnWatchVideo.
  ///
  /// In en, this message translates to:
  /// **'Watch Video'**
  String get btnWatchVideo;

  /// No description provided for @btnUnlockAd.
  ///
  /// In en, this message translates to:
  /// **'Unlock via Ad'**
  String get btnUnlockAd;

  /// No description provided for @promptWatchAd.
  ///
  /// In en, this message translates to:
  /// **'Watch a short ad to continue reading'**
  String get promptWatchAd;

  /// No description provided for @promptUnlockPremium.
  ///
  /// In en, this message translates to:
  /// **'Unlock Premium Content'**
  String get promptUnlockPremium;

  /// No description provided for @promptWatchVideo.
  ///
  /// In en, this message translates to:
  /// **'Watch a short video to unlock this article for free!'**
  String get promptWatchVideo;

  /// No description provided for @promptUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock to read the full article'**
  String get promptUnlock;

  /// No description provided for @promptContinueAd.
  ///
  /// In en, this message translates to:
  /// **'Continue reading by watching a short ad...'**
  String get promptContinueAd;

  /// No description provided for @contentUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Content unlocked!'**
  String get contentUnlocked;

  /// No description provided for @searchHintArticles.
  ///
  /// In en, this message translates to:
  /// **'Search articles...'**
  String get searchHintArticles;

  /// No description provided for @searchHintTopics.
  ///
  /// In en, this message translates to:
  /// **'Search articles, topics...'**
  String get searchHintTopics;

  /// No description provided for @connectionRestored.
  ///
  /// In en, this message translates to:
  /// **'Connection restored. Refreshing content...'**
  String get connectionRestored;

  /// No description provided for @timeJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get timeJustNow;

  /// No description provided for @timeMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m ago'**
  String timeMinutesAgo(int minutes);

  /// No description provided for @timeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours}h ago'**
  String timeHoursAgo(int hours);

  /// No description provided for @timeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days}d ago'**
  String timeDaysAgo(int days);

  /// No description provided for @categoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get categoryAll;

  /// No description provided for @categoryProgramming.
  ///
  /// In en, this message translates to:
  /// **'Programming'**
  String get categoryProgramming;

  /// No description provided for @categoryMobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get categoryMobile;

  /// No description provided for @categoryAiMl.
  ///
  /// In en, this message translates to:
  /// **'AI & ML'**
  String get categoryAiMl;

  /// No description provided for @categorySecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get categorySecurity;

  /// No description provided for @categoryCloud.
  ///
  /// In en, this message translates to:
  /// **'Cloud'**
  String get categoryCloud;

  /// No description provided for @categoryTechnology.
  ///
  /// In en, this message translates to:
  /// **'Technology'**
  String get categoryTechnology;

  /// No description provided for @categoryWebDev.
  ///
  /// In en, this message translates to:
  /// **'Web Dev'**
  String get categoryWebDev;

  /// No description provided for @categoryDevOps.
  ///
  /// In en, this message translates to:
  /// **'DevOps'**
  String get categoryDevOps;

  /// No description provided for @categoryData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get categoryData;

  /// No description provided for @categorySports.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get categorySports;

  /// No description provided for @categoryBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get categoryBusiness;

  /// No description provided for @categoryEntertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get categoryEntertainment;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'1.0.0'**
  String get version;

  /// No description provided for @channelName.
  ///
  /// In en, this message translates to:
  /// **'ZenaTech Notifications'**
  String get channelName;

  /// No description provided for @channelDescription.
  ///
  /// In en, this message translates to:
  /// **'Notifications from ZenaTech'**
  String get channelDescription;

  /// No description provided for @semanticsRemoveFavorite.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get semanticsRemoveFavorite;

  /// No description provided for @semanticsAddFavorite.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get semanticsAddFavorite;

  /// No description provided for @semanticsReadArticle.
  ///
  /// In en, this message translates to:
  /// **'Read article: {title}'**
  String semanticsReadArticle(String title);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['am', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'am':
      return AppLocalizationsAm();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
