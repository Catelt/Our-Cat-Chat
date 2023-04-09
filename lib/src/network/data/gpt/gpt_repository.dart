import 'package:my_chat_gpt/src/network/model/common/result.dart';
import 'package:my_chat_gpt/src/network/model/message.dart';

abstract class GPTRepository {
  Future<MResult<List<XMessage>>> sendMessage({required String message});
}
