import 'package:flutter/material.dart';
import 'package:my_chat_gpt/src/localization/localization_utils.dart';

class ThemeUtils {
  static ThemeMode fromName(String? name) {
    return ThemeMode.values
        .firstWhere((e) => e.name == name, orElse: () => ThemeMode.system);
  }
}

extension ThemeModeExtension on ThemeMode {
  String get getTitle {
    switch (this) {
      case ThemeMode.system:
        return S.text.system;
      case ThemeMode.light:
        return S.text.light;
      case ThemeMode.dark:
        return S.text.dark;
    }
  }
}
