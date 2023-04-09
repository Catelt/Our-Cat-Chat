part of 'home_cubit.dart';

class HomeState extends Equatable {
  final bool enableAutoTTS;
  final XLanguage language;
  final List<XMessage> messages;

  const HomeState(
      {this.enableAutoTTS = true,
      this.messages = const [],
      required this.language});

  factory HomeState.ds() {
    return HomeState(
        enableAutoTTS: true,
        messages: const [],
        language: UserPrefs.I.getLanguage());
  }

  HomeState copyWith({
    bool? enableAutoTTS,
    XLanguage? language,
    List<XMessage>? messages,
  }) {
    return HomeState(
      enableAutoTTS: enableAutoTTS ?? this.enableAutoTTS,
      language: language ?? this.language,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object?> get props => [enableAutoTTS, messages, language];
}
