part of 'env_bloc.dart';

abstract class EnvBlocEvent extends Equatable {
  const EnvBlocEvent();

  @override
  List<Object?> get props => [];
}

/// Event to Load Environment on Startup
class LoadEnvironment extends EnvBlocEvent {}
