part of 'signup_bloc.dart';

enum SignupStatus {
  initState,
  emailIsEmpty,
  passwordIsEmpty,
  usernameIsEmpty,
  emailNotValid,
  passwordNotValid,
  emailIsValid,
  passwordIsValid,
  usernameIsValid,
  submissionInProgress,
  submissionSuccess,
  submissionFailure,
}

class SignupState extends Equatable {
  final String username;
  final String email;
  final String password;
  final SignupStatus status;
  final String? message;

  const SignupState(
      {required this.username,
      required this.email,
      required this.password,
      required this.status,
      this.message});

  SignupState copyWith({
    String? username,
    String? email,
    String? password,
    SignupStatus? status,
    String? message,
  }) {
    return SignupState(
        username: username ?? this.username,
        email: email ?? this.email,
        password: password ?? this.password,
        status: status ?? this.status,
        message: message);
  }

  static const initState = SignupState(
    username: '',
    email: '',
    password: '',
    status: SignupStatus.initState,
  );

  @override
  List<Object?> get props => [username, email, password, status, message];
}
