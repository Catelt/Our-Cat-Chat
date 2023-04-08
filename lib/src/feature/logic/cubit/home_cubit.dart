import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_chat_gpt/src/network/model/message.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void onChangeAutoTTS(bool value) {
    emit(state.copyWith(enableAutoTTS: value));
  }

  void addMessage(XMessage value) {
    List<XMessage> newList = List.from(state.messages);
    newList.add(value);
    emit(state.copyWith(messages: newList));
  }
}
