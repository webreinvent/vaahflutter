import 'package:flutter/material.dart';

import 'app_config.dart';
import 'vaahextendflutter/base/base_bloc/base_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize the app's with core features
  BaseBloc.instance.add(
    InitializeApp(
      app: AppConfig(),
      errorApp: const ErrorAppConfig(),
    ),
  );

  runApp(AppLauncher());
}
