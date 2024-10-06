abstract class LocalStorageRepository {
  Future<List<String>?> getSavedFilter();

  Future<void> saveFilter(List<String> filter);
}
