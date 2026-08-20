import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:techpulse/data/repositories/local_repository_impl.dart';
import 'package:techpulse/domain/entities/article.dart';
import 'package:techpulse/presentation/providers/favorites_providers.dart';
import 'package:techpulse/presentation/providers/repository_providers.dart';

class MockLocalRepository extends Mock implements LocalRepositoryImpl {}

void main() {
  late MockLocalRepository mockRepo;

  Article article({String id = '1', String title = 'Test'}) {
    return Article(
      id: id,
      title: title,
      category: 'tech',
      content: 'Content',
      thumbnailUrl: '',
      publishedDate: DateTime(2024, 1, 1),
      views: 1,
      isPremium: false,
    );
  }

  setUp(() {
    mockRepo = MockLocalRepository();
    registerFallbackValue(
      Article(
        id: '1',
        title: 'T',
        category: 'c',
        content: 'c',
        thumbnailUrl: '',
        publishedDate: DateTime(2024),
        views: 0,
        isPremium: false,
      ),
    );
  });

  ProviderContainer buildContainer() {
    return ProviderContainer(
      overrides: [localRepositoryProvider.overrideWithValue(mockRepo)],
    );
  }

  group('FavoritesNotifier', () {
    test('loads favorites on initialization', () async {
      when(() => mockRepo.getFavorites()).thenAnswer(
        (_) async => [article()],
      );

      final container = buildContainer();
      addTearDown(container.dispose);

      final notifier = container.read(favoritesNotifierProvider.notifier);
      await notifier.loadFavorites();

      final state = container.read(favoritesNotifierProvider);
      expect(state.value, hasLength(1));
      expect(state.value![0].id, '1');
      verify(() => mockRepo.getFavorites()).called(2);
    });

    test('loadFavorites updates state with error on failure', () async {
      when(() => mockRepo.getFavorites()).thenThrow(Exception('boom'));

      final container = buildContainer();
      addTearDown(container.dispose);

      final notifier = container.read(favoritesNotifierProvider.notifier);
      await notifier.loadFavorites();

      expect(container.read(favoritesNotifierProvider), isA<AsyncError>());
    });

    test('toggleFavorite adds favorite when not favorited', () async {
      when(() => mockRepo.getFavorites()).thenAnswer((_) async => []);
      when(() => mockRepo.isFavorite('1')).thenAnswer((_) async => false);
      when(() => mockRepo.addFavorite(any())).thenAnswer((_) async {});

      final container = buildContainer();
      addTearDown(container.dispose);

      final notifier = container.read(favoritesNotifierProvider.notifier);
      await notifier.toggleFavorite(article());

      verify(() => mockRepo.addFavorite(any())).called(1);
      verifyNever(() => mockRepo.removeFavorite(any()));
    });

    test('toggleFavorite removes favorite when already favorited', () async {
      when(() => mockRepo.getFavorites()).thenAnswer((_) async => []);
      when(() => mockRepo.isFavorite('1')).thenAnswer((_) async => true);
      when(() => mockRepo.removeFavorite('1')).thenAnswer((_) async {});

      final container = buildContainer();
      addTearDown(container.dispose);

      final notifier = container.read(favoritesNotifierProvider.notifier);
      await notifier.toggleFavorite(article());

      verify(() => mockRepo.removeFavorite('1')).called(1);
      verifyNever(() => mockRepo.addFavorite(any()));
    });

    test('toggleFavorite reloads favorites after toggling', () async {
      when(() => mockRepo.getFavorites()).thenAnswer(
        (_) async => [article()],
      );
      when(() => mockRepo.isFavorite('1')).thenAnswer((_) async => false);
      when(() => mockRepo.addFavorite(any())).thenAnswer((_) async {});

      final container = buildContainer();
      addTearDown(container.dispose);

      final notifier = container.read(favoritesNotifierProvider.notifier);
      await notifier.toggleFavorite(article());

      final state = container.read(favoritesNotifierProvider);
      expect(state.value, hasLength(1));
    });
  });
}
