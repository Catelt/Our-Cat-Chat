import 'package:flutter/material.dart';
import 'package:my_chat_gpt/main.dart';
import 'package:my_chat_gpt/src/constants/app_sizes.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class CustomEditText extends StatefulWidget {
  const CustomEditText({super.key, required this.onSendText});
  final void Function(String) onSendText;

  @override
  State<CustomEditText> createState() => _CustomEditTextState();
}

class _CustomEditTextState extends State<CustomEditText> {
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  final controller = TextEditingController();

  @override
  void dispose() {
    _stopListening();
    controller.dispose();
    super.dispose();
  }

  Future<void> _initSpeech() async {
    if (!_speechToText.isAvailable) {
      await _speechToText.initialize(onError: (error) => logger.e(error));
    }
  }

  Future<void> _stopListening() async {
    if (_speechToText.isAvailable) {
      await _speechToText.stop();
      setState(() {});
    }
  }

  void _startListening() async {
    await _initSpeech();
    if (_speechToText.isAvailable) {
      await _speechToText.listen(onResult: _onSpeechResult);
      setState(() {});
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      if (_speechToText.isListening) {
        controller.text = result.recognizedWords;
        controller.selection =
            TextSelection.collapsed(offset: controller.text.length);
      }
    });
  }

  void _handleSendText() async {
    await _stopListening();
    widget.onSendText(controller.text);
    controller.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedOpacity(
          opacity: _speechToText.isListening ? 1 : 0,
          duration: const Duration(seconds: 1),
          child: Container(
              padding: const EdgeInsets.symmetric(
                  vertical: Sizes.p8, horizontal: Sizes.p12),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(Sizes.p12)),
              child: const Text(
                'GPT bot is listening...',
                style: TextStyle(
                  fontSize: Sizes.p16,
                ),
              )),
        ),
        Gaps.h8,
        Material(
          borderRadius: BorderRadius.circular(Sizes.p12),
          elevation: 8,
          child: Row(
            children: [
              Expanded(
                  child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Start typing or taking',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Sizes.p12),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.all(Sizes.p12),
                ),
              )),
              IconButton(
                onPressed: () {
                  _speechToText.isListening
                      ? _stopListening()
                      : _startListening();
                },
                icon: Icon(
                  Icons.mic,
                  size: Sizes.p28,
                  color: _speechToText.isListening
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
              ),
              IconButton(
                onPressed: _handleSendText,
                icon: Icon(
                  Icons.send_rounded,
                  size: Sizes.p28,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
