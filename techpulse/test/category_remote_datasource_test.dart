import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:techpulse/core/constants/api_constants.dart';
import 'package:techpulse/core/network/dio_client.dart';
import 'package:techpulse/data/datasources/remote/category_remote_datasource.dart';

class MockDioClient extends Mock implements DioClient {}

void main() {
  late CategoryRemoteDatasourceImpl datasource;
  late MockDioClient mockDio;

  setUp(() {
    mockDio = MockDioClient();
    datasource = CategoryRemoteDatasourceImpl(mockDio);
  });

  group('getCategories', () {
    test('returns categories on success', () async {
      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          data: {
            'categories': [
              {
                'id': 'tech',
                'name': 'Technology',
                'icon': 'code',
                'article_count': 10,
              },
              {
                'id': 'science',
                'name': 'Science',
                'icon': 'atom',
                'article_count': 4,
              },
            ],
          },
          statusCode: 200,
        ),
      );

      final categories = await datasource.getCategories();

      expect(categories, hasLength(2));
      expect(categories[0].id, 'tech');
      expect(categories[1].name, 'Science');
      verify(() => mockDio.get(ApiConstants.categories)).called(1);
    });

    test('handles missing categories key', () async {
      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          data: <String, dynamic>{},
          statusCode: 200,
        ),
      );

      final categories = await datasource.getCategories();

      expect(categories, isEmpty);
    });
  });
}
