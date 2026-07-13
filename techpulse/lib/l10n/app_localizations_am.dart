// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Amharic (`am`).
class AppLocalizationsAm extends AppLocalizations {
  AppLocalizationsAm([String locale = 'am']) : super(locale);

  @override
  String get navHome => 'መነሻ ገጽ';

  @override
  String get navExplore => 'ያስሱ';

  @override
  String get navTrending => 'ወክታዊ';

  @override
  String get navFavorite => 'የምወዳቸው';

  @override
  String get navSettings => 'ቅንብሮች';

  @override
  String get screenSearch => 'ፈልግ';

  @override
  String get screenFavorites => 'የምወዳቸው';

  @override
  String get screenCategories => 'ምድቦች';

  @override
  String get sectionTrendingNow => 'አሁን ወክታዊ';

  @override
  String get sectionLatestNews => 'የቅርብ ዜና';

  @override
  String get sectionTopCharts => 'ከፍተኛ ደረጃዎች';

  @override
  String get sectionRecentSearches => 'የቅርብ ፍለጋዎች';

  @override
  String get sectionAppearance => 'መልክ';

  @override
  String get sectionAbout => 'ስለ';

  @override
  String get sectionAffiliateLinks => 'አጋር አገናኞች';

  @override
  String get sectionLanguage => 'ቋንቋ';

  @override
  String get labelDarkMode => 'ጨለማ ሁነታ';

  @override
  String get labelCurrentlyDark => 'በአሁኑ ጨለማ';

  @override
  String get labelCurrentlyLight => 'በአሁኑ ብርሃን';

  @override
  String get labelVersion => 'ስሪት';

  @override
  String get labelDeveloper => 'ገንቢ';

  @override
  String get labelPrivacyPolicy => 'የግላዊነት ፖሊሲ';

  @override
  String get badgeLive => 'ቀጥታ';

  @override
  String get badgeNew => 'አዲስ';

  @override
  String get badgeTrending => 'ወክታዊ';

  @override
  String get badgePremium => 'ፕሪሚየም';

  @override
  String get badgePremiumContent => 'ፕሪሚየም ይዘት';

  @override
  String get badgeSponsored => 'ስፖንሰር የተደረገ';

  @override
  String get badgeAdShort => 'ማስታወቂያ';

  @override
  String get labelAdvertisement => 'ማስታወቂያ';

  @override
  String get labelDeepDive => 'ጥልቅ ትንታኔ';

  @override
  String get labelFeatured => 'የተለየ';

  @override
  String labelMinRead(int minutes) {
    return '$minutes ደቂቃ ንባብ';
  }

  @override
  String labelViews(int count) {
    return '$count እይታዎች';
  }

  @override
  String labelArticles(int count) {
    return '$count መጣጥፎች';
  }

  @override
  String get emptyNoTrending => 'ምንም ወክታዊ መጣጥፎች የሉም';

  @override
  String get emptyNoFavorites => 'ገና ምንም የምወዳቸው የሉም';

  @override
  String get emptyNoSearches => 'ምንም የቅርብ ፍለጋዎች የሉም';

  @override
  String get emptyNoResults => 'ምንም ውጤት አልተገኘም';

  @override
  String get emptyNoArticles => 'ገና ምንም መጣጥፎች የሉም';

  @override
  String get emptySubtitleSaveArticles => 'የሚወዷቸውን መጣጥፎች ማስቀመጥ ይጀምሩ';

  @override
  String get emptySubtitleTryDifferent => 'የተለየ የፍለጋ ቃል ይሞክሩ';

  @override
  String get emptySubtitleCheckBack => 'ለአዲስ ይዘት በኋላ ይመልሱ';

  @override
  String get emptySubtitleCheckBackCategory => 'በኋላ ይመልሱ';

  @override
  String get emptyCategoryEmpty => 'በዚህ ምድብ ውስጥ ምንም መጣጥፎች የሉም';

  @override
  String get errorOffline => 'ከመስመር ውጪ ነዎት';

  @override
  String get errorServerUnavailable => 'አገልጋይ አይገኝም';

  @override
  String get errorSomethingWrong => 'የሆነ ችግር ተፈጥሯል';

  @override
  String get errorNoInternetConnection => 'የበይነመረብ ግንኙነት የለም';

  @override
  String get errorSearchFailed => 'ፍለጋ አልተሳካም';

