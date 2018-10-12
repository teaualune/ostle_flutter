import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class OstlePreferences {

  static String _gameConfigIndexKey = 'gameConfigIndexKey';

  static Future<int> getGameConfigIndex() async {
    int index;
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      index = sp.getInt(_gameConfigIndexKey);
    } catch (ignored) {}
    if (index == null) {
      index = 0;
    }
    return index;
  }

  static Future<void> setGameConfigIndex(int index) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      await sp.setInt(_gameConfigIndexKey, index);
    } catch (ignored) {}
  }
}