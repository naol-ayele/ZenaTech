import 'dart:convert';
import '../../domain/entities/article.dart';

class ArticleModel extends Article {
  const ArticleModel({
    required super.id,
    required super.title,
    required super.category,
    required super.content,
    required super.thumbnailUrl,
    required super.publishedDate,
    required super.views,
    super.readingTime,
    required super.isPremium,
    super.articleType,
    super.affiliateLinks,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    final typeString = json['article_type'] as String? ?? 'standard';
    final articleType = ArticleType.values.firstWhere(
      (e) => e.name == typeString,
      orElse: () => ArticleType.standard,
    );

    return ArticleModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? '',
      content: json['content'] as String? ?? '',
      thumbnailUrl: json['thumbnail_url'] as String? ?? '',
      publishedDate:
          DateTime.tryParse(json['published_date'] as String? ?? '') ??
          DateTime.now(),
      views: int.tryParse(json['views']?.toString() ?? '') ?? 0,
      readingTime: int.tryParse(json['reading_time']?.toString() ?? '') ?? 1,
      isPremium: json['is_premium'] is bool
          ? json['is_premium']
          : json['is_premium'] == 'true',
      articleType: articleType,
      affiliateLinks:
          (json['affiliate_links'] as List<dynamic>?)
              ?.map(
                (e) => AffiliateLinkModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'content': content,
      'thumbnail_url': thumbnailUrl,
      'published_date': publishedDate.toIso8601String(),
      'views': views,
      'reading_time': readingTime,
      'is_premium': isPremium,
      'article_type': articleType.name,
      'affiliate_links': affiliateLinks
          .map((e) => AffiliateLinkModel(label: e.label, url: e.url).toJson())
          .toList(),
    };
  }

  String toJsonString() => jsonEncode(toJson());

  factory ArticleModel.fromJsonString(String jsonString) {
    return ArticleModel.fromJson(
      jsonDecode(jsonString) as Map<String, dynamic>,
    );
  }
}

class AffiliateLinkModel extends AffiliateLink {
  const AffiliateLinkModel({required super.label, required super.url});

  factory AffiliateLinkModel.fromJson(Map<String, dynamic> json) {
    return AffiliateLinkModel(
      label: json['label'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'label': label, 'url': url};
  }
}
