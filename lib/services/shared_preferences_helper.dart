import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    if (_prefs != null) {
      return;
    }
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveCurrentBucketId(String bucketId) async {
    if (_prefs == null) {
      await init();
    }
    await _prefs!.setString('currentBucketId', bucketId);
  }

  Future<String?> loadCurrentBucketId() async {
    if (_prefs == null) {
      await init();
    }
    String? bucketId = _prefs!.getString('currentBucketId');
    return bucketId;
  }
}
