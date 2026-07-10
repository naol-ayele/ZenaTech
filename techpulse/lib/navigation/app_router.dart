import 'package:go_router/go_router.dart';
import '../presentation/screens/main_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/explore/explore_screen.dart';
import '../presentation/screens/trending/trending_screen.dart';
import '../presentation/screens/favorites/favorites_screen.dart';
import '../presentation/screens/settings/settings_screen.dart';
import '../presentation/screens/article_detail/article_detail_screen.dart';
import '../presentation/screens/search/search_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainScreen(child: child),
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/trending',
          builder: (context, state) => const TrendingScreen(),
        ),
        GoRoute(
          path: '/explore',
          builder: (context, state) => const ExploreScreen(),
        ),
        GoRoute(
          path: '/favorites',
          builder: (context, state) => const FavoritesScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => const SearchScreen(),
        ),
        GoRoute(
          path: '/article/:id',
          builder: (context, state) =>
              ArticleDetailScreen(articleId: state.pathParameters['id']!),
        ),
      ],
    ),
  ],
);
