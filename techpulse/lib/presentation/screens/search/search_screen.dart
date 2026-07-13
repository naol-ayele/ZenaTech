import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/article_providers.dart';
import '../../providers/search_history_provider.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/error_widget.dart';
import '../../../core/theme/app_theme.dart';
import 'package:techpulse/l10n/app_localizations.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.trim().isNotEmpty) {
      ref.read(searchHistoryNotifierProvider.notifier).addQuery(query);
    }
    setState(() {
      _query = query;
    });
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final searchResults = _query.isNotEmpty
        ? ref.watch(searchArticlesProvider(_query))
        : null;
    final searchHistory = ref.watch(searchHistoryNotifierProvider);

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
                AppLocalizations.of(context)!.screenSearch,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.2 : 0.06,
                      ),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.searchHintArticles,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _query = '';
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                  onChanged: (value) => setState(() {}),
                  onSubmitted: _performSearch,
                  textInputAction: TextInputAction.search,
                ),
              ),
            ),
          ),
          if (_query.isEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.sectionRecentSearches,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    searchHistory.maybeWhen(
                      data: (history) => history.isNotEmpty
                          ? TextButton(
                              onPressed: () => ref
                                  .read(searchHistoryNotifierProvider.notifier)
                                  .clearHistory(),
                              child: Text(AppLocalizations.of(context)!.btnClearAll),
                            )
                          : const SizedBox.shrink(),
                      orElse: () => const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
            searchHistory.when(
              loading: () => const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) =>
                  SliverToBoxAdapter(child: Center(child: Text('Error: $e'))),
              data: (history) => history.isEmpty
                  ? SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.emptyNoSearches,
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final item = history[index];
                        return ListTile(
                          leading: const Icon(Icons.history),
                          title: Text(item.query),
                          trailing: const Icon(Icons.north_west, size: 18),
                          onTap: () {
                            _searchController.text = item.query;
                            _performSearch(item.query);
                          },
                        );
                      }, childCount: history.length),
                    ),
            ),
          ] else if (searchResults != null) ...[
            searchResults.when(
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => SliverFillRemaining(
                child: ErrorDisplay(
                  message: AppLocalizations.of(context)!.errorSearchFailed,
                  onRetry: () => ref.invalidate(searchArticlesProvider(_query)),
                ),
              ),
              data: (articles) => articles.isEmpty
                  ? SliverFillRemaining(child: EmptyStateWidget.search(context))
                  : SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final article = articles[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.cardDark : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            onTap: () => context.push('/article/${article.id}'),
                            title: Text(
                              article.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            subtitle: Text(article.category),
                            trailing: Text(AppLocalizations.of(context)!.labelViews(article.views)),
                          ),
                        );
                      }, childCount: articles.length),
                    ),
            ),
          ],
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
