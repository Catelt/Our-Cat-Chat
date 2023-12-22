import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_gpt/src/network/model/language.dart';
import 'package:my_chat_gpt/src/services/user_prefs.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState.ds());

  void onChangeLanguage(XLanguage language) {
    emit(state.copyWith(language: language));
    UserPrefs.I.setLanguage(language);
  }

  void onChangeTheme(int value) {
    final theme = ThemeMode.values[value];
    emit(state.copyWith(theme: theme));
    UserPrefs.I.setTheme(theme);
  }
}
