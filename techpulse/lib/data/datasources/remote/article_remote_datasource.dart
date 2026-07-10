import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../../models/article_model.dart';

abstract class ArticleRemoteDatasource {
  Future<List<ArticleModel>> getArticles({int page = 1, int limit = 20});
  Future<ArticleModel> getArticleById(String id);
  Future<List<ArticleModel>> searchArticles(
    String query, {
    int page = 1,
    int limit = 20,
  });
  Future<List<ArticleModel>> getArticlesByCategory(
    String categoryId, {
    int page = 1,
    int limit = 20,
  });
  Future<List<ArticleModel>> getTrendingArticles({String? anonymousId});
}

class ArticleRemoteDatasourceImpl implements ArticleRemoteDatasource {
  final DioClient _dioClient;

  ArticleRemoteDatasourceImpl(this._dioClient);

  @override
  Future<List<ArticleModel>> getArticles({int page = 1, int limit = 20}) async {
    final response = await _dioClient.get(
      ApiConstants.articles,
      queryParameters: {'page': page, 'limit': limit},
    );
    final List<dynamic> data = response.data['articles'] ?? [];
    return data
        .map((json) => ArticleModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ArticleModel> getArticleById(String id) async {
    final response = await _dioClient.get('${ApiConstants.articles}/$id');
    return ArticleModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<ArticleModel>> searchArticles(
    String query, {
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _dioClient.get(
      ApiConstants.search,
      queryParameters: {'q': query, 'page': page, 'limit': limit},
    );
    final List<dynamic> data = response.data['articles'] ?? [];
    return data
        .map((json) => ArticleModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ArticleModel>> getArticlesByCategory(
    String categoryId, {
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _dioClient.get(
      '${ApiConstants.categories}/$categoryId/articles',
      queryParameters: {'page': page, 'limit': limit},
    );
    final List<dynamic> data = response.data['articles'] ?? [];
    return data
        .map((json) => ArticleModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ArticleModel>> getTrendingArticles({String? anonymousId}) async {
    final response = await _dioClient.get(
      ApiConstants.trending,
      queryParameters: {'limit': 20},
      options: anonymousId != null
          ? Options(headers: {'x-anonymous-id': anonymousId})
          : null,
    );
    final List<dynamic> data = response.data['articles'] ?? [];
    return data
        .map((json) => ArticleModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
