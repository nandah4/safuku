import 'package:safuku/core/utils/logger.dart';
import 'package:safuku/domain/repositories/personalization_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalizationImpl implements PersonalizationRepository {
  late final SharedPreferencesWithCache _sharedPreferences;
  // Field storage key
  static const String languageKey = 'language';
  static const String currencyKey = 'currency';

  // The key will be chaced
  static final Set<String> _keys = {languageKey, currencyKey};

  PersonalizationImpl._();

  static Future<PersonalizationImpl> create() async {
    final instance = PersonalizationImpl._();
    await instance.init();
    return instance;
  }

  Future<void> init() async {
    _sharedPreferences = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(allowList: _keys),
    );
    AppLogger.i("SharedPrefSetup initialized");
  }

  @override
  Future<void> setString({required String key, required String value}) async {
    await _sharedPreferences.setString(key, value);
  }

  @override
  String? getString({required String key}) {
    return _sharedPreferences.getString(key);
  }

  @override
  Future<void> clear() async {
    AppLogger.i("Clearing all data");
    await _sharedPreferences.clear();
  }
}
