part of 'chat_detail_bloc.dart';

enum ChatDetailStatus {
  initState,
  chatLoadInProgress,
  chatLoadSuccess,
  chatLoadFailure,
  messageEditing,
  messageSendInProgress,
  messageSendSuccess,
  messageSendFailure,
  messageDeleted,
  messageReceiptedUpdated,
  newMessageReceived,
  updateChannelInProgress,
  updateChannelSuccess,
  updateChannelFailure,
  leaveChannelInProgress,
  leaveChannelSuccess,
  leaveChannelFailure,
}

class ChatDetailState extends Equatable {
  final List<BaseMessage> listMessage;
  final ChatDetailStatus status;
  final String? message;

  const ChatDetailState({
    required this.listMessage,
    required this.status,
    this.message,
  });

  static const initState = ChatDetailState(
    listMessage: [],
    status: ChatDetailStatus.initState,
  );

  ChatDetailState copyWith({
    GroupChannel? groupChannel,
    List<BaseMessage>? listMessage,
    ChatDetailStatus? status,
    String? message,
  }) {
    return ChatDetailState(
      listMessage: listMessage ?? this.listMessage,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        listMessage,
        status,
        message,
      ];
}
