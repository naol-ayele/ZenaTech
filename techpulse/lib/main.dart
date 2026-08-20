import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/ads/ad_manager.dart';
import 'core/services/user_service.dart';
import 'services/connectivity_service/connectivity_service.dart';
import 'services/notification_service/notification_service.dart';
import 'navigation/app_router.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/providers/locale_provider.dart';
import 'presentation/providers/article_providers.dart';
import 'l10n/app_localizations.dart';

String? _pendingNotificationArticleId;

const String _sentryDsn = String.fromEnvironment('SENTRY_DSN', defaultValue: '');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  if (_sentryDsn.isNotEmpty) {
    await SentryFlutter.init(
      (options) {
        options.dsn = _sentryDsn;
        options.tracesSampleRate = 0.2;
      },
      appRunner: _runApp,
    );
  } else {
    await _runApp();
  }
}

Future<void> _runApp() async {
  try {
    await adManager.initialize();
  } catch (e) {
    debugPrint('main: adManager.initialize() failed - $e');
  }
  try {
    await userService.initialize();
  } catch (e) {
    debugPrint('main: userService.initialize() failed - $e');
  }
  try {
    await notificationServiceProvider.initialize();
  } catch (e) {
    debugPrint('main: notificationServiceProvider.initialize() failed - $e');
  }
  final initialMessage =
      await notificationServiceProvider.getInitialMessage();
  _pendingNotificationArticleId = initialMessage?.data['articleId'];
  try {
    await connectivityServiceProvider.initialize();
  } catch (e) {
    debugPrint('main: connectivityServiceProvider.initialize() failed - $e');
  }

  runApp(const ProviderScope(child: TechPulseApp()));
}

class TechPulseApp extends ConsumerStatefulWidget {
  const TechPulseApp({super.key});

  @override
  ConsumerState<TechPulseApp> createState() => _TechPulseAppState();
}

class _TechPulseAppState extends ConsumerState<TechPulseApp> {
  StreamSubscription<NetworkStatus>? _connectivitySubscription;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  NetworkStatus _lastKnownStatus = NetworkStatus.online;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pendingNotificationArticleId != null) {
        context.push('/article/$_pendingNotificationArticleId');
        _pendingNotificationArticleId = null;
      }
    });
    notificationServiceProvider.onMessageOpenedApp.listen((message) {
      final id = message.data['articleId'];
      if (id != null) {
        appRouter.go('/article/$id');
      }
    });
    _setupConnectivityListener();
  }

  void _setupConnectivityListener() {
    _lastKnownStatus = connectivityServiceProvider.currentStatus;

    _connectivitySubscription = connectivityServiceProvider.status.listen((
      status,
    ) {
      debugPrint(
        'ConnectivityService: Status received: $status (last: $_lastKnownStatus)',
      );

      if (_lastKnownStatus == NetworkStatus.offline &&
          status == NetworkStatus.online) {
        _onBackOnline();
      }

      _lastKnownStatus = status;
    });
  }

  void _onBackOnline() {
    debugPrint('Connectivity: Back online! Refreshing content...');

    ref.invalidate(trendingArticlesProvider);
    ref.invalidate(articlesProvider(1));
    ref.invalidate(categoryArticlesProvider(''));
    ref.invalidate(isOnlineProvider);

    ref.read(trendingArticlesProvider);
    ref.read(articlesProvider(1));

    final messenger = _scaffoldMessengerKey.currentState;
    if (messenger != null) {
      messenger.showSnackBar(
        SnackBar(
          content: const Text('Connection restored. Refreshing content...'),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      scaffoldMessengerKey: _scaffoldMessengerKey,
      title: 'ZenaTech',
      debugShowCheckedModeBanner: false,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.lightTheme(locale),
      darkTheme: AppTheme.darkTheme(locale),
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
