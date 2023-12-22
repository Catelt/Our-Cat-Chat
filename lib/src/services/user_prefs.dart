import 'package:flutter/material.dart';
import 'package:my_chat_gpt/src/constants/app_language.dart';
import 'package:my_chat_gpt/src/utils/theme.dart';
import 'package:my_chat_gpt/src/network/model/language.dart';
import 'package:my_chat_gpt/src/network/model/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin _keys {
  static const String language = 'language';
  static const String theme = 'theme';
  static const String messages = 'messages';
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

  // Theme
  ThemeMode getTheme() {
    final value = _prefs.getString(_keys.theme);
    return ThemeUtils.fromName(value);
  }

  void setTheme(ThemeMode value) {
    _prefs.setString(_keys.theme, value.name);
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
