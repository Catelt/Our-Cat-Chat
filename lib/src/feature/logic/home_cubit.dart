import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_gpt/src/network/domain_manager.dart';
import 'package:my_chat_gpt/src/network/model/language.dart';
import 'package:my_chat_gpt/src/network/model/message.dart';
import 'package:my_chat_gpt/src/services/user_prefs.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.domain) : super(HomeState.ds());
  final DomainManager domain;

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

  Future<void> sendMessage(String message) async {
    emit(state.copyWith(isLoading: true));
    String str = state.getRecentMessageOfUser;
    if (str.isNotEmpty) {
      str = '$str $message';
    } else {
      str = message;
    }
    final result = await domain.gpt.sendMessage(message: message);
    if (result.isSuccess) {
      result.data?.forEach((message) {
        addMessage(message);
      });
    }
    emit(state.copyWith(isLoading: false));
  }
}
