import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_gpt/src/constants/app_sizes.dart';
import 'package:my_chat_gpt/src/feature/home/logic/home_cubit.dart';
import 'package:my_chat_gpt/src/feature/settings/logic/settings_cubit.dart';
import 'package:my_chat_gpt/src/feature/settings/view/dialog_select_theme.dart';
import 'package:my_chat_gpt/src/localization/localization_utils.dart';
import 'package:my_chat_gpt/src/feature/settings/view/bottom_select_language.dart';
import 'package:my_chat_gpt/src/utils/theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: Text(
          S.of(context).title_setting_appbar,
          style: const TextStyle(fontSize: Sizes.p20),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.p12),
          child: Column(children: [
            themeSection(),
            Gaps.h8,
            languageSection(),
            Gaps.h16,
            SizedBox(
              width: double.infinity,
              height: Sizes.p48,
              child: ElevatedButton(
                  onPressed: () {
                    dialogDeleted(context);
                  },
                  child: Text(S.of(context).button_delete_messages)),
            )
          ]),
        ),
      ),
    );
  }

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
          ));

  Widget themeSection() => BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (previous, current) => previous.theme != current.theme,
        builder: (context, state) {
          return InkWell(
            onTap: () async {
              await showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  content: DialogSelectTheme(
                      selected: state.theme.index,
                      onSelected: context.read<SettingsCubit>().onChangeTheme),
                ),
              );
            },
            child: settingSection(
              title: S.text.theme,
              icon: Icons.contrast,
              rightWidget: Text(
                state.theme.getTitle,
                style: TextStyle(
                    fontSize: Sizes.p16,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      );

  Widget languageSection() => BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (previous, current) => previous.language != current.language,
        builder: (context, state) {
          return InkWell(
            onTap: () async {
              await showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return BlocProvider.value(
                      value: context.read<HomeCubit>(),
                      child: const BottomSelectLanguage(),
                    );
                  });
            },
            child: settingSection(
              title: S.of(context).language,
              icon: Icons.language_outlined,
              rightWidget: Text(
                state.language.name,
                style: TextStyle(
                    fontSize: Sizes.p16,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      );

  Widget settingSection(
          {required String title,
          required IconData icon,
          required Widget rightWidget}) =>
      Container(
        height: Sizes.p64,
        padding: const EdgeInsets.symmetric(horizontal: Sizes.p12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Sizes.p12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: Sizes.p32,
            ),
            Gaps.w12,
            Text(
              title,
              style: const TextStyle(fontSize: Sizes.p16),
            ),
            const Spacer(),
            rightWidget
          ],
        ),
      );
}
