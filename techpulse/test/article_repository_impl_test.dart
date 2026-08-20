import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:techpulse/data/datasources/remote/article_remote_datasource.dart';
import 'package:techpulse/data/models/article_model.dart';
import 'package:techpulse/data/repositories/article_repository_impl.dart';
import 'package:techpulse/domain/entities/article.dart';

class MockArticleRemoteDatasource extends Mock
    implements ArticleRemoteDatasource {}

void main() {
  late ArticleRepositoryImpl repository;
  late MockArticleRemoteDatasource mockDatasource;

  ArticleModel article({String id = '1'}) {
    return ArticleModel(
      id: id,
      title: 'Test',
      category: 'tech',
      content: 'Content',
      thumbnailUrl: '',
      publishedDate: DateTime(2024, 1, 1),
      views: 1,
      isPremium: false,
    );
  }

  setUp(() {
    mockDatasource = MockArticleRemoteDatasource();
    repository = ArticleRepositoryImpl(mockDatasource);
  });

  group('getArticles', () {
    test('delegates to datasource with defaults', () async {
      when(() => mockDatasource.getArticles(page: any(named: 'page'), limit: any(named: 'limit')))
          .thenAnswer((_) async => [article()]);

      final articles = await repository.getArticles();

      expect(articles, hasLength(1));
      expect(articles[0], isA<Article>());
      verify(() => mockDatasource.getArticles(page: 1, limit: 20)).called(1);
    });

    test('passes page and limit through', () async {
      when(() => mockDatasource.getArticles(page: any(named: 'page'), limit: any(named: 'limit')))
          .thenAnswer((_) async => []);

      await repository.getArticles(page: 2, limit: 10);

      verify(() => mockDatasource.getArticles(page: 2, limit: 10)).called(1);
    });
  });

  group('getArticleById', () {
    test('delegates to datasource', () async {
      when(() => mockDatasource.getArticleById('abc')).thenAnswer(
        (_) async => article(id: 'abc'),
      );

      final result = await repository.getArticleById('abc');

      expect(result.id, 'abc');
      verify(() => mockDatasource.getArticleById('abc')).called(1);
    });
  });

  group('searchArticles', () {
    test('delegates with query and defaults', () async {
      when(() => mockDatasource.searchArticles(
        any(),
        page: any(named: 'page'),
        limit: any(named: 'limit'),
      )).thenAnswer((_) async => [article()]);

      final results = await repository.searchArticles('flutter');

      expect(results, hasLength(1));
      verify(() => mockDatasource.searchArticles('flutter', page: 1, limit: 20))
          .called(1);
    });
  });

  group('getArticlesByCategory', () {
    test('delegates with category id', () async {
      when(() => mockDatasource.getArticlesByCategory(
        any(),
        page: any(named: 'page'),
        limit: any(named: 'limit'),
      )).thenAnswer((_) async => []);

      await repository.getArticlesByCategory('tech');

      verify(
        () => mockDatasource.getArticlesByCategory('tech', page: 1, limit: 20),
      ).called(1);
    });
  });

  group('getTrendingArticles', () {
    test('delegates to datasource', () async {
      when(
        () => mockDatasource.getTrendingArticles(
          anonymousId: any(named: 'anonymousId'),
        ),
      ).thenAnswer((_) async => [article()]);

      final results = await repository.getTrendingArticles();

      expect(results, hasLength(1));
      verify(
        () => mockDatasource.getTrendingArticles(anonymousId: null),
      ).called(1);
    });
  });
}
