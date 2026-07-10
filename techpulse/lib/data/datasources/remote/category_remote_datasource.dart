import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../../models/category_model.dart';

abstract class CategoryRemoteDatasource {
  Future<List<CategoryModel>> getCategories();
}

class CategoryRemoteDatasourceImpl implements CategoryRemoteDatasource {
  final DioClient _dioClient;

  CategoryRemoteDatasourceImpl(this._dioClient);

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await _dioClient.get(ApiConstants.categories);
    final List<dynamic> data = response.data['categories'] ?? [];
    return data
        .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
