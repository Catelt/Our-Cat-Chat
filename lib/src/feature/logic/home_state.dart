part of 'home_cubit.dart';

class HomeState extends Equatable {
  final bool enableAutoTTS;
  final XLanguage language;
  final List<XMessage> messages;
  final XHandle<bool> handle;
  final int isSpeaking;

  const HomeState({
    required this.handle,
    this.enableAutoTTS = true,
    this.messages = const [],
    required this.language,
    this.isSpeaking = -1,
  });

  factory HomeState.ds() {
    return HomeState(
      handle: XHandle(),
      enableAutoTTS: UserPrefs.I.getEnableTTS(),
      messages: UserPrefs.I.getMessages(),
      language: UserPrefs.I.getLanguage(),
    );
  }

  HomeState copyWith({
    XHandle<bool>? handle,
    bool? enableAutoTTS,
    XLanguage? language,
    List<XMessage>? messages,
    int? isSpeaking,
  }) {
    return HomeState(
        enableAutoTTS: enableAutoTTS ?? this.enableAutoTTS,
        language: language ?? this.language,
        messages: messages ?? this.messages,
        handle: handle ?? this.handle,
        isSpeaking: isSpeaking ?? this.isSpeaking);
  }

  @override
  List<Object?> get props =>
      [enableAutoTTS, messages, language, handle, isSpeaking];

  List<MContent> get getRecentMessage {
    List<XMessage> list = List.from(messages);
    List<MContent> result = [];
    list = list.reversed.toList();
    XMessage? previous;
    for (var i = 0; i < list.length && i < 10; i++) {
      final e = list[i];
      String text = e.msg;
      if (i > 0) {
        if (previous?.role == e.role) {
          result.removeLast();
          text = "$text ${previous?.msg}";
        }
      }
      previous = e;
      result.add(MContent(parts: [MPart(text: text)], role: e.role));
    }
    return result.reversed.toList();
  }
}
