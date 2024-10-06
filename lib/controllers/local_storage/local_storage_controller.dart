import 'package:my_recipe_flutter/controllers/local_storage/local_storage_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageController extends LocalStorageRepository {
  final _categoryFilterKey = "category_filter";

  @override
  Future<List<String>> getSavedFilter() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_categoryFilterKey) ?? [];
  }

  @override
  Future<void> saveFilter(List<String> filter) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_categoryFilterKey, filter);
  }
}
