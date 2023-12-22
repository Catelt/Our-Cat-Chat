import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mime/mime.dart';
import 'package:my_chat_gpt/src/network/domain_manager.dart';
import 'package:my_chat_gpt/src/network/model/common/handle.dart';
import 'package:my_chat_gpt/src/network/model/content.dart';
import 'package:my_chat_gpt/src/network/model/inline_data.dart';
import 'package:my_chat_gpt/src/network/model/message.dart';
import 'package:my_chat_gpt/src/network/model/part.dart';
import 'package:my_chat_gpt/src/network/model/role.dart';
import 'package:my_chat_gpt/src/services/user_prefs.dart';
import 'package:my_chat_gpt/src/utils/base64.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.domain) : super(HomeState.ds());
  final DomainManager domain;

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
    onChangeMessage([]);
  }

  Future<void> sendMessage(String message) async {
    if (message.isEmpty) return;
    emit(state.copyWith(handle: XHandle.loading()));
    List<MPart> parts = [];
    parts.add(MPart(text: message));
    addMessage(XMessage.newMsg(message));
    final response = await domain.gemini.sendMessage(
      contents: [MContent(parts: parts)],
    );
    if (response.isSuccess) {
      final data = response.data;
      if (data != null) {
        addMessage(data);
        emit(state.copyWith(handle: XHandle.success(true)));
        return;
      }
    }
    emit(state.copyWith(handle: XHandle.error(response.error)));
  }

  Future<void> sendMessageStream(String message) async {
    if (message.isEmpty) return;
    addMessage(XMessage.newMsg(message));
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

  Future<void> sendMessageWithImage(String message, String path) async {
    if (message.isEmpty && path.isEmpty) return;
    final base64 = await XBase64.convertImageToBase64(path);
    final type = lookupMimeType(path);
    if (type == null) return;
    emit(state.copyWith(handle: XHandle.loading()));
    List<MPart> parts = [];
    parts.add(MPart(text: message));
    parts.add(MPart(inlineData: MInlineData(mimeType: type, data: base64)));
    addMessage(XMessage.newMsg(message, image: base64));
    final response = await domain.gemini.sendMessageWithImage(
      contents: [MContent(parts: parts)],
    );
    if (response.isSuccess) {
      final data = response.data;
      if (data != null) {
        addMessage(data);
        emit(state.copyWith(handle: XHandle.success(true)));
        return;
      }
    }
    emit(state.copyWith(handle: XHandle.error(response.error)));
  }
}
