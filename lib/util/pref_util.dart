import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class PreferenceUtil {
  static const String IGNORE_LIST = "IGNORE_LIST";
  static const String PREF_KEY_DOWNLOAD_OK_URL = "download_ok_url";
  static const String HISTORY_KEY = "history_key";
  static const String TOOLS_HISTORY_KEY = "tools_history_key";
  static const String PASS_CAST_HISTORY_KEY = "pass_cast";

  static const String KEY_SETTING_WITCH_VIDEO = "key_setting_witch_video";
  static const String KEY_SETTING_TIP_TIMES = "key_setting_tip_times";
  /// 视频播放，提醒一次记录
  static const String KEY_SETTING_TIP_RECORD = "key_setting_tip_record";
  static const String KEY_SETTING_PICTURE_MODE = "key_setting_picture_mode";

  static const String KEY_FONT_SIZE = "KEY_FONT_SIZE";
  static const String KEY_ALL_FONT_SIZE = "KEY_ALL_FONT_SIZE";
  static const String KEY_PER_VOICE = "KEY_PER_VOICE";
  static const String KEY_VOICE_SPEED = "KEY_VOICE_SPEED";
  static const String KEY_VOICE_PIT = "KEY_VOICE_PIT";

  static String KEY_SUBSCRIBE_DATA = "subscribe_Data";
  static String KEY_DARK_MODE = "key_dark_mode";
  /// 是否第一次进入首页
  static const String KEY_IS_FIRST = "key_is_first";
}

setPrefString(String key, String value) async {
  final prefs = await StreamingSharedPreferences.instance;
  prefs.setString(key, value);
}

setPrefInt(String key, int value) async {
  final prefs = await StreamingSharedPreferences.instance;
  prefs.setInt(key, value);
}

setPrefBigInt(String key, BigInt value) async {
  final prefs = await StreamingSharedPreferences.instance;
  prefs.setString(key, value.toString());
}

setPrefDouble(String key, double value) async {
  final prefs = await StreamingSharedPreferences.instance;
  prefs.setDouble(key, value);
}

setPrefStringList(String key, List<String> value) async {
  final preferences = await StreamingSharedPreferences.instance;
  preferences.setStringList(key, value);
}

getPrefStringList(String key, {List<String> defaultValue = const []}) async {
  final preferences = await StreamingSharedPreferences.instance;
  return preferences.getStringList(key, defaultValue: defaultValue)?.getValue();
}

setPrefBool(String key, bool value) async {
  final prefs = await StreamingSharedPreferences.instance;
  prefs.setBool(key, value);
}

getPrefString(String key, {String defaultValue = ''}) async {
  final prefs = await StreamingSharedPreferences.instance;
  return prefs.getString(key, defaultValue: defaultValue)?.getValue();
}

getPrefInt(String key, {int defaultValue = 0}) async {
  final prefs = await StreamingSharedPreferences.instance;
  return prefs.getInt(key, defaultValue: defaultValue)?.getValue();
}

/*getPrefBigInt(String key, {required BigInt defaultValue}) async {
  final prefs = await StreamingSharedPreferences.instance;
  if (prefs.getString(key, defaultValue: "") != null) {
    return BigInt.parse(prefs.getString(key, defaultValue: "")?.getValue());
  } else {
    return defaultValue;
  }
}*/

getPrefDouble(String key, {double defaultValue = 0}) async {
  final prefs = await StreamingSharedPreferences.instance;
  return prefs.getDouble(key, defaultValue: defaultValue)?.getValue();
}

getPrefBool(String key, {bool defaultValue = false}) async {
  final prefs = await StreamingSharedPreferences.instance;
  return prefs.getBool(key, defaultValue: defaultValue)?.getValue();
}

removePref(String key) async {
  final prefs = await StreamingSharedPreferences.instance;
  prefs.remove(key);
}
