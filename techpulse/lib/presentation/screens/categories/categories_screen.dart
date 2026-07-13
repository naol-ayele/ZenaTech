import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/category_providers.dart';
import '../../widgets/glass_category_tile.dart';
import '../../../core/theme/app_theme.dart';
import 'package:techpulse/l10n/app_localizations.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            backgroundColor: isDark
                ? AppColors.surfaceDark
                : AppColors.surfaceLight,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Text(
                AppLocalizations.of(context)!.screenCategories,
                style: TextStyle(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          categoriesAsync.when(
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => SliverFillRemaining(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        error.toString().contains('No internet connection')
                            ? Icons.wifi_off
                            : Icons.error_outline,
                        size: 60,
                        color:
                            error.toString().contains('No internet connection')
                            ? AppColors.vibrantCyan
                            : AppColors.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        error.toString().contains('No internet connection')
                            ? AppLocalizations.of(context)!.errorOffline
                            : error.toString().contains('SocketException') ||
                                  error.toString().contains('DioException') ||
                                  error.toString().contains('Connection') ||
                                  error.toString().contains(
                                    'Connection refused',
                                  ) ||
                                  error.toString().contains(
                                    'Connection timed out',
                                  ) ||
                                  error.toString().contains('Failed')
                            ? AppLocalizations.of(context)!.errorServerUnavailable
                            : AppLocalizations.of(context)!.errorSomethingWrong,
                        style: TextStyle(
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString().contains('No internet connection')
                            ? AppLocalizations.of(context)!.errorOfflineSubtitle
                            : AppLocalizations.of(context)!.errorServerSubtitle,
                        style: TextStyle(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => ref.invalidate(categoriesProvider),
                        icon: const Icon(Icons.refresh),
                        label: Text(AppLocalizations.of(context)!.btnRetry),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            data: (categories) => SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.9,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final category = categories[index];
                  return GlassCategoryTile(
                    name: category.name,
                    icon: category.icon,
                    articleCount: category.articleCount,
                    onTap: () => context.push('/categories/${category.id}'),
                  );
                }, childCount: categories.length),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
