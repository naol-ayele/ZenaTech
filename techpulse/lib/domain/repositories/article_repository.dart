import '../entities/article.dart';

abstract class ArticleRepository {
  Future<List<Article>> getArticles({int page = 1, int limit = 20});
  Future<Article> getArticleById(String id);
  Future<List<Article>> searchArticles(
    String query, {
    int page = 1,
    int limit = 20,
  });
  Future<List<Article>> getArticlesByCategory(
    String categoryId, {
    int page = 1,
    int limit = 20,
  });
  Future<List<Article>> getTrendingArticles();
  Future<List<Article>> getFavoriteArticles(List<String> ids);
}
