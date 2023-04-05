import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:my_chat_gpt/src/constants/app_sizes.dart';
import 'package:my_chat_gpt/src/constants/images.dart';
import 'package:my_chat_gpt/src/feature/logic/cubit/home_cubit.dart';
import 'package:my_chat_gpt/src/feature/view/setting_page.dart';
import 'package:my_chat_gpt/src/feature/view/widgets/custom_edit_text.dart';
import 'package:my_chat_gpt/src/feature/view/widgets/msg_item.dart';
import 'package:my_chat_gpt/src/network/model/message.dart';
import 'package:my_chat_gpt/src/widgets/slide_right_route.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final FlutterTts tts = FlutterTts();

  void _speak(String text) async {
    await tts.setLanguage('en-US');
    await tts.setPitch(1);
    await tts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: _homeView(context),
    );
  }

  Widget _homeView(BuildContext context) => BlocBuilder<HomeCubit, HomeState>(
        buildWhen: (previous, current) =>
            previous.enableAutoTTS != current.enableAutoTTS,
        builder: (context, state) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
                toolbarHeight: 60,
                flexibleSpace: Padding(
                  padding:
                      const EdgeInsets.only(left: Sizes.p16, right: Sizes.p8),
                  child: SafeArea(
                    child: SizedBox(
                      height: 60,
                      child: Row(
                        children: [
                          Image.asset(
                            XImagePath.botImage,
                            height: Sizes.p36,
                            width: Sizes.p36,
                          ),
                          Gaps.w16,
                          const Text(
                            'Chat GPT',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          IconButton(
                              onPressed: () {
                                context
                                    .read<HomeCubit>()
                                    .onChangeAutoTTS(!state.enableAutoTTS);
                              },
                              icon: state.enableAutoTTS
                                  ? const Icon(Icons.volume_up)
                                  : const Icon(Icons.volume_off_rounded)),
                          IconButton(
                              onPressed: () async {
                                await showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.all(Sizes.p16),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text("Select Speech Language"),
                                            ListView.separated(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return Row(children: [
                                                  Image.asset(
                                                    XImagePath.botImage,
                                                    height: 24,
                                                    width: 24,
                                                  ),
                                                  Text("Việt Nam")
                                                ]);
                                              },
                                              itemCount: 2,
                                              separatorBuilder:
                                                  (context, index) {
                                                return SizedBox(
                                                  width: double.infinity,
                                                  child: Divider(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .surfaceVariant,
                                                    height: 2,
                                                  ),
                                                );
                                              },
                                            )
                                          ],
                                        ),
                                      );
                                    });
                              },
                              icon: Icon(Icons.language)),
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  SlideRightRoute(page: const SettingPage()),
                                );
                              },
                              icon: const Icon(Icons.settings))
                        ],
                      ),
                    ),
                  ),
                )),
            body: SafeArea(
              child: Stack(
                children: [
                  SizedBox(
                    height: double.infinity,
                    child: SingleChildScrollView(
                        child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 70),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 30,
                            itemBuilder: (context, index) => MsgItem(
                                item: XMessage.newMsg(
                                    "Hello Chat Gpt, Are You Oke asdasd",
                                    indexChat: index == 1 ? 1 : 0),
                                enableAutoTTS: state.enableAutoTTS,
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
        },
      );
}
