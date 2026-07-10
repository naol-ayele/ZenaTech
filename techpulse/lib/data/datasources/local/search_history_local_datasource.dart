import 'package:hive/hive.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/search_query_model.dart';

abstract class SearchHistoryLocalDatasource {
  Future<List<SearchQueryModel>> getSearchHistory();
  Future<void> addSearchQuery(SearchQueryModel query);
  Future<void> clearHistory();
}

class SearchHistoryLocalDatasourceImpl implements SearchHistoryLocalDatasource {
  Box<String>? _box;

  Future<Box<String>> get box async {
    _box ??= await Hive.openBox<String>(AppConstants.searchHistoryBox);
    return _box!;
  }

  @override
  Future<List<SearchQueryModel>> getSearchHistory() async {
    try {
      final historyBox = await box;
      return historyBox.values
          .map(
            (jsonString) => SearchQueryModel.fromJson({
              'query': jsonString.split('|')[0],
              'timestamp': jsonString.split('|')[1],
            }),
          )
          .toList();
    } catch (e) {
      throw const CacheException('Failed to get search history');
    }
  }

  @override
  Future<void> addSearchQuery(SearchQueryModel query) async {
    try {
      final historyBox = await box;
      final key = '${query.query}|${query.timestamp.toIso8601String()}';
      final queries = historyBox.values.toList();
      if (queries.length >= AppConstants.maxSearchHistory) {
        await historyBox.delete(queries.first);
      }
      await historyBox.add(key);
    } catch (e) {
      throw const CacheException('Failed to add search query');
    }
  }

  @override
  Future<void> clearHistory() async {
    try {
      final historyBox = await box;
      await historyBox.clear();
    } catch (e) {
      throw const CacheException('Failed to clear search history');
    }
  }
}
