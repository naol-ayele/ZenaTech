import 'package:dio/dio.dart';
import '../../domain/entities/article.dart';
import '../../domain/repositories/article_repository.dart';
import '../datasources/remote/article_remote_datasource.dart';
import '../datasources/local/article_local_datasource.dart';
import '../../core/services/user_service.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final ArticleRemoteDatasource _remoteDatasource;
  final ArticleLocalDatasource _localDatasource;

  ArticleRepositoryImpl(this._remoteDatasource, this._localDatasource);

  @override
  Future<List<Article>> getArticles({int page = 1, int limit = 20}) async {
    try {
      final models = await _remoteDatasource.getArticles(
        page: page,
        limit: limit,
      );
      await _localDatasource.cacheArticles(
        models,
        key: 'articles_page_$page',
      );
      return models;
    } on DioException {
      return _localDatasource.getCachedArticles(key: 'articles_page_$page');
    }
  }

  @override
  Future<Article> getArticleById(String id) async {
    try {
      final article = await _remoteDatasource.getArticleById(id);
      await _localDatasource.cacheArticle(article);
      return article;
    } on DioException {
      final cached = await _localDatasource.getCachedArticle(id);
      if (cached != null) return cached;
      rethrow;
    }
  }

  @override
  Future<List<Article>> searchArticles(
    String query, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final models = await _remoteDatasource.searchArticles(
        query,
        page: page,
        limit: limit,
      );
      await _localDatasource.cacheArticles(
        models,
        key: 'search_${query}_page_$page',
      );
      return models;
    } on DioException {
      return _localDatasource.getCachedArticles(
        key: 'search_${query}_page_$page',
      );
    }
  }

  @override
  Future<List<Article>> getArticlesByCategory(
    String categoryId, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final models = await _remoteDatasource.getArticlesByCategory(
        categoryId,
        page: page,
        limit: limit,
      );
      await _localDatasource.cacheArticles(
        models,
        key: 'category_${categoryId}_page_$page',
      );
      return models;
    } on DioException {
      return _localDatasource.getCachedArticles(
        key: 'category_${categoryId}_page_$page',
      );
    }
  }

  @override
  Future<List<Article>> getTrendingArticles() async {
    try {
      final anonymousId = userService.anonymousId;
      final models = await _remoteDatasource.getTrendingArticles(
        anonymousId: anonymousId,
      );
      await _localDatasource.cacheArticles(models, key: 'trending');
      return models;
    } on DioException {
      return _localDatasource.getCachedArticles(key: 'trending');
    }
  }

  @override
  Future<List<Article>> getFavoriteArticles(List<String> ids) async {
    try {
      final allArticles = await _remoteDatasource.getArticles(
        page: 1,
        limit: 50,
      );
      return allArticles.where((a) => ids.contains(a.id)).toList();
    } on DioException {
      final cached = await _localDatasource.getCachedArticles(
        key: 'articles_page_1',
      );
      return cached.where((a) => ids.contains(a.id)).toList();
    }
  }
}
