part of 'signin_bloc.dart';

enum SigninStatus {
  initState,
  emailIsEmpty,
  passwordIsEmpty,
  emailNotValid,
  passwordNotValid,
  emailIsValid,
  passwordIsValid,
  submissionInProgress,
  submissionSuccess,
  submissionFailure,
}

class SigninState extends Equatable {
  final String email;
  final String password;
  final SigninStatus status;
  final String? message;

  const SigninState(
      {required this.email,
      required this.password,
      this.status = SigninStatus.initState,
      this.message});

  SigninState copyWith(
      {String? email,
      String? password,
      SigninStatus? status,
      String? message}) {
    return SigninState(
        email: email ?? this.email,
        password: password ?? this.password,
        status: status ?? this.status,
        message: message);
  }

  static const initState = SigninState(email: '', password: '');

  @override
  List<Object?> get props => [email, password, status, message];

  @override
  String toString() {
    return 'SigninState{email: $email, password: $password, status: $status, message: $message}';
  }
}
