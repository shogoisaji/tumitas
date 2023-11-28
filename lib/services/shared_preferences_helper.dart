import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveCurrentBucketId(int bucketId) async {
    if (_prefs == null) {
      print('SharedPreferencesHelper is not initialized');
      return;
    }
    await _prefs!.setInt('currentBucketId', bucketId);
    print('saveCurrentBucketId: $bucketId');
  }

  Future<int?> loadCurrentBucketId() async {
    if (_prefs == null) {
      print('SharedPreferencesHelper is not initialized');
      return null;
    }
    int? bucketId = _prefs!.getInt('bucketId');
    print('loadCurrentBucketId: $bucketId');
    return bucketId;
  }
}
