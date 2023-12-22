import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_gpt/gen/assets.gen.dart';
import 'package:my_chat_gpt/src/constants/app_sizes.dart';
import 'package:my_chat_gpt/src/feature/settings/settings_page.dart';
import 'package:my_chat_gpt/src/widgets/custom_edit_text.dart';
import 'package:my_chat_gpt/src/feature/home/widgets/msg_item.dart';
import 'package:my_chat_gpt/src/localization/localization_utils.dart';
import 'package:my_chat_gpt/src/widgets/slide_right_route.dart';

import 'logic/home_cubit.dart';

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
        buildWhen: (previous, current) => previous.handle != current.handle,
        builder: (context, state) {
          return Scaffold(
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
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                SlideRightRoute(
                                  page: const SettingsPage(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.settings),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
            body: BlocBuilder<HomeCubit, HomeState>(
              buildWhen: (previous, current) =>
                  previous.messages != current.messages,
              builder: (context, state) {
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        reverse: true,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.messages.length,
                          itemBuilder: (context, index) => MsgItem(
                            item: state.messages[index],
                          ),
                        ),
                      ),
                    ),
                    BlocBuilder<HomeCubit, HomeState>(
                      buildWhen: (previous, current) =>
                          previous.handle != current.handle,
                      builder: (context, state) {
                        return CustomEditText(
                          isLoading: state.handle.isLoading,
                          onSendText: (text, base64) {
                            if (base64.isEmpty) {
                              context.read<HomeCubit>().sendMessage(text);
                            } else {
                              context.read<HomeCubit>().sendMessageWithImage(
                                    text,
                                    base64,
                                  );
                            }
                          },
                        );
                      },
                    )
                  ],
                );
              },
            ),
          );
        },
      );
}
