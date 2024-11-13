import 'package:flutter/material.dart';
import 'package:precise/core/theme/app_colors.dart';
import 'package:precise/core/utils/constants.dart';

class CategoryList extends StatefulWidget {
  final Function(String) onCategorySelected;
  final String selectedCategory;

  const CategoryList({
    super.key,
    required this.onCategorySelected,
    required this.selectedCategory,
  });

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  Color getUnselectedLabelColor() {
    final theme = Theme.of(context);

    if (theme.brightness == Brightness.light) {
      // Light mode
      return AppColors.lightOnSurface;
    } else if (theme.brightness == Brightness.dark) {
      // Dark mode
      return AppColors.darkOnSurface;
    } else {
      // System mode: determine based on system brightness
      final isSystemDark =
          MediaQuery.of(context).platformBrightness == Brightness.dark;
      return isSystemDark ? AppColors.darkOnSurface : AppColors.lightOnSurface;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.only(left: 15),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: Constants.categories.length,
        itemBuilder: (context, index) {
          final category = Constants.categories[index];
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              showCheckmark: false,
              selectedColor: Theme.of(context).colorScheme.primary,
              label: Text(
                Constants.capitalize(category),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: widget.selectedCategory == category
                          ? AppColors.darkOnSurface
                          : getUnselectedLabelColor(),
                    ),
              ),
              selected: widget.selectedCategory == category,
              onSelected: (selected) {
                if (selected) {
                  widget.onCategorySelected(category);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
