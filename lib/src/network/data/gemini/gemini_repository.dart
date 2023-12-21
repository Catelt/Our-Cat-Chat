import 'dart:convert';

import 'package:http/http.dart';
import 'package:my_chat_gpt/src/constants/api_constant.dart';
import 'package:my_chat_gpt/src/network/data/common/http.dart';
import 'package:my_chat_gpt/src/network/model/common/result.dart';
import 'package:my_chat_gpt/src/network/model/content.dart';
import 'package:my_chat_gpt/src/network/model/gemini_request.dart';
import 'package:my_chat_gpt/src/network/model/gemini_response.dart';
import 'package:my_chat_gpt/src/network/model/message.dart';
import 'package:my_chat_gpt/src/network/model/role.dart';

part 'gemini_repository_impl.dart';

abstract class GeminiRepository {
  Future<MResult<XMessage>> sendMessage({required List<MContent> contents});
  Future<MResult<XMessage>> sendMessageWithImage(
      {required List<MContent> contents});

  Future<MResult<bool>> sendMessageStream({
    required List<MContent> contents,
    required void Function(String) snapshot,
  });
}
