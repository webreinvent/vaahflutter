part of 'base_bloc.dart';

abstract class BaseBlocState extends Equatable {
  const BaseBlocState();
  @override
  List<Object?> get props => [];
}

class BaseBlocInitial extends BaseBlocState {}

class BaseBlocLoading extends BaseBlocState {}

class BaseBlocLoaded extends BaseBlocState {
  final Widget app;

  const BaseBlocLoaded({
    required this.app,
  });

  @override
  List<Object?> get props => [app];
}

class BaseBlocError extends BaseBlocState {
  final Widget errorApp;
  final String errorMessage;

  const BaseBlocError({
    required this.errorApp,
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [errorApp, errorMessage];
}
