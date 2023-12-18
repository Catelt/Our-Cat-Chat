part of 'home_cubit.dart';

class HomeState extends Equatable {
  final bool enableAutoTTS;
  final XLanguage language;
  final List<XMessage> messages;
  final bool isLoading;
  final int isSpeaking;

  const HomeState(
      {this.enableAutoTTS = true,
      this.messages = const [],
      required this.language,
      this.isLoading = false,
      this.isSpeaking = -1});

  factory HomeState.ds() {
    return HomeState(
        enableAutoTTS: UserPrefs.I.getEnableTTS(),
        messages: UserPrefs.I.getMessages(),
        language: UserPrefs.I.getLanguage());
  }

  HomeState copyWith({
    bool? enableAutoTTS,
    XLanguage? language,
    List<XMessage>? messages,
    bool? isLoading,
    int? isSpeaking,
  }) {
    return HomeState(
        enableAutoTTS: enableAutoTTS ?? this.enableAutoTTS,
        language: language ?? this.language,
        messages: messages ?? this.messages,
        isLoading: isLoading ?? this.isLoading,
        isSpeaking: isSpeaking ?? this.isSpeaking);
  }

  @override
  List<Object?> get props =>
      [enableAutoTTS, messages, language, isLoading, isSpeaking];

  String get getRecentMessageOfUser {
    var str = '';
    List<XMessage> list = List.from(messages);
    list = list.reversed.toList();
    for (var i = 0; i < list.length && i < 10; i++) {
      str += '${list[i].msg}.';
    }
    return str;
  }
}
