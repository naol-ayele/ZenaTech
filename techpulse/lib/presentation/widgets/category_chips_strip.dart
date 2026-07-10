import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/user_service.dart';

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
                isAll ? 'All' : _formatCategoryName(category),
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

  String _formatCategoryName(String id) {
    final names = {
      'programming': 'Programming',
      'mobile': 'Mobile',
      'ai': 'AI & ML',
      'security': 'Security',
      'cloud': 'Cloud',
      'web': 'Web Dev',
      'devops': 'DevOps',
      'data': 'Data',
      'tech': 'Technology',
      'sports': 'Sports',
      'business': 'Business',
      'entertainment': 'Entertainment',
    };
    return names[id] ?? id;
  }
}
