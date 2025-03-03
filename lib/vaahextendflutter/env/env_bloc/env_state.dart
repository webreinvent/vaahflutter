part of 'env_bloc.dart';

abstract class EnvBlocState extends Equatable {
  const EnvBlocState();

  @override
  List<Object?> get props => [];
}

class EnvInitial extends EnvBlocState {}

class EnvLoading extends EnvBlocState {}

class EnvLoaded extends EnvBlocState {
  final EnvironmentConfig config;

  const EnvLoaded(this.config);

  @override
  List<Object?> get props => [config];
}

class EnvError extends EnvBlocState {
  final String message;

  const EnvError(this.message);

  @override
  List<Object?> get props => [message];
}
