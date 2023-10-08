import 'package:mmkv/mmkv.dart';

/// 语言
const String LOCALE_KEY = 'LOCALE_KEY';
const String COUNTRY_CODE = 'COUNTRY_CODE';
const String TOKEN = 'TOKEN';
const String SESSION_ID = 'SESSION_ID';

const String USER_NAME = 'USER_NAME';
const String LOGIN_TYPE = 'LOGIN_TYPE';
const String USER_PASSWORD = 'USER_PASSWORD';

const String IS_LOGIN = 'IS_LOGIN';
const String USER_BEAN = 'USER_BEAN';

class MMKVUtils {
  static void setString(key, value) {
    var defaultMMKV = MMKV.defaultMMKV();
    defaultMMKV.encodeString(key, value);
  }

  /// 获取数据
  static String? getString(key) {
    var defaultMMKV = MMKV.defaultMMKV();
    return defaultMMKV.decodeString(key);
  }

  /// 设置数据
  static Future<void> setBool(key, value) async {
    var defaultMMKV = MMKV.defaultMMKV();
    defaultMMKV.encodeBool(key, value);
  }

  /// 设置数据
  static void setInt(key, value)  {
    var defaultMMKV = MMKV.defaultMMKV();
    defaultMMKV.encodeInt(key, value);
  }

  /// 设置数据
  static int getInt(key, {defaultValue = 0}) {
    var defaultMMKV = MMKV.defaultMMKV();
    return defaultMMKV.decodeInt(key, defaultValue: defaultValue);
  }

  /// 获取数据
  static bool getBool(key, {defaultValue = false}) {
    var defaultMMKV = MMKV.defaultMMKV();
    return defaultMMKV.decodeBool(key, defaultValue: defaultValue);
  }

  /// 根据key移除持久化数据
  static void remove(key) {
    var defaultMMKV = MMKV.defaultMMKV();
    defaultMMKV.removeValue(key);
  }

  /// 清除所有持久化数据
  static void clearAll() {
    var defaultMMKV = MMKV.defaultMMKV();
    defaultMMKV.clearAll();
  }
}
