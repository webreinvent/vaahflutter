part of 'root_asset_bloc.dart';

abstract class RootAssetBlocState extends Equatable {
  const RootAssetBlocState();

  @override
  List<Object?> get props => [];
}

class RootAssetInitial extends RootAssetBlocState {}

class RootAssetLoaded extends RootAssetBlocState {
  final User? user;

  const RootAssetLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class RootAssetError extends RootAssetBlocState {
  final String message;

  const RootAssetError(this.message);

  @override
  List<Object?> get props => [message];
}
