part of 'contact_bloc.dart';

enum ContactStatus {
  initState,
  loadContactInProgress,
  loadContactSuccess,
  loadContactFailure,
  createNewChatInProgress,
  createNewChatSuccess,
  createNewChatFailure,
}

class ContactState extends Equatable {
  final List<User> users;
  final BaseChannel? channel;
  final ContactStatus status;
  final String? message;

  const ContactState({
    required this.users,
    this.channel,
    required this.status,
    this.message,
  });

  ContactState copyWith({
    List<User>? users,
    BaseChannel? channel,
    ContactStatus? status,
    String? message,
  }) {
    return ContactState(
      users: users ?? this.users,
      channel: channel,
      status: status ?? this.status,
      message: message,
    );
  }

  static const initState = ContactState(
    users: [],
    status: ContactStatus.initState,
  );

  @override
  List<Object?> get props => [users, channel, status, message];
}
