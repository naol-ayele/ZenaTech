import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';

class SliverErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  final bool isDark;

  const SliverErrorWidget({
    super.key,
    required this.error,
    required this.onRetry,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isOffline = error.contains('No internet connection');
    final isServerError =
        !isOffline &&
        (error.contains('SocketException') ||
            error.contains('DioException') ||
            error.contains('Connection') ||
            error.contains('Connection refused') ||
            error.contains('Connection timed out') ||
            error.contains('Failed'));

    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isOffline ? Icons.wifi_off : Icons.error_outline,
                size: 60,
                color: isOffline ? AppColors.vibrantCyan : AppColors.error,
              ),
              const SizedBox(height: 16),
              Text(
                isOffline
                    ? l10n.errorOffline
                    : (isServerError
                          ? l10n.errorServerUnavailable
                          : l10n.errorSomethingWrong),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isOffline
                    ? l10n.errorOfflineSubtitle
                    : l10n.errorServerSubtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () async {
                  onRetry();
                  await Future.delayed(const Duration(milliseconds: 100));
                },
                icon: const Icon(Icons.refresh),
                label: Text(l10n.btnRetry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NetworkErrorRetryWidget extends StatelessWidget {
  final VoidCallback onRetry;
  final bool isDark;
  final String? message;
  final String? subtitle;

  const NetworkErrorRetryWidget({
    super.key,
    required this.onRetry,
    required this.isDark,
    this.message,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 60, color: AppColors.vibrantCyan),
            const SizedBox(height: 16),
            Text(
              message ?? l10n.errorOffline,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle ?? l10n.errorOfflineSubtitle,
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.btnRetry),
            ),
          ],
        ),
      ),
    );
  }
}
