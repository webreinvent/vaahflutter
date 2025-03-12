import 'package:flutter/material.dart';

import '../../state_management/bloc/app_config.dart';
import '../../state_management/bloc/base_bloc/base_bloc.dart';

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
