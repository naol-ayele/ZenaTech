import 'package:flutter_test/flutter_test.dart';
import 'package:techpulse/data/models/category_model.dart';

void main() {
  group('CategoryModel fromJson', () {
    test('parses full category JSON correctly', () {
      final json = {
        'id': 'tech',
        'name': 'Technology',
        'icon': 'code',
        'article_count': 42,
      };

      final category = CategoryModel.fromJson(json);

      expect(category.id, 'tech');
      expect(category.name, 'Technology');
      expect(category.icon, 'code');
      expect(category.articleCount, 42);
    });

    test('parses missing fields with defaults', () {
      final json = <String, dynamic>{};

      final category = CategoryModel.fromJson(json);

      expect(category.id, '');
      expect(category.name, '');
      expect(category.icon, '');
      expect(category.articleCount, 0);
    });

    test('parses article_count as string', () {
      final json = {
        'id': 'science',
        'name': 'Science',
        'icon': 'atom',
        'article_count': '7',
      };

      final category = CategoryModel.fromJson(json);

      expect(category.articleCount, 7);
    });

    test('parses invalid article_count as 0', () {
      final json = {
        'id': 'x',
        'name': 'X',
        'icon': 'x',
        'article_count': 'abc',
      };

      final category = CategoryModel.fromJson(json);

      expect(category.articleCount, 0);
    });
  });

  group('CategoryModel toJson', () {
    test('produces valid JSON round-trip', () {
      final original = CategoryModel(
        id: 'tech',
        name: 'Technology',
        icon: 'code',
        articleCount: 5,
      );

      final json = original.toJson();
      final restored = CategoryModel.fromJson(json);

      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.icon, original.icon);
      expect(restored.articleCount, original.articleCount);
    });
  });
}
