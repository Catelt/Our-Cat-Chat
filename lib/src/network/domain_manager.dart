import 'package:my_chat_gpt/src/network/data/common/http.dart';
import 'package:my_chat_gpt/src/network/data/gemini/gemini_repository.dart';

class DomainManager {
  factory DomainManager() => I;
  DomainManager._internal() {
    final http = XHttp();
    gemini = GeminiRepositoryImpl(http);
  }

  static final DomainManager I = DomainManager._internal();

  late GeminiRepository gemini;
}
