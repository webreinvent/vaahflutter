import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_storage/get_storage.dart';

import '../../../models/user.dart';

part 'root_asset_event.dart';
part 'root_asset_state.dart';

const String userKey = 'user';

class RootAssetBloc extends Bloc<RootAssetEvent, RootAssetBlocState> {
  RootAssetBloc._() : super(RootAssetInitial()) {
    on<LoadUser>(_onLoadUser);
    on<UpdateUser>(_onUpdateUser);
  }

  static final RootAssetBloc _instance = RootAssetBloc._();

  static RootAssetBloc get instance => _instance;

  final GetStorage _storage = GetStorage();

  Future<void> _onLoadUser(
    LoadUser event,
    Emitter<RootAssetBlocState> emit,
  ) async {
    try {
      final rawUser = _storage.read<String>(userKey);

      if (rawUser == null || rawUser.isEmpty) {
        emit(RootAssetLoaded(null));
        return;
      }

      final user = User.fromJson(jsonDecode(rawUser));
      emit(RootAssetLoaded(user));
    } catch (e) {
      emit(RootAssetError("Failed to load user: ${e.toString()}"));
    }
  }

  Future<void> _onUpdateUser(
    UpdateUser event,
    Emitter<RootAssetBlocState> emit,
  ) async {
    try {
      if (event.user != null) {
        await _storage.write(
          userKey,
          jsonEncode(
            event.user!.toJson(),
          ),
        );
      }
      emit(RootAssetLoaded(event.user));
    } catch (e) {
      emit(RootAssetError("Failed to update user: ${e.toString()}"));
    }
  }
}
