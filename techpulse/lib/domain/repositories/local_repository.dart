import '../entities/article.dart';
import '../entities/search_query.dart';

abstract class LocalRepository {
  Future<List<Article>> getFavorites();
  Future<void> addFavorite(Article article);
  Future<void> removeFavorite(String articleId);
  Future<bool> isFavorite(String articleId);
  Future<List<SearchQuery>> getSearchHistory();
  Future<void> addSearchQuery(SearchQuery query);
  Future<void> clearSearchHistory();
}
