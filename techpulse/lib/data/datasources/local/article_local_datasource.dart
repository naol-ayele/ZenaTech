import 'package:hive/hive.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/article_model.dart';

abstract class ArticleLocalDatasource {
  Future<void> cacheArticles(List<ArticleModel> articles, {String? key});
  Future<List<ArticleModel>> getCachedArticles({String? key});
  Future<void> cacheArticle(ArticleModel article);
  Future<ArticleModel?> getCachedArticle(String id);
  Future<void> clearCache();
}

class ArticleLocalDatasourceImpl implements ArticleLocalDatasource {
  static const String _boxName = 'article_cache';
  Box<String>? _box;

  Future<Box<String>> get box async {
    _box ??= await Hive.openBox<String>(_boxName);
    return _box!;
  }

  @override
  Future<void> cacheArticles(List<ArticleModel> articles, {String? key}) async {
    try {
      final cacheBox = await box;
      final cacheKey = key ?? 'articles_page_1';
      final jsonString = articles.map((a) => a.toJsonString()).toList();
      await cacheBox.put(cacheKey, jsonString.join('|||'));
    } catch (e) {
      throw CacheException('Failed to cache articles');
    }
  }

  @override
  Future<List<ArticleModel>> getCachedArticles({String? key}) async {
    try {
      final cacheBox = await box;
      final cacheKey = key ?? 'articles_page_1';
      final cached = cacheBox.get(cacheKey);
      if (cached == null || cached.isEmpty) return [];

      return cached
          .split('|||')
          .map((s) => ArticleModel.fromJsonString(s))
          .toList();
    } catch (e) {
      throw CacheException('Failed to get cached articles');
    }
  }

  @override
  Future<void> cacheArticle(ArticleModel article) async {
    try {
      final cacheBox = await box;
      await cacheBox.put('article_${article.id}', article.toJsonString());
    } catch (e) {
      throw CacheException('Failed to cache article');
    }
  }

  @override
  Future<ArticleModel?> getCachedArticle(String id) async {
    try {
      final cacheBox = await box;
      final cached = cacheBox.get('article_$id');
      if (cached == null || cached.isEmpty) return null;
      return ArticleModel.fromJsonString(cached);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final cacheBox = await box;
      await cacheBox.clear();
    } catch (e) {
      throw CacheException('Failed to clear cache');
    }
  }
}
