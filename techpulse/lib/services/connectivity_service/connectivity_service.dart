import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

enum NetworkStatus { online, offline }

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();

  NetworkStatus _currentStatus = NetworkStatus.online;
  NetworkStatus get currentStatus => _currentStatus;

  final _statusController = StreamController<NetworkStatus>.broadcast();
  Stream<NetworkStatus> get status {
    return _statusController.stream;
  }

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;

    debugPrint('ConnectivityService: Initializing...');

    final result = await _connectivity.checkConnectivity();
    _updateStatus(result);

    _connectivity.onConnectivityChanged.listen(_updateStatus);

    _isInitialized = true;
  }

  void _updateStatus(ConnectivityResult result) {
    final newStatus = result != ConnectivityResult.none
        ? NetworkStatus.online
        : NetworkStatus.offline;

    if (_currentStatus != newStatus) {
      _currentStatus = newStatus;
      _statusController.add(newStatus);
      debugPrint('ConnectivityService: Status changed to $newStatus');
    }
  }

  Future<bool> isOnline() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  void dispose() {
    _statusController.close();
  }
}

final connectivityServiceProvider = ConnectivityService();
