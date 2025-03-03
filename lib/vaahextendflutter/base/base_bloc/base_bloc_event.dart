part of 'base_bloc.dart';

abstract class BaseBlocEvent {}

class InitializeApp extends BaseBlocEvent {
  final Widget app;
  final Widget errorApp;
  final FirebaseOptions? firebaseOptions;

  InitializeApp({
    required this.app,
    required this.errorApp,
    this.firebaseOptions,
  });
}
