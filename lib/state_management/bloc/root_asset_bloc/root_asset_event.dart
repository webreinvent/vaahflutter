part of 'root_asset_bloc.dart';

abstract class RootAssetEvent extends Equatable {
  const RootAssetEvent();

  @override
  List<Object?> get props => [];
}

class LoadUser extends RootAssetEvent {}

class UpdateUser extends RootAssetEvent {
  final User? user;

  const UpdateUser(this.user);

  @override
  List<Object?> get props => [user];
}
