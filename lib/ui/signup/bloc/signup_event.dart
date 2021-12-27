part of 'signup_bloc.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

class UsernameChanged extends SignupEvent {
  final String username;

  const UsernameChanged({required this.username});

  @override
  List<Object> get props => [username];
}

class EmailChanged extends SignupEvent {
  final String email;

  const EmailChanged({required this.email});

  @override
  List<Object> get props => [email];
}

class PasswordChanged extends SignupEvent {
  final String password;

  const PasswordChanged({required this.password});

  @override
  List<Object> get props => [password];
}

class SignupWithEmailRequested extends SignupEvent {}
