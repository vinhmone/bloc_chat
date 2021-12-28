part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class SigninToSendbirdRequested extends HomeEvent {
  const SigninToSendbirdRequested();

  @override
  List<Object> get props => [];
}
