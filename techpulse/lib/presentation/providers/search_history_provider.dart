import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/local_repository.dart';
import '../../domain/entities/search_query.dart';
import 'repository_providers.dart';

final searchHistoryProvider = FutureProvider<List<SearchQuery>>((ref) async {
  final repository = ref.watch(localRepositoryProvider);
  return repository.getSearchHistory();
});

class SearchHistoryNotifier
    extends StateNotifier<AsyncValue<List<SearchQuery>>> {
  final LocalRepository _repository;

  SearchHistoryNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    state = const AsyncValue.loading();
    try {
      final history = await _repository.getSearchHistory();
      state = AsyncValue.data(history.reversed.toList());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addQuery(String query) async {
    if (query.trim().isEmpty) return;
    await _repository.addSearchQuery(
      SearchQuery(query: query.trim(), timestamp: DateTime.now()),
    );
    await loadHistory();
  }

  Future<void> clearHistory() async {
    await _repository.clearSearchHistory();
    await loadHistory();
  }
}

final searchHistoryNotifierProvider =
    StateNotifierProvider<SearchHistoryNotifier, AsyncValue<List<SearchQuery>>>(
      (ref) {
        return SearchHistoryNotifier(ref.watch(localRepositoryProvider));
      },
    );
