import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bloc_chat/data/repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';

part 'setting_event.dart';

part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final AuthenticationRepository _repository;

  SettingBloc({required AuthenticationRepository repository})
      : _repository = repository,
        super(SettingState.initState) {
    on<UpdateUserRequest>(_updateUser);
    on<SignoutRequest>(_signout);
  }

  void _updateUser(UpdateUserRequest event, Emitter<SettingState> emit) async {
    try {
      emit(state.copyWith(status: SettingStatus.updateUserInProgress));
      await _repository.updateUser(
        name: event.name,
        file: event.file,
      );
      emit(state.copyWith(
        status: SettingStatus.updateUserSuccess,
      ));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(
        status: SettingStatus.updateUserFailure,
      ));
    }
  }

  void _signout(SignoutRequest event, Emitter<SettingState> emit) async {
    try {
      emit(state.copyWith(
        status: SettingStatus.signOutInProgress,
      ));
      await _repository.signout();
      emit(state.copyWith(
        status: SettingStatus.signOutSuccess,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SettingStatus.signOutSuccess,
      ));
    }
  }
}
