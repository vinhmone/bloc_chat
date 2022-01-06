part of 'chat_detail_bloc.dart';

abstract class ChatDetailEvent extends Equatable {
  const ChatDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllMessageRequested extends ChatDetailEvent {}

class SendTextMessageRequested extends ChatDetailEvent {
  final UserMessage message;

  const SendTextMessageRequested({required this.message});
}

class SendFileMessageRequested extends ChatDetailEvent {
  final FileMessage message;

  const SendFileMessageRequested({required this.message});
}

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

class UpdateGroupChat extends ChatDetailEvent {
  final BaseChannel channel;
  final File? file;
  final String? name;

  const UpdateGroupChat({
    required this.channel,
    this.file,
    this.name,
  });

  @override
  List<Object?> get props => [channel, file, name];
}
