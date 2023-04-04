import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:my_chat_gpt/src/constants/app_sizes.dart';
import 'package:my_chat_gpt/src/feature/view/widgets/custom_edit_text.dart';
import 'package:my_chat_gpt/src/feature/view/widgets/msg_item.dart';
import 'package:my_chat_gpt/src/network/model/message.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});
  final FlutterTts tts = FlutterTts();

  void _speak(String text) async {
    await tts.setLanguage('en-US');
    await tts.setPitch(1);
    await tts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          toolbarHeight: 60,
          flexibleSpace: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: Sizes.p16, horizontal: Sizes.p20),
            child: SafeArea(
              child: Container(
                height: 60,
                child: Row(
                  children: [
                    Icon(Icons.home),
                    Gaps.w8,
                    Text('Chat GPT'),
                    Spacer(),
                    Icon(Icons.volume_up),
                    Gaps.w8,
                    Icon(Icons.language)
                  ],
                ),
              ),
            ),
          )),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              child: SingleChildScrollView(
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 30,
                      itemBuilder: (context, index) => MsgItem(
                          item: XMessage.newMsg("Hello Chat Gpt"),
                          onSpeak: (text) {
                            _speak(text);
                          }))),
            ),
            Positioned(
                bottom: 20,
                left: Sizes.p16,
                right: Sizes.p16,
                child: CustomEditText(
                  onSendText: (text) {
                    print(text);
                  },
                ))
          ],
        ),
      ),
    );
  }
}
