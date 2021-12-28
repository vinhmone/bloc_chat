import 'package:bloc/bloc.dart';
import 'package:bloc_chat/data/repository/authentication_repository.dart';
import 'package:bloc_chat/util/constants.dart';
import 'package:equatable/equatable.dart';

part 'signup_event.dart';

part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthenticationRepository _repository;

  SignupBloc({required AuthenticationRepository repository})
      : _repository = repository,
        super(SignupState.initState) {
    on<UsernameChanged>(_usernameChange);
    on<EmailChanged>(_emailChanged);
    on<PasswordChanged>(_passwordChanged);
    on<SignupWithEmailRequested>(_signupWithEmailRequested);
  }

  void _usernameChange(UsernameChanged event, Emitter<SignupState> emit) {
    if (event.username.isEmpty) {
      emit(state.copyWith(
        username: '',
        status: SignupStatus.usernameIsEmpty,
        message: SignupConstants.usernameIsEmpty,
      ));
    } else {
      emit(state.copyWith(
        username: event.username,
        status: SignupStatus.usernameIsValid,
        message: null,
      ));
    }
  }

  void _emailChanged(EmailChanged event, Emitter<SignupState> emit) {
    if (event.email.isEmpty) {
      emit(state.copyWith(
          email: '',
          status: SignupStatus.emailIsEmpty,
          message: SignInConstants.emailIsEmpty));
    } else {
      if (_validateEmail(event.email)) {
        emit(state.copyWith(
            email: event.email,
            status: SignupStatus.emailIsValid,
            message: null));
      } else {
        emit(state.copyWith(
            email: event.email,
            status: SignupStatus.emailNotValid,
            message: SignInConstants.emailNotValid));
      }
    }
  }

  void _passwordChanged(PasswordChanged event, Emitter<SignupState> emit) {
    if (event.password.isEmpty) {
      emit(state.copyWith(
          password: '',
          status: SignupStatus.passwordIsEmpty,
          message: SignInConstants.passwordIsEmpty));
    } else {
      if (_validatePassword(event.password)) {
        emit(state.copyWith(
            password: event.password,
            status: SignupStatus.passwordIsValid,
            message: null));
      } else {
        emit(state.copyWith(
            password: event.password,
            status: SignupStatus.passwordNotValid,
            message: SignInConstants.passwordNotValid));
      }
    }
  }

  Future _signupWithEmailRequested(
      SignupWithEmailRequested event, Emitter<SignupState> emit) async {
    if (_validateEmail(state.email) && _validatePassword(state.password)) {
      emit(state.copyWith(
          email: state.email,
          password: state.password,
          status: SignupStatus.submissionInProgress,
          message: SignupConstants.submissionInProgress));
      try {
        await _repository.signup(
            email: state.email,
            password: state.password,
            username: state.username);
        emit(state.copyWith(
          status: SignupStatus.submissionSuccess,
          message: AppConstants.signupSuccess,
        ));
      } on String catch (e) {
        emit(state.copyWith(
          status: SignupStatus.submissionFailure,
          message: e,
        ));
      } catch (_) {
        emit(state.copyWith(status: SignupStatus.submissionFailure));
      }
    }
  }

  bool _validateEmail(String email) => RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);

  bool _validatePassword(String password) => (password.length > 7);
}
