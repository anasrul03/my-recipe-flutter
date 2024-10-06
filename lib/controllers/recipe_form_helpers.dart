import 'package:flutter/material.dart';
import 'package:my_recipe_flutter/models/recipe_model.dart';
import 'package:my_recipe_flutter/views/add_recipe_form.dart';
import 'package:my_recipe_flutter/views/filter_page.dart';

class RecipeFormHelper {
  static void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void buildRecipeForm(
    BuildContext context, {
    RecipeModel? recipe,
  }) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
            height: getIdealSize(context).height,
            child: AddRecipePage(recipeModel: recipe));
      },
    );
  }

  Size getIdealSize(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final double showCaseWidth = screenWidth * 0.95;
    final double showCaseHeight = _getShowcaseHeight(screenHeight);

    return Size(showCaseWidth, showCaseHeight);
  }

  double _getShowcaseHeight(double screenHeight) {
    if (screenHeight < 700) {
      return screenHeight * 0.85;
    } else if (screenHeight < 800) {
      return screenHeight * 0.83;
    } else {
      return screenHeight * 0.90;
    }
  }

  void buildFilterPage(BuildContext context) => showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
              height: getIdealSize(context).height, child: const FilterPage());
        },
      );
}

extension StringExtensions on String {
  String toSnakeCase() {
    return replaceAll(' ', '_').toLowerCase();
  }
}
