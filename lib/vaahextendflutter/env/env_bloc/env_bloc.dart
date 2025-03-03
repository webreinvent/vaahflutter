import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

import '../../services/logging_library/logging_library.dart';
import '../env.dart';

part 'env_event.dart';
part 'env_state.dart';

class EnvBloc extends Bloc<EnvBlocEvent, EnvBlocState> {
  EnvironmentConfig _config = EnvironmentConfig.defaultConfig();

  EnvBloc._() : super(EnvInitial()) {
    on<LoadEnvironment>(_onLoadEnvironment);
  }

  static final EnvBloc _instance = EnvBloc._();

  static EnvBloc get instance => _instance;

  /// Get current configuration
  EnvironmentConfig get config => _config;

  /// Load Environment from ENV_PATH
  Future<void> _onLoadEnvironment(
    LoadEnvironment event,
    Emitter<EnvBlocState> emit,
  ) async {
    emit(EnvLoading());

    try {
      const String envPath = String.fromEnvironment("ENV_PATH");
      if (envPath.isEmpty) {
        Log.warning("INVALID ENVIRONMENT PATH");
        emit(EnvError("Invalid environment path."));
        return;
      }

      final String jsonConfig = await rootBundle.loadString(envPath);

      if (jsonConfig.isNotEmpty) {
        final Map<String, dynamic> json = jsonDecode(jsonConfig);
        _config = EnvironmentConfig.fromJson(json);
        emit(EnvLoaded(_config));
        Log.success(
          "ENVIRONMENT PATH: $envPath",
          disableCloudLogging: true,
        );
      } else {
        throw Exception('Environment configuration not found for key: $envPath');
      }
    } catch (error, stackTrace) {
      Log.exception(
        "error-occured-while-initializing-env-bloc",
        throwable: error,
        stackTrace: stackTrace,
        hint: "Ensure ENV_PATH is set and contains valid JSON.",
      );
      emit(EnvError("Failed to load environment: ${error.toString()}"));
      exit(0); // Exit the app as in the original code
    }
  }
}
