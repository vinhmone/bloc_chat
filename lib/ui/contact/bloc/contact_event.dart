part of 'contact_bloc.dart';

abstract class ContactEvent extends Equatable {
  const ContactEvent();

  @override
  List<Object> get props => [];
}

class LoadAllContact extends ContactEvent {}

class CreateNewChat extends ContactEvent {
  final List<User> users;

  const CreateNewChat({required this.users});

  @override
  List<Object> get props => [users];
}