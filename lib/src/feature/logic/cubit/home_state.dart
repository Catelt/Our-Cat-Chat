// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_cubit.dart';

class HomeState extends Equatable {
  final bool enableAutoTTS;
  final List<XMessage> messages;

  const HomeState({this.enableAutoTTS = true, this.messages = const []});

  HomeState copyWith({
    bool? enableAutoTTS,
    List<XMessage>? messages,
  }) {
    return HomeState(
      enableAutoTTS: enableAutoTTS ?? this.enableAutoTTS,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object?> get props => [enableAutoTTS, messages];
}
