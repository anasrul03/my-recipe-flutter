enum RecipeCategoryEnum {
  appetizer,
  mainCourse,
  dessert,
  beverage,
  side,
}

extension RecipeCategoryExtension on RecipeCategoryEnum {
  String get displayName {
    switch (this) {
      case RecipeCategoryEnum.appetizer:
        return 'Appetizer';
      case RecipeCategoryEnum.mainCourse:
        return 'Main Course';
      case RecipeCategoryEnum.dessert:
        return 'Dessert';
      case RecipeCategoryEnum.beverage:
        return 'Beverage';
      case RecipeCategoryEnum.side:
        return 'Side';
    }
  }

  // Get a list of all enum values as strings
  static List<String> getDisplayNames() {
    return RecipeCategoryEnum.values
        .map((category) => category.displayName)
        .toList();
  }
}
