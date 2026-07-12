import '../../domain/entities/article.dart';
import '../../domain/repositories/article_repository.dart';
import '../datasources/remote/article_remote_datasource.dart';
import '../../core/services/user_service.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final ArticleRemoteDatasource _remoteDatasource;

  ArticleRepositoryImpl(this._remoteDatasource);

  @override
  Future<List<Article>> getArticles({int page = 1, int limit = 20}) async {
    final models = await _remoteDatasource.getArticles(
      page: page,
      limit: limit,
    );
    return models;
  }

  @override
  Future<Article> getArticleById(String id) async {
    return await _remoteDatasource.getArticleById(id);
  }

  @override
  Future<List<Article>> searchArticles(
    String query, {
    int page = 1,
    int limit = 20,
  }) async {
    final models = await _remoteDatasource.searchArticles(
      query,
      page: page,
      limit: limit,
    );
    return models;
  }

  @override
  Future<List<Article>> getArticlesByCategory(
    String categoryId, {
    int page = 1,
    int limit = 20,
  }) async {
    final models = await _remoteDatasource.getArticlesByCategory(
      categoryId,
      page: page,
      limit: limit,
    );
    return models;
  }

  @override
  Future<List<Article>> getTrendingArticles() async {
    final models = await _remoteDatasource.getTrendingArticles(
      anonymousId: userService.anonymousId,
    );
    return models;
  }
}
