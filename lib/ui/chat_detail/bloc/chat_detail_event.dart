part of 'chat_detail_bloc.dart';

abstract class ChatDetailEvent extends Equatable {
  const ChatDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadAllMessageRequested extends ChatDetailEvent {}

class SendTextMessageRequested extends ChatDetailEvent {}

class SendFileMessageRequested extends ChatDetailEvent {}

class DeleteMessageRequested extends ChatDetailEvent {}

class NewMessageReceived extends ChatDetailEvent {
  final BaseChannel channel;
  final BaseMessage message;

  const NewMessageReceived({
    required this.channel,
    required this.message,
  });

  @override
  List<Object> get props => [channel, message];
}

class ReadReceiptedUpdated extends ChatDetailEvent {}

class LeaveChatRequested extends ChatDetailEvent {}

class NewUserJoined extends ChatDetailEvent {}

class UserLeaved extends ChatDetailEvent {}
