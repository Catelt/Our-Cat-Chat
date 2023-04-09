import 'package:my_chat_gpt/src/constants/api_constant.dart';
import 'package:my_chat_gpt/src/network/data/common/http.dart';
import 'package:my_chat_gpt/src/network/data/gpt/gpt_repository.dart';
import 'package:my_chat_gpt/src/network/data/gpt/gpt_repository_impl.dart';

class DomainManager {
  factory DomainManager() => I;
  DomainManager._internal() {
    final http = XHttp();
    http.setTokenApi(ApiConstant.key);
    http.setDomain(ApiConstant.domain);
    gpt = GPTRepositoryImpl(http);
  }

  static final DomainManager I = DomainManager._internal();

  late GPTRepository gpt;
}
