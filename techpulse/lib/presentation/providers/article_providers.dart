import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/article.dart';
import '../../services/connectivity_service/connectivity_service.dart';
import 'repository_providers.dart';

final isOnlineProvider = FutureProvider<bool>((ref) async {
  return connectivityServiceProvider.isOnline();
});

final articlesProvider = FutureProvider.family<List<Article>, int>((
  ref,
  page,
) async {
  final repository = ref.watch(articleRepositoryProvider);
  return repository.getArticles(page: page);
});

class ArticleDetailNotifier extends FamilyAsyncNotifier<Article, String> {
  @override
  Future<Article> build(String arg) async {
    final repository = ref.watch(articleRepositoryProvider);
    return repository.getArticleById(arg);
  }
}

final articleDetailProvider =
    AsyncNotifierProvider.family<ArticleDetailNotifier, Article, String>(
      ArticleDetailNotifier.new,
    );

final searchArticlesProvider = FutureProvider.family<List<Article>, String>((
  ref,
  query,
) async {
  final repository = ref.watch(articleRepositoryProvider);
  return repository.searchArticles(query);
});

final categoryArticlesProvider = FutureProvider.family<List<Article>, String>((
  ref,
  categoryId,
) async {
  final repository = ref.watch(articleRepositoryProvider);
  return repository.getArticlesByCategory(categoryId);
});

final trendingArticlesProvider = FutureProvider<List<Article>>((ref) async {
  final repository = ref.watch(articleRepositoryProvider);
  return repository.getTrendingArticles();
});
