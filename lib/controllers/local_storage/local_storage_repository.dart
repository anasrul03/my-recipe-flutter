import 'package:supabase_flutter/supabase_flutter.dart';

abstract class LocalStorageRepository {
  Future<void> saveUser(User user);

  Future<String> getUser();

  Future<List<String>?> getSavedFilter();

  Future<void> saveFilter(List<String> filter);

  Future<void> clearOnLogout();
}
