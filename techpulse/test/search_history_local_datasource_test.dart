import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:techpulse/core/constants/api_constants.dart';
import 'package:techpulse/data/datasources/local/search_history_local_datasource.dart';
import 'package:techpulse/data/models/search_query_model.dart';

void main() {
  late Directory tempDir;
  late SearchHistoryLocalDatasourceImpl datasource;

  SearchQueryModel query(
    String text, {
    DateTime? timestamp,
  }) {
    return SearchQueryModel(
      query: text,
      timestamp: timestamp ?? DateTime(2024, 1, 1),
    );
  }

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('search_history_test');
    Hive.init(tempDir.path);
    datasource = SearchHistoryLocalDatasourceImpl();
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  group('SearchHistoryLocalDatasource', () {
    test('returns empty history initially', () async {
      final history = await datasource.getSearchHistory();

      expect(history, isEmpty);
    });

    test('adds and retrieves a search query', () async {
      await datasource.addSearchQuery(query('flutter'));

      final history = await datasource.getSearchHistory();

      expect(history, hasLength(1));
      expect(history[0].query, 'flutter');
    });

    test('adds multiple search queries', () async {
      await datasource.addSearchQuery(query('flutter'));
      await datasource.addSearchQuery(query('riverpod'));
      await datasource.addSearchQuery(query('dart'));

      final history = await datasource.getSearchHistory();

      expect(history, hasLength(3));
    });

    test('evicts oldest query beyond max limit', () async {
      for (var i = 0; i < AppConstants.maxSearchHistory + 2; i++) {
        await datasource.addSearchQuery(query('query-$i'));
      }

      final history = await datasource.getSearchHistory();

      expect(history, hasLength(AppConstants.maxSearchHistory));
      expect(history.any((q) => q.query == 'query-0'), isFalse);
    });

    test('preserves timestamp through round-trip', () async {
      final timestamp = DateTime(2024, 6, 15, 14, 30);
      await datasource.addSearchQuery(query('flutter', timestamp: timestamp));

      final history = await datasource.getSearchHistory();

      expect(history.single.timestamp, timestamp);
    });

    test('clears all history', () async {
      await datasource.addSearchQuery(query('flutter'));
      await datasource.addSearchQuery(query('dart'));

      await datasource.clearHistory();

      final history = await datasource.getSearchHistory();
      expect(history, isEmpty);
    });

    test('adds query with timestamp containing pipe character in query', () async {
      await datasource.addSearchQuery(query('query|with|pipes'));

      final history = await datasource.getSearchHistory();

      expect(history.single.query, 'query|with|pipes');
    });
  });
}
