import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:techpulse/core/constants/api_constants.dart';
import 'package:techpulse/core/network/dio_client.dart';
import 'package:techpulse/data/datasources/remote/article_remote_datasource.dart';
import 'package:techpulse/data/models/article_model.dart';

class MockDioClient extends Mock implements DioClient {}

void main() {
  late ArticleRemoteDatasourceImpl datasource;
  late MockDioClient mockDio;

  setUp(() {
    mockDio = MockDioClient();
    datasource = ArticleRemoteDatasourceImpl(mockDio);
  });

  group('getArticles', () {
    test('returns articles on success', () async {
      when(() => mockDio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: {
              'articles': [
                {
                  'id': '1',
                  'title': 'Test',
                  'category': 'tech',
                  'content': 'Content',
                  'thumbnail_url': '',
                  'published_date': '2024-01-01',
                  'views': 5,
                  'is_premium': false,
                },
              ],
              'pagination': {
                'page': 1,
                'limit': 20,
                'total': 1,
                'totalPages': 1,
              },
            },
            statusCode: 200,
          ));

      final articles = await datasource.getArticles();

      expect(articles, hasLength(1));
      expect(articles[0].id, '1');
      expect(articles[0].title, 'Test');
      verify(() => mockDio.get(
            ApiConstants.articles,
            queryParameters: any(named: 'queryParameters'),
          )).called(1);
    });

    test('handles empty articles list', () async {
      when(() => mockDio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: {'articles': []},
            statusCode: 200,
          ));

      final articles = await datasource.getArticles();
      expect(articles, isEmpty);
    });
  });

  group('searchArticles', () {
    test('passes query parameter', () async {
      when(() => mockDio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: {'articles': []},
            statusCode: 200,
          ));

      await datasource.searchArticles('flutter');

      verify(() => mockDio.get(
            ApiConstants.search,
            queryParameters: {
              'q': 'flutter',
              'page': 1,
              'limit': 20,
            },
          )).called(1);
    });
  });

  group('getTrendingArticles', () {
    test('sends anonymousId header when provided', () async {
      when(() => mockDio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: {'articles': []},
            statusCode: 200,
          ));

      await datasource.getTrendingArticles(anonymousId: 'anony_123');

      verify(() => mockDio.get(
            ApiConstants.trending,
            queryParameters: {'limit': 20},
            options: any(named: 'options'),
          )).called(1);
    });

    test('works without anonymousId', () async {
      when(() => mockDio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: {'articles': []},
            statusCode: 200,
          ));

      await datasource.getTrendingArticles();

      verify(() => mockDio.get(
            ApiConstants.trending,
            queryParameters: {'limit': 20},
          )).called(1);
    });
  });
}
