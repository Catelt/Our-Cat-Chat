import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_chat_gpt/src/feature/logic/cubit/home_cubit.dart';
import 'package:my_chat_gpt/src/feature/view/home_page.dart';
import 'package:my_chat_gpt/src/localization/localization_utils.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: BlocBuilder<HomeCubit, HomeState>(
        buildWhen: (previous, current) => previous.language != current.language,
        builder: (context, state) {
          return MaterialApp(
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
            theme:
                ThemeData(useMaterial3: true, colorSchemeSeed: Colors.purple),
            home: HomePage(),
          );
        },
      ),
    );
  }
}
