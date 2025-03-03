import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'routes/middleware.dart';
import 'vaahextendflutter/app_theme.dart';
import 'vaahextendflutter/base/base_bloc/base_bloc.dart';
import 'vaahextendflutter/env/env_bloc/env_bloc.dart';
import 'vaahextendflutter/helpers/constants.dart';
import 'vaahextendflutter/widgets/debug.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class AppLauncher extends StatelessWidget {
  const AppLauncher({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BaseBloc, BaseBlocState>(
      bloc: BaseBloc.instance,
      buildWhen: (previous, current) {
        if (previous is BaseBlocLoaded && current is BaseBlocLoaded) {
          return previous.app != current.app;
        }
        return current is BaseBlocLoaded || current is BaseBlocError;
      },
      builder: (context, state) {
        if (state is BaseBlocInitial) {
          return _initialStateView();
        } else if (state is BaseBlocLoading) {
          return _loadingStateView();
        } else if (state is BaseBlocLoaded) {
          return state.app;
        } else if (state is BaseBlocError) {
          return state.errorApp;
        }
        return ErrorAppConfig();
      },
    );
  }

  Widget _initialStateView() {
    return Center(
      child: Column(
        children: [
          Text(
            'Initial state of Base Bloc',
          ),
          verticalMargin4,
          ElevatedButton(
            onPressed: () => BaseBloc.instance.add(
              InitializeApp(
                app: AppConfig(),
                errorApp: ErrorAppConfig(),
              ),
            ),
            child: Text('Tap to load'),
          )
        ],
      ),
    );
  }

  Widget _loadingStateView() {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: CupertinoActivityIndicator(),
        ),
      ),
    );
  }
}

class AppConfig extends StatelessWidget {
  const AppConfig({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: EnvBloc.instance.config.appTitle,
      theme: ThemeData(
        primarySwatch: AppTheme.colors['primary'],
      ),
      navigatorObservers: [
        SentryNavigatorObserver(),
      ],
      onGenerateRoute: routeMiddleware,
      builder: (BuildContext context, Widget? child) {
        return DebugWidget(
          navigatorKey: navigatorKey,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}

class ErrorAppConfig extends StatelessWidget {
  const ErrorAppConfig({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: AppTheme.colors['primary'],
      ),
      home: Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text('Something Went Wrong!'),
        ),
      ),
    );
  }
}
