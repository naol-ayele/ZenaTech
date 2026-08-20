import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:techpulse/data/repositories/local_repository_impl.dart';
import 'package:techpulse/domain/entities/search_query.dart';
import 'package:techpulse/presentation/providers/repository_providers.dart';
import 'package:techpulse/presentation/providers/search_history_provider.dart';

class MockLocalRepository extends Mock implements LocalRepositoryImpl {}

void main() {
  late MockLocalRepository mockRepo;

  setUp(() {
    mockRepo = MockLocalRepository();
    registerFallbackValue(
      SearchQuery(query: 'q', timestamp: DateTime(2024)),
    );
  });

  ProviderContainer buildContainer() {
    return ProviderContainer(
      overrides: [localRepositoryProvider.overrideWithValue(mockRepo)],
    );
  }

  group('SearchHistoryNotifier', () {
    test('loads history on initialization', () async {
      when(() => mockRepo.getSearchHistory()).thenAnswer(
        (_) async => [
          SearchQuery(query: 'old', timestamp: DateTime(2024, 1, 1)),
          SearchQuery(query: 'new', timestamp: DateTime(2024, 1, 2)),
        ],
      );

      final container = buildContainer();
      addTearDown(container.dispose);

      final notifier = container.read(searchHistoryNotifierProvider.notifier);
      await notifier.loadHistory();

      final state = container.read(searchHistoryNotifierProvider);
      expect(state.value, hasLength(2));
      expect(state.value![0].query, 'new');
      verify(() => mockRepo.getSearchHistory()).called(2);
    });

    test('addQuery adds non-empty query and reloads', () async {
      when(() => mockRepo.getSearchHistory()).thenAnswer((_) async => []);
      when(() => mockRepo.addSearchQuery(any())).thenAnswer((_) async {});

      final container = buildContainer();
      addTearDown(container.dispose);

      final notifier = container.read(searchHistoryNotifierProvider.notifier);
      await notifier.addQuery('  flutter  ');

      verify(
        () => mockRepo.addSearchQuery(
          any(that: isA<SearchQuery>()),
        ),
      ).called(1);
    });

    test('addQuery ignores empty and whitespace queries', () async {
      when(() => mockRepo.getSearchHistory()).thenAnswer((_) async => []);

      final container = buildContainer();
      addTearDown(container.dispose);

      final notifier = container.read(searchHistoryNotifierProvider.notifier);
      await notifier.addQuery('   ');

      verifyNever(() => mockRepo.addSearchQuery(any()));
    });

    test('clearHistory clears repository and reloads', () async {
      when(() => mockRepo.getSearchHistory()).thenAnswer((_) async => []);
      when(() => mockRepo.clearSearchHistory()).thenAnswer((_) async {});

      final container = buildContainer();
      addTearDown(container.dispose);

      final notifier = container.read(searchHistoryNotifierProvider.notifier);
      await notifier.clearHistory();

      verify(() => mockRepo.clearSearchHistory()).called(1);
    });

    test('loadHistory sets error state on failure', () async {
      when(() => mockRepo.getSearchHistory()).thenThrow(Exception('boom'));

      final container = buildContainer();
      addTearDown(container.dispose);

      final notifier = container.read(searchHistoryNotifierProvider.notifier);
      await notifier.loadHistory();

      expect(container.read(searchHistoryNotifierProvider), isA<AsyncError>());
    });
  });
}
