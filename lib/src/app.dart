import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logger/logger.dart';
import 'package:my_chat_gpt/src/constants/color.dart';
import 'package:my_chat_gpt/src/feature/home/home_page.dart';
import 'package:my_chat_gpt/src/feature/home/logic/home_cubit.dart';
import 'package:my_chat_gpt/src/feature/settings/logic/settings_cubit.dart';
import 'package:my_chat_gpt/src/localization/localization_utils.dart';
import 'package:my_chat_gpt/src/network/domain_manager.dart';

final Logger log = Logger();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => DomainManager(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeCubit(context.read<DomainManager>()),
          ),
          BlocProvider(
            create: (context) => SettingsCubit(),
          ),
        ],
        child: BlocBuilder<SettingsCubit, SettingsState>(
          buildWhen: (previous, current) =>
              previous.theme != current.theme ||
              previous.language != current.language,
          builder: (context, state) {
            return MaterialApp(
              navigatorKey: S.navigatorKey,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              locale: Locale.fromSubtags(languageCode: state.language.code),
              supportedLocales: const [Locale('en', ''), Locale('vi', '')],
              onGenerateTitle: (BuildContext context) =>
                  S.of(context).common_appTitle,
              theme: ThemeData(
                  useMaterial3: true, colorSchemeSeed: XColor.primary),
              darkTheme: ThemeData(
                  useMaterial3: true,
                  colorSchemeSeed: XColor.primary,
                  brightness: Brightness.dark),
              themeMode: state.theme,
              home: const HomePage(),
            );
          },
        ),
      ),
    );
  }
}
