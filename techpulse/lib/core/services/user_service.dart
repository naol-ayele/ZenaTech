import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/api_constants.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  static const String _anonymousIdKey = 'anonymous_id';
  String? _anonymousId;

  String? get anonymousId => _anonymousId;

  Future<void> initialize() async {
    final box = await Hive.openBox(AppConstants.settingsBox);
    _anonymousId = box.get(_anonymousIdKey);

    if (_anonymousId == null || _anonymousId!.isEmpty) {
      _anonymousId = _generateUuid();
      await box.put(_anonymousIdKey, _anonymousId);
      debugPrint('UserService: Generated new anonymous_id: $_anonymousId');
    } else {
      debugPrint('UserService: Loaded existing anonymous_id: $_anonymousId');
    }
  }

  String _generateUuid() {
    final now = DateTime.now();
    final random = now.microsecondsSinceEpoch.toString();
    final hash = random.hashCode.abs().toRadixString(36).padLeft(8, '0');
    final uuid = 'anony_${hash}_${now.millisecondsSinceEpoch}';
    return uuid;
  }

  Future<void> trackCategoryInterest(String categoryId) async {
    if (_anonymousId == null) {
      debugPrint('UserService: anonymous_id not initialized');
      return;
    }

    try {
      final dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: const Duration(
            milliseconds: ApiConstants.connectionTimeout,
          ),
          receiveTimeout: const Duration(
            milliseconds: ApiConstants.receiveTimeout,
          ),
        ),
      );

      await dio.post(
        '/users/track-interest',
        data: {'anonymous_id': _anonymousId, 'category_id': categoryId},
      );

      debugPrint('UserService: Tracked interest for category: $categoryId');
    } catch (e) {
      debugPrint('UserService: Failed to track interest - $e');
    }
  }
}

final userService = UserService();
