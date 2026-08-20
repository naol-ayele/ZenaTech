import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techpulse/presentation/providers/theme_provider.dart';

void main() {
  group('ThemeModeNotifier', () {
    test('starts in light mode', () {
      final notifier = ThemeModeNotifier();

      expect(notifier.state, ThemeMode.light);
    });

    test('setThemeMode changes mode', () {
      final notifier = ThemeModeNotifier();

      notifier.setThemeMode(ThemeMode.dark);

      expect(notifier.state, ThemeMode.dark);
    });

    test('toggleTheme switches light to dark', () {
      final notifier = ThemeModeNotifier();

      notifier.toggleTheme();

      expect(notifier.state, ThemeMode.dark);
    });

    test('toggleTheme switches dark to light', () {
      final notifier = ThemeModeNotifier()..setThemeMode(ThemeMode.dark);

      notifier.toggleTheme();

      expect(notifier.state, ThemeMode.light);
    });
  });

  group('themeModeProvider', () {
    test('provides a working notifier', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(themeModeProvider.notifier);

      notifier.toggleTheme();

      expect(container.read(themeModeProvider), ThemeMode.dark);
    });
  });
}
