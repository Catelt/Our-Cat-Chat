import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_gpt/src/constants/app_language.dart';
import 'package:my_chat_gpt/src/constants/app_sizes.dart';
import 'package:my_chat_gpt/src/feature/settings/logic/settings_cubit.dart';
import 'package:my_chat_gpt/src/localization/localization_utils.dart';
import 'package:my_chat_gpt/src/network/model/language.dart';

class BottomSelectLanguage extends StatelessWidget {
  const BottomSelectLanguage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (previous, current) => previous.language != current.language,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                S.of(context).title_bottom_select_language,
                style: const TextStyle(fontSize: 18),
              ),
              Gaps.h12,
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final item = AppLanguage.languages[index];
                  return itemLanguage(item,
                      isSelect: item.code == state.language.code, onTap: () {
                    context.read<SettingsCubit>().onChangeLanguage(item);
                    Navigator.pop(context);
                  });
                },
                itemCount: AppLanguage.languages.length,
                separatorBuilder: (context, index) {
                  return SizedBox(
                    width: double.infinity,
                    child: Divider(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      height: 2,
                    ),
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }

  Widget itemLanguage(XLanguage item,
      {bool isSelect = false, void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Sizes.p12),
        child: Row(children: [
          Image.asset(
            item.icon,
            height: 24,
            width: 28,
          ),
          Gaps.w8,
          Text(
            item.name,
            style: const TextStyle(fontSize: Sizes.p16),
          ),
          const Spacer(),
          if (isSelect) const Icon(Icons.check)
        ]),
      ),
    );
  }
}
