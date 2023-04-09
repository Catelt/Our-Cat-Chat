import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_gpt/src/network/model/language.dart';
import 'package:my_chat_gpt/src/network/model/message.dart';
import 'package:my_chat_gpt/src/services/user_prefs.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState.ds());

  void onChangeAutoTTS(bool value) {
    emit(state.copyWith(enableAutoTTS: value));
    UserPrefs.I.setEnableTTS(value);
  }

  void onChangeLanguage(XLanguage language) {
    emit(state.copyWith(language: language));
    UserPrefs.I.setLanguage(language);
  }

  void addMessage(XMessage value) {
    List<XMessage> newList = List.from(state.messages);
    newList.add(value);
    emit(state.copyWith(messages: newList));
    UserPrefs.I.saveMessages(newList);
  }

  void removeAllMessage() {
    emit(state.copyWith(messages: []));
    UserPrefs.I.saveMessages([]);
  }
}
