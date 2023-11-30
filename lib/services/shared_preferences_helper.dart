import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    if (_prefs != null) {
      return;
    }
    _prefs = await SharedPreferences.getInstance();
    print('SharedPreferencesHelper is initialized');
  }

  Future<void> saveCurrentBucketId(int bucketId) async {
    if (_prefs == null) {
      await init();
    }
    await _prefs!.setInt('currentBucketId', bucketId);
    print('saveCurrentBucketId: $bucketId');
  }

  Future<int?> loadCurrentBucketId() async {
    if (_prefs == null) {
      await init();
    }
    int? bucketId = _prefs!.getInt('currentBucketId');
    print('loadCurrentBucketId: $bucketId');
    return bucketId;
  }
}
