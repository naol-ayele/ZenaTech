import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/article.dart';
import '../../domain/repositories/local_repository.dart';
import 'repository_providers.dart';

final favoritesProvider = FutureProvider<List<Article>>((ref) async {
  final repository = ref.watch(localRepositoryProvider);
  return repository.getFavorites();
});

final isFavoriteProvider = FutureProvider.family<bool, String>((
  ref,
  articleId,
) async {
  final repository = ref.watch(localRepositoryProvider);
  return repository.isFavorite(articleId);
});

class FavoritesNotifier extends StateNotifier<AsyncValue<List<Article>>> {
  final LocalRepository _repository;
  final Ref _ref;

  FavoritesNotifier(this._repository, this._ref)
    : super(const AsyncValue.loading()) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    state = const AsyncValue.loading();
    try {
      final favorites = await _repository.getFavorites();
      state = AsyncValue.data(favorites);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleFavorite(Article article) async {
    debugPrint('toggleFavorite: ${article.id}');
    try {
      final isFav = await _repository.isFavorite(article.id);
      debugPrint('isFav: $isFav');
      if (isFav) {
        await _repository.removeFavorite(article.id);
      } else {
        await _repository.addFavorite(article);
      }
      debugPrint('refresh favorites list');
      await loadFavorites();
      debugPrint('toggleFavorite complete');
    } catch (e, st) {
      debugPrint('toggleFavorite error: $e');
      state = AsyncValue.error(e, st);
    }
  }
}

final favoritesNotifierProvider =
    StateNotifierProvider<FavoritesNotifier, AsyncValue<List<Article>>>((ref) {
      return FavoritesNotifier(ref.watch(localRepositoryProvider), ref);
    });
