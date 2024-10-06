import 'package:flutter/material.dart';
import 'package:my_recipe_flutter/controllers/local_storage/local_storage_controller.dart';
import 'package:my_recipe_flutter/controllers/navigations_helpers.dart';
import 'package:my_recipe_flutter/enums/recipe_category_enum.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final LocalStorageController localStorageController =
      LocalStorageController();
  ValueNotifier<List<String>> valueNotifierCategory =
      ValueNotifier<List<String>>([]);

  @override
  void initState() {
    getSavedFilter();
    super.initState();
  }

  Future<void> getSavedFilter() async {
    final savedFilter = await localStorageController.getSavedFilter();
    valueNotifierCategory.value = savedFilter;
  }

  bool? getSelectAllValue(List<String> selectedRecipe) {
    if (selectedRecipe.length <
            RecipeCategoryExtension.getDisplayNames().length &&
        selectedRecipe.isNotEmpty) {
      return null;
    }
    if (selectedRecipe.isEmpty) {
      return false;
    }

    return selectedRecipe.length ==
        RecipeCategoryExtension.getDisplayNames().length;
  }

  bool isEnableApplyButton(List<String> selectedRecipe) {
    if (getSelectAllValue(selectedRecipe) == null ||
        getSelectAllValue(selectedRecipe)!) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter page"),
      ),
      body: ValueListenableBuilder<List<String>>(
          valueListenable: valueNotifierCategory,
          builder: (_, selectedRecipe, __) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CheckboxListTile(
                    tristate: true,
                    title: const Text("Select All"),
                    value: getSelectAllValue(selectedRecipe),
                    onChanged: (isSelectAll) {
                      if (isSelectAll != null && isSelectAll) {
                        valueNotifierCategory
                            .value = List.from(valueNotifierCategory.value)
                          ..clear()
                          ..addAll(RecipeCategoryExtension.getDisplayNames());
                      } else {
                        valueNotifierCategory.value =
                            List.from(valueNotifierCategory.value)..clear();
                      }
                    }),
                Expanded(
                  child: ListView.builder(
                      itemCount:
                          RecipeCategoryExtension.getDisplayNames().length,
                      itemBuilder: (_, index) {
                        return CheckboxListTile(
                            title: Text(
                                RecipeCategoryEnum.values[index].displayName),
                            value: selectedRecipe.contains(
                                RecipeCategoryEnum.values[index].displayName),
                            onChanged: (isSelected) {
                              if (selectedRecipe.contains(RecipeCategoryEnum
                                  .values[index].displayName)) {
                                valueNotifierCategory.value =
                                    List.from(valueNotifierCategory.value)
                                      ..remove(RecipeCategoryEnum
                                          .values[index].displayName);
                              } else {
                                valueNotifierCategory.value =
                                    List.from(valueNotifierCategory.value)
                                      ..add(RecipeCategoryEnum
                                          .values[index].displayName);
                              }

                              print(
                                  RecipeCategoryEnum.values[index].displayName);
                              print(selectedRecipe);
                            });
                      }),
                ),
                const Spacer(),
                Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isEnableApplyButton(selectedRecipe)
                          ? () async {
                              await localStorageController
                                  .saveFilter(selectedRecipe);
                              if (context.mounted) {
                                NavigationHelpers.navigateToMainPage(context);
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      child: const Text(
                        "Apply",
                        style: TextStyle(color: Colors.white),
                      ),
                    ))
              ],
            );
          }),
    );
  }
}
