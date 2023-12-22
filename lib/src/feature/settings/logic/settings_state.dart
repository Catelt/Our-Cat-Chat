part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final XLanguage language;
  final ThemeMode theme;

  const SettingsState({
    required this.language,
    required this.theme,
  });

  factory SettingsState.ds() => SettingsState(
        language: UserPrefs.I.getLanguage(),
        theme: UserPrefs.I.getTheme(),
      );

  SettingsState copyWith({
    XLanguage? language,
    ThemeMode? theme,
  }) {
    return SettingsState(
      language: language ?? this.language,
      theme: theme ?? this.theme,
    );
  }

  @override
  List<Object> get props => [language, theme];
}
