import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_gpt/gen/assets.gen.dart';
import 'package:my_chat_gpt/src/constants/app_sizes.dart';
import 'package:my_chat_gpt/src/feature/logic/home_cubit.dart';
import 'package:my_chat_gpt/src/feature/view/setting_page.dart';
import 'package:my_chat_gpt/src/feature/view/widgets/custom_edit_text.dart';
import 'package:my_chat_gpt/src/feature/view/widgets/msg_item.dart';
import 'package:my_chat_gpt/src/localization/localization_utils.dart';
import 'package:my_chat_gpt/src/network/model/message.dart';
import 'package:my_chat_gpt/src/network/model/role.dart';
import 'package:my_chat_gpt/src/services/app_tts.dart';
import 'package:my_chat_gpt/src/widgets/slide_right_route.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listenWhen: (previous, current) => previous.handle != current.handle,
      listener: (context, state) {
        if (state.handle.isError) {
          final error = state.handle.message;
          if (error != null && error.isNotEmpty == true) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(error),
            ));
          }
        }
      },
      child: _homeView(context),
    );
  }

  Widget _homeView(BuildContext context) => BlocBuilder<HomeCubit, HomeState>(
        buildWhen: (previous, current) =>
            previous.language != current.language ||
            previous.handle != current.handle,
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
                          Assets.images.icApp.image(
                            height: Sizes.p36,
                            width: Sizes.p36,
                          ),
                          Gaps.w16,
                          Text(
                            S.of(context).title_home_appbar,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Visibility(
                                visible: state.handle.isLoading,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        S
                                            .of(context)
                                            .title_home_appbar_thinking,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.visible,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          // IconButton(
                          //     onPressed: () async {
                          //       await showModalBottomSheet(
                          //           context: context,
                          //           builder: (_) {
                          //             return BlocProvider.value(
                          //               value: context.read<HomeCubit>(),
                          //               child: const BottomSelectLanguage(),
                          //             );
                          //           });
                          //     },
                          //     icon: Image.asset(
                          //       state.language.icon,
                          //       height: 24,
                          //       width: 28,
                          //     )),
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
            body: BlocConsumer<HomeCubit, HomeState>(
              listenWhen: (previous, current) =>
                  previous.enableAutoTTS != current.enableAutoTTS ||
                  previous.isSpeaking != current.isSpeaking,
              listener: (context, state) async {
                if (state.isSpeaking < 0) {
                  AppTTS.I.stop();
                } else {
                  final message = state.messages[state.isSpeaking];
                  AppTTS.I.speak(message.msg, callback: () {
                    if (state.isSpeaking < 0) return;
                    if (state.messages[state.isSpeaking] == message) {
                      context.read<HomeCubit>().pauseSpeaking();
                    }
                  });
                }
              },
              buildWhen: (previous, current) =>
                  previous.messages != current.messages ||
                  previous.enableAutoTTS != current.enableAutoTTS ||
                  previous.isSpeaking != current.isSpeaking,
              builder: (context, state) {
                return SafeArea(
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        height: double.infinity,
                        child: SingleChildScrollView(
                            reverse: true,
                            child: ListView.builder(
                                padding: const EdgeInsets.only(bottom: 70),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.messages.length,
                                itemBuilder: (context, index) => MsgItem(
                                      item: state.messages[index],
                                      enableAutoTTS: state.enableAutoTTS,
                                      isSpeaking: state.isSpeaking == index,
                                      index: index,
                                      isLast:
                                          index == state.messages.length - 1,
                                    ))),
                      ),
                      Positioned(
                          bottom: 20,
                          left: Sizes.p16,
                          right: Sizes.p16,
                          child: CustomEditText(
                            onSendText: (text) {
                              context.read<HomeCubit>().addMessage(
                                  XMessage.newMsg(text, role: MRole.user));
                              context.read<HomeCubit>().sendMessage(text);
                            },
                          ))
                    ],
                  ),
                );
              },
            ),
          );
        },
      );
}
