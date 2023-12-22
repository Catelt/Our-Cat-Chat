part of 'home_cubit.dart';

class HomeState extends Equatable {
  final List<XMessage> messages;
  final XHandle<bool> handle;

  const HomeState({
    required this.handle,
    this.messages = const [],
  });

  factory HomeState.ds() {
    return HomeState(
      handle: XHandle(),
      messages: UserPrefs.I.getMessages(),
    );
  }

  HomeState copyWith({
    XHandle<bool>? handle,
    List<XMessage>? messages,
  }) {
    return HomeState(
      messages: messages ?? this.messages,
      handle: handle ?? this.handle,
    );
  }

  @override
  List<Object?> get props => [messages, handle];

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
