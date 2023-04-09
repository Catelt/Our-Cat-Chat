import 'dart:convert';

import 'package:my_chat_gpt/src/network/data/common/http.dart';
import 'package:my_chat_gpt/src/network/model/common/result.dart';
import 'package:my_chat_gpt/src/network/model/message.dart';

import 'gpt_repository.dart';

class GPTRepositoryImpl extends GPTRepository {
  GPTRepositoryImpl(this.http);
  final XHttp http;

  @override
  Future<MResult<List<XMessage>>> sendMessage({required String message}) async {
    try {
      final body = jsonEncode({
        "model": "text-davinci-003",
        "prompt": message,
        "max_tokens": 50,
      });
      final response = await http.post("v1/completions", body: body);
      final jsonResponse = jsonDecode(response);
      if (jsonResponse['choices'].length > 0) {
        final messages = List.generate(
            jsonResponse['choices'].length,
            (index) => XMessage.newMsg(
                (jsonResponse['choices'][index]['text']).replaceAll('\n', ''),
                indexChat: 0));
        return MResult.success(messages);
      } else {
        return MResult.error(XHttp.unknown);
      }
    } catch (e) {
      return MResult.error(e.toString());
    }
  }
}
