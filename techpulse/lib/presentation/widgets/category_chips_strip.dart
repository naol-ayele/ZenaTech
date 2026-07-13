import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/user_service.dart';
import '../../l10n/app_localizations.dart';

final selectedCategoryProvider = StateProvider<String?>((ref) => null);

class CategoryChipsStrip extends ConsumerWidget {
  final List<String> categories;
  final Function(String?) onCategorySelected;

  const CategoryChipsStrip({
    super.key,
    required this.categories,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;
          final isAll = category == 'all' || category == 'All';

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                isAll ? AppLocalizations.of(context)!.categoryAll : _formatCategoryName(category, context),
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
                final newCategory = isAll ? null : category;
                userService.trackCategoryInterest(category);
                ref.read(selectedCategoryProvider.notifier).state = newCategory;
                onCategorySelected(newCategory);
              },
              backgroundColor: isDark ? AppColors.cardDark : Colors.white,
              selectedColor: AppColors.primaryBlue,
              checkmarkColor: Colors.white,
              showCheckmark: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(
                  color: isSelected
                      ? AppColors.primaryBlue
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
      case 'tech': return l10n.categoryTechnology;
      case 'sports': return l10n.categorySports;
      case 'business': return l10n.categoryBusiness;
      case 'entertainment': return l10n.categoryEntertainment;
      default: return id;
    }
  }
}
