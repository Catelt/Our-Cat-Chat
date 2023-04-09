part of 'home_cubit.dart';

class HomeState extends Equatable {
  final bool enableAutoTTS;
  final XLanguage language;
  final List<XMessage> messages;
  final bool isLoading;

  const HomeState(
      {this.enableAutoTTS = true,
      this.messages = const [],
      required this.language,
      this.isLoading = false});

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
  }) {
    return HomeState(
        enableAutoTTS: enableAutoTTS ?? this.enableAutoTTS,
        language: language ?? this.language,
        messages: messages ?? this.messages,
        isLoading: isLoading ?? this.isLoading);
  }

  @override
  List<Object?> get props => [enableAutoTTS, messages, language, isLoading];

  String get getRecentMessageOfUser {
    var str = '';
    List<XMessage> list = this.messages.where((e) => e.indexChat == 1).toList();
    list = list.reversed.toList();
    for (var i = 0; i < list.length && i < 3; i++) {
      str += '${list[i].msg}.';
    }
    return str;
  }
}
