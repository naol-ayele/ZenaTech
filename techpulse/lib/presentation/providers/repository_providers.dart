import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/dio_client.dart';
import '../../data/datasources/remote/article_remote_datasource.dart';
import '../../data/datasources/remote/category_remote_datasource.dart';
import '../../data/datasources/local/favorites_local_datasource.dart';
import '../../data/datasources/local/search_history_local_datasource.dart';
import '../../data/repositories/article_repository_impl.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../data/repositories/local_repository_impl.dart';
import '../../domain/repositories/article_repository.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/repositories/local_repository.dart';

final dioClientProvider = Provider<DioClient>((ref) => DioClient());

final articleRemoteDatasourceProvider = Provider<ArticleRemoteDatasource>((
  ref,
) {
  return ArticleRemoteDatasourceImpl(ref.watch(dioClientProvider));
});

final categoryRemoteDatasourceProvider = Provider<CategoryRemoteDatasource>((
  ref,
) {
  return CategoryRemoteDatasourceImpl(ref.watch(dioClientProvider));
});

final favoritesLocalDatasourceProvider = Provider<FavoritesLocalDatasource>((
  ref,
) {
  return FavoritesLocalDatasourceImpl();
});

final searchHistoryLocalDatasourceProvider =
    Provider<SearchHistoryLocalDatasource>((ref) {
      return SearchHistoryLocalDatasourceImpl();
    });

final articleRepositoryProvider = Provider<ArticleRepository>((ref) {
  return ArticleRepositoryImpl(
    ref.watch(articleRemoteDatasourceProvider),
  );
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepositoryImpl(ref.watch(categoryRemoteDatasourceProvider));
});

final localRepositoryProvider = Provider<LocalRepository>((ref) {
  return LocalRepositoryImpl(
    ref.watch(favoritesLocalDatasourceProvider),
    ref.watch(searchHistoryLocalDatasourceProvider),
  );
});
