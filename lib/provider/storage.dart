import 'package:shared_preferences/shared_preferences.dart';

/// 语言
const String LOCALE_KEY = 'LOCALE_KEY';
const String COUNTRY_CODE = 'COUNTRY_CODE';
const String TOKEN = 'TOKEN';
const String SESSION_ID = 'SESSION_ID';

const String USER_NAME = 'USER_NAME';
const String USER_PASSWORD = 'USER_PASSWORD';
const String LOGIN_TYPE = 'LOGIN_TYPE';

const String IS_LOGIN = 'IS_LOGIN';
const String USER_BEAN = 'USER_BEAN';

class Storage {
  /// 设置数据
  static Future<void> setString(key, value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(key, value);
  }

  static Future<void> setLanguage(value) async {
    await setString(LOCALE_KEY, value);
  }

  /// 获取数据
  static Future<String?> getString(key) async {
    var sp = await SharedPreferences.getInstance();
    if (sp.getString(key) != null) {
      return sp.getString(key);
    } else {
      return null;
    }
  }

  /// 设置数据
  static Future<void> setBool(key, value) async {
    var sp = await SharedPreferences.getInstance();
    await sp.setBool(key, value);
  }

  /// 设置数据
  static Future<void> setInt(key, value) async {
    var sp = await SharedPreferences.getInstance();
    await sp.setInt(key, value);
  }

  /// 设置数据
  static Future<int> getInt(key) async {
    var sp = await SharedPreferences.getInstance();
    return sp.getInt(key) ?? 0;
  }

  /// 获取数据
  static Future<bool?> getBool(key) async {
    var sp = await SharedPreferences.getInstance();
    return sp.getBool(key);
  }

  /// 获取字符串数组
  static Future<List<String>?> getStringList(key) async {
    var sp = await SharedPreferences.getInstance();
    return sp.getStringList(key);
  }

  /// 设置字符串数组
  static Future<Future<bool>> setStringList(key, List<String> list) async {
    var sp = await SharedPreferences.getInstance();
    return sp.setStringList(key, list);
  }

  /// 根据key移除持久化数据
  static Future<void> remove(key) async {
    var sp = await SharedPreferences.getInstance();
    await sp.remove(key);
  }

  /// 清除所有持久化数据
  static Future<void> clearAll() async {
    var sp = await SharedPreferences.getInstance();
    await sp.clear();
  }
}
