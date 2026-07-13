import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/api_constants.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en')) {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    try {
      final box = await Hive.openBox(AppConstants.settingsBox);
      final saved = box.get('locale', defaultValue: 'en');
      state = Locale(saved);
    } catch (_) {
      state = const Locale('en');
    }
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    try {
      final box = await Hive.openBox(AppConstants.settingsBox);
      await box.put('locale', locale.languageCode);
    } catch (_) {}
  }
}
