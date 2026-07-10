import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

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
                    ? "You're offline"
                    : (isServerError
                          ? 'Server unavailable'
                          : 'Something went wrong'),
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
                    ? 'Please check your connection and try again'
                    : 'Pull down to refresh',
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
                label: const Text('Retry'),
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
  final String message;
  final String subtitle;

  const NetworkErrorRetryWidget({
    super.key,
    required this.onRetry,
    required this.isDark,
    this.message = "You're offline",
    this.subtitle = 'Please check your connection and try again',
  });

  @override
  Widget build(BuildContext context) {
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
              message,
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
              subtitle,
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
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
