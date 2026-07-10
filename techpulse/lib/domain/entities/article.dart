enum ArticleType { standard, featured, deepDive }

class Article {
  final String id;
  final String title;
  final String category;
  final String content;
  final String thumbnailUrl;
  final DateTime publishedDate;
  final int views;
  final int readingTime;
  final bool isPremium;
  final ArticleType articleType;
  final List<AffiliateLink> affiliateLinks;

  const Article({
    required this.id,
    required this.title,
    required this.category,
    required this.content,
    required this.thumbnailUrl,
    required this.publishedDate,
    required this.views,
    this.readingTime = 1,
    required this.isPremium,
    this.articleType = ArticleType.standard,
    this.affiliateLinks = const [],
  });

  Article copyWith({
    String? id,
    String? title,
    String? category,
    String? content,
    String? thumbnailUrl,
    DateTime? publishedDate,
    int? views,
    int? readingTime,
    bool? isPremium,
    ArticleType? articleType,
    List<AffiliateLink>? affiliateLinks,
  }) {
    return Article(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      content: content ?? this.content,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      publishedDate: publishedDate ?? this.publishedDate,
      views: views ?? this.views,
      readingTime: readingTime ?? this.readingTime,
      isPremium: isPremium ?? this.isPremium,
      articleType: articleType ?? this.articleType,
      affiliateLinks: affiliateLinks ?? this.affiliateLinks,
    );
  }
}

class AffiliateLink {
  final String label;
  final String url;

  const AffiliateLink({required this.label, required this.url});
}
