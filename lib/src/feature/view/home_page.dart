import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_gpt/gen/assets.gen.dart';
import 'package:my_chat_gpt/src/constants/app_sizes.dart';
import 'package:my_chat_gpt/src/feature/logic/home_cubit.dart';
import 'package:my_chat_gpt/src/feature/view/widgets/custom_edit_text.dart';
import 'package:my_chat_gpt/src/feature/view/widgets/msg_item.dart';
import 'package:my_chat_gpt/src/localization/localization_utils.dart';
import 'package:my_chat_gpt/src/widgets/bottom_select_language.dart';

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
                          IconButton(
                            onPressed: () async {
                              await showModalBottomSheet(
                                context: context,
                                builder: (_) {
                                  return BlocProvider.value(
                                    value: context.read<HomeCubit>(),
                                    child: const BottomSelectLanguage(),
                                  );
                                },
                              );
                            },
                            icon: Image.asset(
                              state.language.icon,
                              height: 24,
                              width: 28,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                dialogDeleted(context);
                              },
                              icon: const Icon(Icons.delete))
                        ],
                      ),
                    ),
                  ),
                )),
            body: BlocBuilder<HomeCubit, HomeState>(
              buildWhen: (previous, current) =>
                  previous.messages != current.messages ||
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

  void dialogDeleted(BuildContext context) => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(S.of(context).title_dialog_delete),
          content: Text(S.of(context).content_dialog_delete),
          actions: [
            TextButton(
              onPressed: () {
                context.read<HomeCubit>().removeAllMessage();
                final snackBar = SnackBar(
                  content: Text(S.of(context).snack_bar_delete_messages),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.pop(context);
              },
              child: Text(S.of(context).common_yes),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(S.of(context).common_no),
            ),
          ],
        ),
      );
}
