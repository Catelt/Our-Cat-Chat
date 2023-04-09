import 'package:my_chat_gpt/src/constants/app_language.dart';
import 'package:my_chat_gpt/src/network/model/language.dart';
import 'package:my_chat_gpt/src/network/model/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _keys {
  static const String language = 'language';
  static const String messages = 'messages';
  static const String enableTTS = 'enable_tts';
}

class UserPrefs {
  factory UserPrefs() => instance;
  UserPrefs._internal();

  static final UserPrefs instance = UserPrefs._internal();
  static UserPrefs get I => instance;
  late SharedPreferences _prefs;
  Future initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Language
  XLanguage getLanguage() {
    final value = _prefs.getString(_keys.language);
    return AppLanguage.getLanguage(value);
  }

  void setLanguage(XLanguage value) {
    _prefs.setString(_keys.language, value.code.toString().toLowerCase());
  }

  // enableTTS
  bool getEnableTTS() {
    final value = _prefs.getBool(_keys.enableTTS);
    return value ?? true;
  }

  void setEnableTTS(bool value) {
    _prefs.setBool(_keys.enableTTS, value);
  }

  // message
  void saveMessages(List<XMessage> list) {
    if (list.isEmpty) {
      _prefs.remove(_keys.messages);
    } else {
      final jsonList = list.map((message) => message.toJson()).toList();
      _prefs.setStringList(_keys.messages, jsonList);
    }
  }

  List<XMessage> getMessages() {
    List<XMessage> result = [];
    final list = _prefs.getStringList(_keys.messages);
    if (list == null) return result;
    result = list.map((message) => XMessage.fromJson(message)).toList();
    return result;
  }
}
