import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:my_chat_gpt/src/app.dart';
import 'package:my_chat_gpt/src/bloc_observer.dart';
import 'package:my_chat_gpt/src/services/user_prefs.dart';

final logger = Logger(printer: PrettyPrinter());

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Future.wait([
      UserPrefs.instance.initialize(),
    ]);

    Bloc.observer = XBlocObserver();
    runApp(const MyApp());
  }, (error, stack) {
    logger.e(error.toString());
  });
}
