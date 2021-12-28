import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_chat/data/repository/authentication_repository.dart';
import 'package:bloc_chat/util/constants.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AuthenticationRepository _repository;

  HomeBloc({required AuthenticationRepository repository})
      : _repository = repository,
        super(HomeState.initState) {
    on<SigninToSendbirdRequested>(_signinToSendbirdRequested);
  }

  Future _signinToSendbirdRequested(
      SigninToSendbirdRequested event, Emitter<HomeState> emit) async {
    emit(
      state.copyWith(
        status: HomeStatus.connectInProgress,
      ),
    );
    try {
      await _repository.signinToSendbird();
      emit(state.copyWith(status: HomeStatus.connectSuccess));
    } catch (_) {
      emit(
        state.copyWith(
          status: HomeStatus.connectFailure,
          message: AppConstants.errorAuthSendbird,
        ),
      );
    }
  }
}
