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

  void onChangeLanguage(XLanguage language) {
    emit(state.copyWith(language: language));
    UserPrefs.I.setLanguage(language);
  }

  void addMessage(XMessage value) {
    List<XMessage> newList = List.from(state.messages);
    newList.add(value);
    onChangeMessage(newList);
  }

  void onChangeMessage(List<XMessage> messages) {
    emit(state.copyWith(messages: messages));
    UserPrefs.I.saveMessages(messages);
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
    var messageResponse =
        XMessage(msg: "", time: DateTime.now(), role: MRole.model);
    final response = await domain.gemini.sendMessageStream(
      contents: contents,
      snapshot: (value) {
        List<XMessage> messages = List.from(state.messages);
        if (messageResponse.msg.isNotEmpty &&
            messages.last.role == MRole.model) {
          messages.removeLast();
        }
        messageResponse = messageResponse.copyWith(msg: value);
        messages.add(messageResponse);
        onChangeMessage(messages);
      },
    );
    if (response.isSuccess) {
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
