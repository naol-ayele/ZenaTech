import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdSupportedContentNotifier extends StateNotifier<Set<String>> {
  AdSupportedContentNotifier() : super({});

  void unlockArticle(String articleId) {
    state = {...state, articleId};
  }

  bool isUnlocked(String articleId) {
    return state.contains(articleId);
  }

  void clearSession() {
    state = {};
  }
}

final adSupportedContentProvider =
    StateNotifierProvider<AdSupportedContentNotifier, Set<String>>((ref) {
      return AdSupportedContentNotifier();
    });

final isArticleUnlockedProvider = FutureProvider.family<bool, String>((
  ref,
  articleId,
) async {
  final unlockedIds = ref.watch(adSupportedContentProvider);
  return unlockedIds.contains(articleId);
});
