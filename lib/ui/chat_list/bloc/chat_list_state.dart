part of 'chat_list_bloc.dart';

enum ChatListStatus {
  initState,
  chatListReloading,
  chatListLoaded,
  chatListLoadFailed,
  //TODO delete chat
}

class ChatListState extends Equatable {
  final List<GroupChannel> groups;
  final ChatListStatus status;
  final String? message;

  const ChatListState({
    required this.groups,
    required this.status,
    this.message,
  });

  ChatListState copyWith({
    List<GroupChannel>? groups,
    ChatListStatus? status,
    String? message,
  }) {
    return ChatListState(
      groups: groups ?? this.groups,
      status: status ?? this.status,
      message: message,
    );
  }

  static const initState = ChatListState(
    groups: [],
    status: ChatListStatus.initState,
  );

  @override
  List<Object?> get props => [groups, status, message];
}
