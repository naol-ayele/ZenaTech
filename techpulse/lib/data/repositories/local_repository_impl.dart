import '../../domain/entities/article.dart';
import '../../domain/entities/search_query.dart';
import '../../domain/repositories/local_repository.dart';
import '../datasources/local/favorites_local_datasource.dart';
import '../datasources/local/search_history_local_datasource.dart';
import '../models/article_model.dart';
import '../models/search_query_model.dart';

class LocalRepositoryImpl implements LocalRepository {
  final FavoritesLocalDatasource _favoritesDatasource;
  final SearchHistoryLocalDatasource _searchHistoryDatasource;

  LocalRepositoryImpl(this._favoritesDatasource, this._searchHistoryDatasource);

  @override
  Future<List<Article>> getFavorites() async {
    return await _favoritesDatasource.getFavorites();
  }

  @override
  Future<void> addFavorite(Article article) async {
    final model = ArticleModel(
      id: article.id,
      title: article.title,
      category: article.category,
      content: article.content,
      thumbnailUrl: article.thumbnailUrl,
      publishedDate: article.publishedDate,
      views: article.views,
      isPremium: article.isPremium,
      affiliateLinks: article.affiliateLinks,
    );
    await _favoritesDatasource.addFavorite(model);
  }

  @override
  Future<void> removeFavorite(String articleId) async {
    await _favoritesDatasource.removeFavorite(articleId);
  }

  @override
  Future<bool> isFavorite(String articleId) async {
    return await _favoritesDatasource.isFavorite(articleId);
  }

  @override
  Future<List<SearchQuery>> getSearchHistory() async {
    return await _searchHistoryDatasource.getSearchHistory();
  }

  @override
  Future<void> addSearchQuery(SearchQuery query) async {
    final model = SearchQueryModel(
      query: query.query,
      timestamp: query.timestamp,
    );
    await _searchHistoryDatasource.addSearchQuery(model);
  }

  @override
  Future<void> clearSearchHistory() async {
    await _searchHistoryDatasource.clearHistory();
  }
}
