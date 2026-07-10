import 'package:dio/dio.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/remote/category_remote_datasource.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDatasource _remoteDatasource;

  CategoryRepositoryImpl(this._remoteDatasource);

  @override
  Future<List<Category>> getCategories() async {
    try {
      return await _remoteDatasource.getCategories();
    } on DioException {
      return [];
    }
  }
}
