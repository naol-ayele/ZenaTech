import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:techpulse/data/datasources/local/favorites_local_datasource.dart';
import 'package:techpulse/data/datasources/local/search_history_local_datasource.dart';
import 'package:techpulse/data/models/article_model.dart';
import 'package:techpulse/data/models/search_query_model.dart';
import 'package:techpulse/data/repositories/local_repository_impl.dart';
import 'package:techpulse/domain/entities/article.dart';
import 'package:techpulse/domain/entities/search_query.dart';

class MockFavoritesDatasource extends Mock implements FavoritesLocalDatasource {}

class MockSearchHistoryDatasource extends Mock
    implements SearchHistoryLocalDatasource {}

void main() {
  late LocalRepositoryImpl repository;
  late MockFavoritesDatasource mockFavorites;
  late MockSearchHistoryDatasource mockSearchHistory;

  Article article({String id = '1'}) {
    return Article(
      id: id,
      title: 'Test',
      category: 'tech',
      content: 'Content',
      thumbnailUrl: 'https://example.com/img.jpg',
      publishedDate: DateTime(2024, 1, 1),
      views: 5,
      isPremium: true,
      affiliateLinks: const [AffiliateLink(label: 'Buy', url: 'https://buy.com')],
    );
  }

  setUpAll(() {
    registerFallbackValue(
      ArticleModel(
        id: '1',
        title: 'T',
        category: 'c',
        content: 'c',
        thumbnailUrl: '',
        publishedDate: DateTime(2024),
        views: 0,
        isPremium: false,
      ),
    );
    registerFallbackValue(
      SearchQueryModel(query: 'q', timestamp: DateTime(2024)),
    );
  });

  setUp(() {
    mockFavorites = MockFavoritesDatasource();
    mockSearchHistory = MockSearchHistoryDatasource();
    repository = LocalRepositoryImpl(mockFavorites, mockSearchHistory);
  });

  group('favorites', () {
    test('getFavorites delegates to datasource', () async {
      when(() => mockFavorites.getFavorites()).thenAnswer((_) async => []);

      final favorites = await repository.getFavorites();

      expect(favorites, isEmpty);
      verify(() => mockFavorites.getFavorites()).called(1);
    });

    test('addFavorite converts Article to ArticleModel', () async {
      when(() => mockFavorites.addFavorite(any())).thenAnswer((_) async {});

      await repository.addFavorite(article());

      final captured = verify(
        () => mockFavorites.addFavorite(captureAny()),
      ).captured.single as ArticleModel;
      expect(captured.id, '1');
      expect(captured.title, 'Test');
      expect(captured.category, 'tech');
      expect(captured.thumbnailUrl, 'https://example.com/img.jpg');
      expect(captured.views, 5);
      expect(captured.isPremium, isTrue);
      expect(captured.affiliateLinks, hasLength(1));
    });

    test('removeFavorite delegates with id', () async {
      when(() => mockFavorites.removeFavorite(any())).thenAnswer((_) async {});

      await repository.removeFavorite('42');

      verify(() => mockFavorites.removeFavorite('42')).called(1);
    });

    test('isFavorite delegates to datasource', () async {
      when(() => mockFavorites.isFavorite('42')).thenAnswer((_) async => true);

      expect(await repository.isFavorite('42'), isTrue);
    });
  });

  group('search history', () {
    test('getSearchHistory delegates to datasource', () async {
      when(() => mockSearchHistory.getSearchHistory()).thenAnswer(
        (_) async => [
          SearchQueryModel(query: 'a', timestamp: DateTime(2024, 1, 1)),
        ],
      );

      final history = await repository.getSearchHistory();

      expect(history, hasLength(1));
      expect(history[0], isA<SearchQuery>());
    });

    test('addSearchQuery converts SearchQuery to model', () async {
      when(() => mockSearchHistory.addSearchQuery(any())).thenAnswer(
        (_) async {},
      );

      final query = SearchQuery(
        query: 'flutter',
        timestamp: DateTime(2024, 2, 2),
      );
      await repository.addSearchQuery(query);

      final captured = verify(
        () => mockSearchHistory.addSearchQuery(captureAny()),
      ).captured.single as SearchQueryModel;
      expect(captured.query, 'flutter');
      expect(captured.timestamp, DateTime(2024, 2, 2));
    });

    test('clearSearchHistory delegates', () async {
      when(() => mockSearchHistory.clearHistory()).thenAnswer((_) async {});

      await repository.clearSearchHistory();

      verify(() => mockSearchHistory.clearHistory()).called(1);
    });
  });
}
