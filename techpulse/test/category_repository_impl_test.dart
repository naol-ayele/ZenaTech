import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:techpulse/data/datasources/remote/category_remote_datasource.dart';
import 'package:techpulse/data/models/category_model.dart';
import 'package:techpulse/data/repositories/category_repository_impl.dart';

class MockCategoryRemoteDatasource extends Mock
    implements CategoryRemoteDatasource {}

void main() {
  late CategoryRepositoryImpl repository;
  late MockCategoryRemoteDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockCategoryRemoteDatasource();
    repository = CategoryRepositoryImpl(mockDatasource);
  });

  group('getCategories', () {
    test('returns categories on success', () async {
      when(() => mockDatasource.getCategories()).thenAnswer(
        (_) async => [
          CategoryModel(id: 'tech', name: 'Tech', icon: 'code', articleCount: 1),
        ],
      );

      final categories = await repository.getCategories();

      expect(categories, hasLength(1));
      expect(categories[0].id, 'tech');
    });

    test('returns empty list on DioException', () async {
      when(() => mockDatasource.getCategories()).thenThrow(
        DioException(requestOptions: RequestOptions(path: '')),
      );

      final categories = await repository.getCategories();

      expect(categories, isEmpty);
    });

    test('propagates non-Dio exceptions', () async {
      when(() => mockDatasource.getCategories()).thenThrow(
        Exception('boom'),
      );

      expect(() => repository.getCategories(), throwsException);
    });
  });
}
