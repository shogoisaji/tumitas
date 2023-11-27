import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tumitas/models/bucket.dart';

class SharedPreferencesHelper {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveBucket(Bucket bucket) async {
    if (_prefs == null) {
      print('SharedPreferencesHelper is not initialized');
      return;
    }
    String jsonString = json.encode(bucket.toJson());
    await _prefs!.setString('bucket', jsonString);
    print('saveBucket: $jsonString');
  }

  Future<Bucket?> loadBucket() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('bucket');
    print('loadBucket: $jsonString');
    return jsonString == null ? null : Bucket.fromJson(json.decode(jsonString));
  }
}
