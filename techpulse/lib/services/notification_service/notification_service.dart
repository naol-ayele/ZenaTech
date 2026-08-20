import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../../l10n/app_localizations_en.dart';
import '../../navigation/app_router.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('NotificationService: Failed to initialize Firebase in background - $e');
    return;
  }
  debugPrint(
    'NotificationService: Background message: ${message.messageId}',
  );
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  FirebaseMessaging? _messaging;
  final DioClient _dioClient = DioClient();
  bool _isInitialized = false;

  Function(Map<String, dynamic>)? _onMessageHandler;

  Stream<RemoteMessage> get onMessage => FirebaseMessaging.onMessage;
  Stream<RemoteMessage> get onMessageOpenedApp =>
      FirebaseMessaging.onMessageOpenedApp;
  Future<RemoteMessage?> getInitialMessage() =>
      FirebaseMessaging.instance.getInitialMessage();

  Future<String?> getDeviceToken() async {
    try {
      return await _messaging?.getToken();
    } catch (e) {
      debugPrint('NotificationService: Failed to get FCM token - $e');
      return null;
    }
  }

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await Firebase.initializeApp();
    } catch (e) {
      debugPrint('NotificationService: Failed to initialize Firebase - $e');
      return;
    }
    _messaging = FirebaseMessaging.instance;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          try {
            final data = jsonDecode(response.payload!);
            final articleId = data['articleId'];
            if (articleId != null) {
              appRouter.go('/article/$articleId');
            }
          } catch (e) {
            debugPrint(
              'NotificationService: notification payload parse error - $e',
            );
          }
        }
      },
    );

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    await requestPermission();

    final token = await _messaging?.getToken();
    if (token != null) {
      debugPrint('NotificationService: FCM Token: $token');
      await registerDeviceToken(token);
    }

    _messaging?.onTokenRefresh.listen((newToken) {
      debugPrint('NotificationService: Token refreshed: $newToken');
      registerDeviceToken(newToken);
    });

    _isInitialized = true;
    debugPrint('NotificationService: Initialized successfully');
  }

  Future<bool> requestPermission() async {
    if (_messaging == null) return false;

    final settings = await _messaging!.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    final granted = settings.authorizationStatus ==
        AuthorizationStatus.authorized;
    debugPrint(
      'NotificationService: Permission status: ${settings.authorizationStatus}',
    );
    return granted;
  }

  Future<void> registerDeviceToken(String token) async {
    try {
      await _dioClient.post(
        ApiConstants.subscribeNotifications,
        data: {'deviceToken': token},
      );
      debugPrint('NotificationService: Token registered with backend');
    } catch (e) {
      debugPrint('NotificationService: Failed to register token - $e');
    }
  }

  Future<void> unregisterDeviceToken(String token) async {
    try {
      await _dioClient.post(
        ApiConstants.unsubscribeNotifications,
        data: {'deviceToken': token},
      );
      debugPrint('NotificationService: Token unregistered from backend');
    } catch (e) {
      debugPrint('NotificationService: Failed to unregister token - $e');
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint(
      'NotificationService: Foreground message: ${message.messageId}',
    );

    final notification = message.notification;
    if (notification != null) {
      showLocalNotification(
        title: notification.title ?? '',
        body: notification.body ?? '',
        payload: jsonEncode(message.data),
      );
    }

    _onMessageHandler?.call(message.data);
  }

  Future<void> subscribeToTopic(String topic) async {
    if (_messaging == null) return;
    await _messaging!.subscribeToTopic(topic);
    debugPrint('NotificationService: Subscribed to topic: $topic');
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    if (_messaging == null) return;
    await _messaging!.unsubscribeFromTopic(topic);
    debugPrint('NotificationService: Unsubscribed from topic: $topic');
  }

  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    final en = AppLocalizationsEn();
    final androidDetails = AndroidNotificationDetails(
      'techpulse_channel',
      en.channelName,
      channelDescription: en.channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const iosDetails = DarwinNotificationDetails();
    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: payload,
    );
  }

  void setMessageHandler(void Function(Map<String, dynamic>) handler) {
    _onMessageHandler = handler;
  }
}

final notificationServiceProvider = NotificationService();
