import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:techpulse/core/constants/api_constants.dart';
import 'package:techpulse/core/errors/exceptions.dart';
import 'package:techpulse/data/datasources/local/favorites_local_datasource.dart';
import 'package:techpulse/data/models/article_model.dart';
import 'package:techpulse/domain/entities/article.dart';

void main() {
  late Directory tempDir;
  late FavoritesLocalDatasourceImpl datasource;

  ArticleModel article({
    String id = '1',
    String title = 'Test Article',
  }) {
    return ArticleModel(
      id: id,
      title: title,
      category: 'tech',
      content: 'Content',
      thumbnailUrl: '',
      publishedDate: DateTime(2024, 1, 1),
      views: 5,
      isPremium: false,
    );
  }

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('favorites_test');
    Hive.init(tempDir.path);
    datasource = FavoritesLocalDatasourceImpl();
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  group('FavoritesLocalDatasource', () {
    test('adds and retrieves a favorite', () async {
      await datasource.addFavorite(article());

      final favorites = await datasource.getFavorites();

      expect(favorites, hasLength(1));
      expect(favorites[0].id, '1');
      expect(favorites[0].title, 'Test Article');
    });

    test('retrieves multiple favorites', () async {
      await datasource.addFavorite(article(id: '1'));
      await datasource.addFavorite(article(id: '2', title: 'Second'));

      final favorites = await datasource.getFavorites();

      expect(favorites, hasLength(2));
    });

    test('returns empty list when no favorites', () async {
      final favorites = await datasource.getFavorites();

      expect(favorites, isEmpty);
    });

    test('removes a favorite', () async {
      await datasource.addFavorite(article(id: '1'));
      await datasource.addFavorite(article(id: '2', title: 'Second'));

      await datasource.removeFavorite('1');

      final favorites = await datasource.getFavorites();
      expect(favorites, hasLength(1));
      expect(favorites[0].id, '2');
    });

    test('removing a non-existent favorite is a no-op', () async {
      await datasource.removeFavorite('missing');

      final favorites = await datasource.getFavorites();
      expect(favorites, isEmpty);
    });

    test('isFavorite returns true for existing favorite', () async {
      await datasource.addFavorite(article());

      expect(await datasource.isFavorite('1'), isTrue);
      expect(await datasource.isFavorite('nope'), isFalse);
    });

    test('overwrites favorite with same id', () async {
      await datasource.addFavorite(article(id: '1', title: 'Original'));
      await datasource.addFavorite(article(id: '1', title: 'Updated'));

      final favorites = await datasource.getFavorites();

      expect(favorites, hasLength(1));
      expect(favorites[0].title, 'Updated');
    });

    test('round-trips full article data', () async {
      await datasource.addFavorite(
        ArticleModel(
          id: '10',
          title: 'Deep Dive',
          category: 'science',
          content: '<p>Body</p>',
          thumbnailUrl: 'https://example.com/thumb.jpg',
          publishedDate: DateTime(2024, 5, 10),
          views: 99,
          readingTime: 7,
          isPremium: true,
          articleType: ArticleType.deepDive,
          affiliateLinks: [
            const AffiliateLinkModel(label: 'Buy', url: 'https://buy.com'),
          ],
        ),
      );

      final favorites = await datasource.getFavorites();
      final restored = favorites.single;

      expect(restored.title, 'Deep Dive');
      expect(restored.category, 'science');
      expect(restored.thumbnailUrl, 'https://example.com/thumb.jpg');
      expect(restored.views, 99);
      expect(restored.readingTime, 7);
      expect(restored.isPremium, isTrue);
      expect(restored.articleType, ArticleType.deepDive);
      expect(restored.affiliateLinks, hasLength(1));
    });
  });

  group('FavoritesLocalDatasource error handling', () {
    test('throws CacheException on corrupt stored data', () async {
      final box = await Hive.openBox<String>(AppConstants.favoritesBox);
      await box.put('bad', 'not valid json');

      await expectLater(
        datasource.getFavorites(),
        throwsA(isA<CacheException>()),
      );
    });
  });
}
