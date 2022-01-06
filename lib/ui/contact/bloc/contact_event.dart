part of 'contact_bloc.dart';

abstract class ContactEvent extends Equatable {
  const ContactEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllContact extends ContactEvent {}

class CreateNewChat extends ContactEvent {
  final List<User> users;
  final String? name;

  const CreateNewChat({required this.users, this.name});

  @override
  List<Object?> get props => [users, name];
}

class SendPrivateChat extends ContactEvent {
  final User user;

  const SendPrivateChat({required this.user});

  @override
  List<Object?> get props => [user];
}
