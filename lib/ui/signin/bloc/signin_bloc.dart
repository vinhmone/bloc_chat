import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_chat/data/repository/authentication_repository.dart';
import 'package:bloc_chat/util/constants.dart';
import 'package:equatable/equatable.dart';

part 'signin_event.dart';

part 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  final AuthenticationRepository _repository;

  SigninBloc({required AuthenticationRepository repository})
      : _repository = repository,
        super(SigninState.initState) {
    on<EmailChanged>(_emailChanged);
    on<PasswordChanged>(_passwordChanged);
    on<LoginWithEmailRequested>(_loginWithEmailRequested);
  }

  void _emailChanged(EmailChanged event, Emitter<SigninState> emit) {
    if (event.email.isEmpty) {
      emit(state.copyWith(
          email: '',
          status: SigninStatus.emailIsEmpty,
          message: SignInConstants.emailIsEmpty));
    } else {
      if (_validateEmail(event.email)) {
        emit(state.copyWith(
            email: event.email,
            status: SigninStatus.emailIsValid,
            message: null));
      } else {
        emit(state.copyWith(
            email: event.email,
            status: SigninStatus.emailNotValid,
            message: SignInConstants.emailNotValid));
      }
    }
  }

  void _passwordChanged(PasswordChanged event, Emitter<SigninState> emit) {
    if (event.password.isEmpty) {
      emit(state.copyWith(
          password: '',
          status: SigninStatus.passwordIsEmpty,
          message: SignInConstants.passwordIsEmpty));
    } else {
      if (_validatePassword(event.password)) {
        emit(state.copyWith(
            password: event.password,
            status: SigninStatus.passwordIsValid,
            message: null));
      } else {
        emit(state.copyWith(
            password: event.password,
            status: SigninStatus.passwordNotValid,
            message: SignInConstants.passwordNotValid));
      }
    }
  }

  Future _loginWithEmailRequested(
      LoginWithEmailRequested event, Emitter<SigninState> emit) async {
    if (_validateEmail(state.email) && _validatePassword(state.password)) {
      emit(state.copyWith(
          email: state.email,
          password: state.password,
          status: SigninStatus.submissionInProgress,
          message: SignInConstants.submissionInProgress));
      try {
        await _repository.signinToFirebase(
            email: state.email, password: state.password);
        emit(state.copyWith(
          status: SigninStatus.submissionSuccess,
          message: '${AppConstants.signinSuccess} + ${state.email}',
        ));
      } on String catch (e) {
        emit(state.copyWith(
          status: SigninStatus.submissionFailure,
          message: e,
        ));
      } catch (_) {
        emit(state.copyWith(status: SigninStatus.submissionFailure));
      }
    }
  }

  bool _validateEmail(String email) => RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);

  bool _validatePassword(String password) => (password.length > 7);
}
