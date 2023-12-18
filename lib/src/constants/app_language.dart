import 'package:my_chat_gpt/src/network/model/language.dart';

class AppLanguage {
  static final languages = [
    XLanguage(name: "English", code: 'en', icon: 'assets/images/en_flag.png'),
    XLanguage(name: "Việt Nam", code: 'vi', icon: 'assets/images/vn_flag.png'),
  ];

  static XLanguage getLanguage(String? code) {
    return languages.firstWhere((e) => e.code == code,
        orElse: () => languages[0]);
  }
}
