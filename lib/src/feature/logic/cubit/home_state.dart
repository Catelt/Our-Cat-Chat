// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_cubit.dart';

class HomeState extends Equatable {
  final bool enableAutoTTS;

  const HomeState({this.enableAutoTTS = true});

  HomeState copyWith({
    bool? enableAutoTTS,
  }) {
    return HomeState(
      enableAutoTTS: enableAutoTTS ?? this.enableAutoTTS,
    );
  }

  @override
  List<Object?> get props => [enableAutoTTS];
}
