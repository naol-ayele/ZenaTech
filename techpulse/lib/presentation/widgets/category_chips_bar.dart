import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/user_service.dart';
import '../../l10n/app_localizations.dart';

class CategoryChipsBar extends ConsumerWidget {
  final List<String> categories;
  final String? selectedCategory;
  final Function(String) onCategorySelected;
  final ScrollController? scrollController;

  const CategoryChipsBar({
    super.key,
    required this.categories,
    this.selectedCategory,
    required this.onCategorySelected,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 50,
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: FilterChip(
              label: Text(
                _formatCategoryName(category, context),
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : (isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 13,
                ),
              ),
              selected: isSelected,
              onSelected: (_) {
                userService.trackCategoryInterest(category);
                onCategorySelected(category);
              },
              backgroundColor: isDark ? AppColors.cardDark : Colors.white,
              selectedColor: AppColors.vibrantCyan,
              checkmarkColor: Colors.white,
              showCheckmark: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? AppColors.vibrantCyan
                      : (isDark
                            ? AppColors.dividerDark
                            : AppColors.dividerLight),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          );
        },
      ),
    );
  }

  String _formatCategoryName(String id, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (id) {
      case 'programming': return l10n.categoryProgramming;
      case 'mobile': return l10n.categoryMobile;
      case 'ai': return l10n.categoryAiMl;
      case 'security': return l10n.categorySecurity;
      case 'cloud': return l10n.categoryCloud;
      case 'web': return l10n.categoryWebDev;
      case 'devops': return l10n.categoryDevOps;
      case 'data': return l10n.categoryData;
      default: return id;
    }
  }
}
