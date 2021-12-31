part of 'chat_list_bloc.dart';

abstract class ChatListEvent extends Equatable {
  const ChatListEvent();

  @override
  List<Object?> get props => [];
}

class LoadChatListRequested extends ChatListEvent {
  final bool reload;

   const LoadChatListRequested({required this.reload});

  @override
  List<Object?> get props => [reload];
}

class ChatListChanged extends ChatListEvent {
  final BaseChannel channel;

  const ChatListChanged({required this.channel});
  @override
  List<Object?> get props => [channel];
}

class ReadReceiptUpdated extends ChatListEvent {}

class MessageReceived extends ChatListEvent {
  final List<GroupChannel> groups;

  const MessageReceived({required this.groups});

  @override
  List<Object> get props => groups;
}

class UserLeaved extends ChatListEvent {}
