import 'package:my_recipe_flutter/controllers/local_storage/local_storage_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LocalStorageController implements LocalStorageRepository {
  final _categoryFilterKey = "category_filter";
  final _userId = "user_id";

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

  @override
  Future<String> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userId) ?? "";
  }

  @override
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userId, user.id);
  }

  @override
  Future<void> clearOnLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
