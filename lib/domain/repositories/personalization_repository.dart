abstract class PersonalizationRepository {
  Future<void> setString({required String key, required String value});
  String? getString({required String key});
  Future<void> clear();
}
