import 'package:flutter_test/flutter_test.dart';
import 'package:techpulse/data/models/article_model.dart';
import 'package:techpulse/domain/entities/article.dart';

void main() {
  group('ArticleModel fromJson', () {
    test('parses full article JSON correctly', () {
      final json = {
        'id': '1',
        'title': 'Test Article',
        'category': 'tech',
        'content': '<p>Hello world</p>',
        'thumbnail_url': 'https://example.com/image.jpg',
        'published_date': '2024-01-15T10:00:00.000Z',
        'views': 42,
        'reading_time': 3,
        'is_premium': false,
        'article_type': 'standard',
        'affiliate_links': [
          {'label': 'Buy Now', 'url': 'https://example.com/buy'},
        ],
      };

      final article = ArticleModel.fromJson(json);

      expect(article.id, '1');
      expect(article.title, 'Test Article');
      expect(article.category, 'tech');
      expect(article.content, '<p>Hello world</p>');
      expect(article.thumbnailUrl, 'https://example.com/image.jpg');
      expect(article.views, 42);
      expect(article.readingTime, 3);
      expect(article.isPremium, false);
      expect(article.articleType, ArticleType.standard);
      expect(article.affiliateLinks, hasLength(1));
      expect(article.affiliateLinks[0].label, 'Buy Now');
    });

    test('parses minimal JSON with defaults', () {
      final json = {
        'id': '2',
        'title': 'Minimal',
        'category': 'science',
        'content': '',
        'thumbnail_url': '',
        'published_date': '2024-01-01',
        'views': 0,
        'is_premium': 'false',
      };

      final article = ArticleModel.fromJson(json);

      expect(article.id, '2');
      expect(article.title, 'Minimal');
      expect(article.isPremium, false);
      expect(article.affiliateLinks, isEmpty);
      expect(article.articleType, ArticleType.standard);
    });

    test('handles missing fields gracefully', () {
      final json = <String, dynamic>{};

      final article = ArticleModel.fromJson(json);

      expect(article.id, '');
      expect(article.title, '');
      expect(article.category, '');
      expect(article.content, '');
      expect(article.views, 0);
      expect(article.isPremium, false);
    });
  });

  group('ArticleModel toJson', () {
    test('produces valid JSON round-trip', () {
      final original = ArticleModel(
        id: '1',
        title: 'Round Trip',
        category: 'tech',
        content: 'Content',
        thumbnailUrl: 'https://example.com/img.jpg',
        publishedDate: DateTime(2024, 1, 15),
        views: 10,
        readingTime: 2,
        isPremium: true,
        articleType: ArticleType.featured,
        affiliateLinks: [
          const AffiliateLinkModel(label: 'Link', url: 'https://ex.com'),
        ],
      );

      final json = original.toJson();
      final restored = ArticleModel.fromJson(json);

      expect(restored.id, original.id);
      expect(restored.title, original.title);
      expect(restored.category, original.category);
      expect(restored.views, original.views);
      expect(restored.isPremium, original.isPremium);
      expect(restored.affiliateLinks, hasLength(1));
    });

    test('toJsonString produces parseable string', () {
      final article = ArticleModel(
        id: '1',
        title: 'Test',
        category: 'tech',
        content: 'Content',
        thumbnailUrl: '',
        publishedDate: DateTime(2024, 1, 1),
        views: 5,
        isPremium: false,
        affiliateLinks: [],
      );

      final jsonString = article.toJsonString();
      final restored = ArticleModel.fromJsonString(jsonString);

      expect(restored.id, article.id);
      expect(restored.title, article.title);
    });
  });

  group('ArticleModel isPremium parsing', () {
    test('parses bool true', () {
      final article = ArticleModel.fromJson({
        'id': '1', 'title': 'P', 'category': 't', 'content': '',
        'thumbnail_url': '', 'published_date': '2024-01-01', 'views': 0,
        'is_premium': true,
      });
      expect(article.isPremium, true);
    });

    test('parses bool false', () {
      final article = ArticleModel.fromJson({
        'id': '1', 'title': 'P', 'category': 't', 'content': '',
        'thumbnail_url': '', 'published_date': '2024-01-01', 'views': 0,
        'is_premium': false,
      });
      expect(article.isPremium, false);
    });

    test('parses string "true"', () {
      final article = ArticleModel.fromJson({
        'id': '1', 'title': 'P', 'category': 't', 'content': '',
        'thumbnail_url': '', 'published_date': '2024-01-01', 'views': 0,
        'is_premium': 'true',
      });
      expect(article.isPremium, true);
    });
  });
}
