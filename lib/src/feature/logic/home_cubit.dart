import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_gpt/src/network/domain_manager.dart';
import 'package:my_chat_gpt/src/network/model/common/handle.dart';
import 'package:my_chat_gpt/src/network/model/content.dart';
import 'package:my_chat_gpt/src/network/model/language.dart';
import 'package:my_chat_gpt/src/network/model/message.dart';
import 'package:my_chat_gpt/src/network/model/role.dart';
import 'package:my_chat_gpt/src/services/user_prefs.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.domain) : super(HomeState.ds());
  final DomainManager domain;

  void onChangeAutoTTS(bool value) {
    emit(state.copyWith(enableAutoTTS: value, isSpeaking: -1));
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
    if (message.isEmpty) return;
    addMessage(XMessage.newMsg(message, role: MRole.user));
    emit(state.copyWith(handle: XHandle.loading()));
    List<MContent> contents = state.getRecentMessage;
    List<XMessage> messages = List.from(state.messages);
    final response = await domain.gemini.sendMessage(contents: contents);
    if (response.isSuccess && response.data != null) {
      messages.add(response.data!);
      emit(state.copyWith(messages: messages));

      if (state.enableAutoTTS) {
        speaking(messages.length - 1);
      }
      emit(state.copyWith(handle: XHandle.success(true)));
      return;
    }
    emit(state.copyWith(handle: XHandle.error(response.error)));
  }

  void speaking(int index) {
    emit(state.copyWith(isSpeaking: index));
  }

  void pauseSpeaking() {
    emit(state.copyWith(isSpeaking: -1));
  }
}