  @override
  String get errorLoadingHistory => 'ታሪክ በመጫን ላይ ስህተት';

  @override
  String get errorFailedToLoadTrending => 'ወክታዊ መጣጥፎችን መጫን አልተሳካም';

  @override
  String get errorFailedToLoadArticles => 'መጣጥፎችን መጫን አልተሳካም';

  @override
  String get errorOfflineSubtitle => 'እባክዎ ግንኙነትዎን ያረጋግጡ እና እንደገና ይሞክሩ';

  @override
  String get errorServerSubtitle => 'ለማደስ ወደ ታች ይጎትቱ';

  @override
  String get errorNetworkSubtitle => 'እባክዎ አውታረ መረብዎን ያረጋግጡ እና እንደገና ይሞክሩ';

  @override
  String get errorRetrySubtitle => 'እንደገና ለመሞከር ይንኩ';

  @override
  String get btnRetry => 'እንደገና ሞክር';

  @override
  String get btnTryAgain => 'እንደገና ሞክር';

  @override
  String get btnClearAll => 'ሁሉንም አጽዳ';

  @override
  String get btnCancel => 'ሰርዝ';

  @override
  String get btnWatchAd => 'ማስታወቂያ ይመልከቱ';

  @override
  String get btnWatchVideo => 'ቪዲዮ ይመልከቱ';

  @override
  String get btnUnlockAd => 'በማስታወቂያ ይክፈቱ';

  @override
  String get promptWatchAd => 'ለማንበብ ለመቀጠል አጭር ማስታወቂያ ይመልከቱ';

  @override
  String get promptUnlockPremium => 'ፕሪሚየም ይዘትን ይክፈቱ';

  @override
  String get promptWatchVideo => 'ይህን መጣጥፍ በነጻ ለማንበብ አጭር ቪዲዮ ይመልከቱ!';

  @override
  String get promptUnlock => 'ሙሉ መጣጥፉን ለማንበብ ይክፈቱ';

  @override
  String get promptContinueAd => 'አጭር ማስታወቂያ በመመልከት ማንበብዎን ይቀጥሉ...';

  @override
  String get contentUnlocked => 'ይዘት ተከፍቷል!';

  @override
  String get searchHintArticles => 'መጣጥፎችን ይፈልጉ...';

  @override
  String get searchHintTopics => 'መጣጥፎችን፣ ርዕሶችን ይፈልጉ...';

  @override
  String get connectionRestored => 'ግንኙነት ተመልሷል። ይዘትን በማደስ ላይ...';

  @override
  String get timeJustNow => 'አሁን ያህል';

  @override
  String timeMinutesAgo(int minutes) {
    return 'ከ$minutes ደቂቃ በፊት';
  }

  @override
  String timeHoursAgo(int hours) {
    return 'ከ$hours ሰዓት በፊት';
  }

  @override
  String timeDaysAgo(int days) {
    return 'ከ$days ቀን በፊት';
  }

  @override
  String get categoryAll => 'ሁሉም';

  @override
  String get categoryProgramming => 'ፕሮግራሚንግ';

  @override
  String get categoryMobile => 'ሞባይል';

  @override
  String get categoryAiMl => 'AI እና ML';

  @override
  String get categorySecurity => 'ደህንነት';

  @override
  String get categoryCloud => 'ክላውድ';

  @override
  String get categoryTechnology => 'ቴክኖሎጂ';

  @override
  String get categoryWebDev => 'ዌብ ዴቭ';

  @override
  String get categoryDevOps => 'ዴቭኦፕስ';

  @override
  String get categoryData => 'ዳታ';

  @override
  String get categorySports => 'ስፖርት';

  @override
  String get categoryBusiness => 'ቢዝነስ';

  @override
  String get categoryEntertainment => 'መዝናኛ';

  @override
  String get version => '1.0.0';

  @override
  String get channelName => 'ZenaTech ማሳወቂያዎች';

  @override
  String get channelDescription => 'ከZenaTech የሚላኩ ማሳወቂያዎች';

  @override
  String get semanticsRemoveFavorite => 'ከምወዳቸው አስወግድ';

  @override
  String get semanticsAddFavorite => 'ወደ ምወዳቸው ጨምር';

  @override
  String semanticsReadArticle(String title) {
    return 'መጣጥፉን ያንብቡ፦ $title';
  }
}
