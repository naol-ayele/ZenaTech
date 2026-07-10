import 'dart:convert';
import 'package:hive/hive.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/article_model.dart';

abstract class FavoritesLocalDatasource {
  Future<List<ArticleModel>> getFavorites();
  Future<void> addFavorite(ArticleModel article);
  Future<void> removeFavorite(String articleId);
  Future<bool> isFavorite(String articleId);
}

class FavoritesLocalDatasourceImpl implements FavoritesLocalDatasource {
  Box<String>? _box;

  Future<Box<String>> get box async {
    _box ??= await Hive.openBox<String>(AppConstants.favoritesBox);
    return _box!;
  }

  @override
  Future<List<ArticleModel>> getFavorites() async {
    try {
      final favBox = await box;
      return favBox.values
          .map((jsonString) => ArticleModel.fromJsonString(jsonString))
          .toList();
    } catch (e) {
      throw const CacheException('Failed to get favorites');
    }
  }

  @override
  Future<void> addFavorite(ArticleModel article) async {
    try {
      final favBox = await box;
      await favBox.put(article.id, article.toJsonString());
    } catch (e) {
      throw const CacheException('Failed to add favorite');
    }
  }

  @override
  Future<void> removeFavorite(String articleId) async {
    try {
      final favBox = await box;
      await favBox.delete(articleId);
    } catch (e) {
      throw const CacheException('Failed to remove favorite');
    }
  }

  @override
  Future<bool> isFavorite(String articleId) async {
    try {
      final favBox = await box;
      return favBox.containsKey(articleId);
    } catch (e) {
      return false;
    }
  }
}
