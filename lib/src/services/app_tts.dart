import 'package:flutter_tts/flutter_tts.dart';
import 'package:my_chat_gpt/src/services/user_prefs.dart';

class AppTTS {
  factory AppTTS() => instance;
  AppTTS._internal();

  static final AppTTS instance = AppTTS._internal();
  static AppTTS get I => instance;
  late FlutterTts _tts;

  void initialize() {
    _tts = FlutterTts();
  }

  void speak(String text, {void Function()? callback}) async {
    _tts.setCompletionHandler(() {
      callback?.call();
    });
    await _tts.setLanguage(UserPrefs.I.getLanguage().code);
    await _tts.setPitch(1);
    await _tts.speak(text);
  }

  void stop() async {
    await _tts.stop();
  }
}
