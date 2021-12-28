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

class ChatListChanged extends ChatListEvent {}

class ReadReceiptUpdated extends ChatListEvent {}

class MessageReceived extends ChatListEvent {}

class UserLeaved extends ChatListEvent {}
