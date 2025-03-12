import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../bloc/env_bloc/env_bloc.dart';
import '../../bloc/root_asset_bloc/root_asset_bloc.dart';
import '../../bloc/services/api.dart';
import '../../bloc/services/logging_library.dart';
import '../../bloc/services/notification/internal/notification.dart';
import '../../bloc/services/notification/push/notification.dart';

import '../../../vaahextendflutter/app_theme.dart';

part 'base_bloc_event.dart';
part 'base_bloc_state.dart';

class BaseBloc extends Bloc<BaseBlocEvent, BaseBlocState> {
  BaseBloc._() : super(BaseBlocInitial()) {
    on<InitializeApp>(_handleAppInitialization);
  }

  static final BaseBloc _instance = BaseBloc._();

  static BaseBloc get instance => _instance;

  Future<void> _initializeStorage() async {
    await GetStorage.init();
  }

  void _initializeEnvironment() {
    EnvBloc.instance.add(LoadEnvironment());
  }

  void _initializeServices() {
    AppTheme.init();
    Api.init();
  }

  void _loadUserFromStorage() {
    RootAssetBloc.instance.add(LoadUser());
  }

  Future<void> _initializeNotifications() async {
    await PushNotifications.init();
    await InternalNotifications.init();
    PushNotifications.askPermission();
  }

  Future<void> _handleAppInitialization(
    InitializeApp event,
    Emitter<BaseBlocState> emit,
  ) async {
    emit(BaseBlocLoading());

    try {
      await _initializeStorage();

      _initializeEnvironment();

      // Todo : Depends on datadog implementation PR
      // Initialization of Firebase and Services
      // if (firebaseOptions != null) {
      //   await Firebase.initializeApp(
      //     options: firebaseOptions,
      //   );
      // }

      _initializeServices();

      _loadUserFromStorage();

      _initializeNotifications();

      // Todo : Initialization of Logging Services will be added once Datadog PR proceed
      // Todo : it will return a Widget which will be passed in BaseBlocLoaded State
      // Todo : Do not remove the below code
      // Sentry Initialization (And/ Or) Running main app
      // if (null != config.sentryConfig && config.sentryConfig!.dsn.isNotEmpty) {
      //   await SentryFlutter.init(
      //     (options) => options
      //       ..dsn = config.sentryConfig!.dsn
      //       ..autoAppStart = config.sentryConfig!.autoAppStart
      //       ..tracesSampleRate = config.sentryConfig!.tracesSampleRate
      //       ..enableAutoPerformanceTracing = config.sentryConfig!.enableAutoPerformanceTracing
      //       ..enableUserInteractionTracing = config.sentryConfig!.enableUserInteractionTracing
      //       ..environment = config.envType,
      //   );
      //   Widget child = event.app;
      //   if (config.sentryConfig!.enableUserInteractionTracing) {
      //     child = SentryUserInteractionWidget(
      //       child: child,
      //     );
      //   }
      //   if (config.sentryConfig!.enableAssetsInstrumentation) {
      //     child = DefaultAssetBundle(
      //       bundle: SentryAssetBundle(
      //         enableStructuredDataTracing: true,
      //       ),
      //       child: child,
      //     );
      //   }
      //   // Running main app
      //   runApp(child);
      // } else {
      //   // Running main app when sentry config is not there
      //   runApp(app);
      // }

      emit(
        BaseBlocLoaded(app: event.app),
      );
    } catch (e, stackTrace) {
      emit(
        BaseBlocError(
          errorApp: event.errorApp,
          errorMessage: e.toString(),
        ),
      );

      // Logs an error to LoggingService[Sentry || datadog || firebase] opted by user
      // This will log to the remote as well as local based on your ENV config
      Log.exception(
        e.toString(),
        stackTrace: stackTrace,
      );
    }
  }
}
