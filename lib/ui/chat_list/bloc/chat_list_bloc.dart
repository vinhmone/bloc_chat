import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_chat/data/repository/chat_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:sendbird_sdk/core/channel/base/base_channel.dart';
import 'package:sendbird_sdk/core/channel/group/group_channel.dart';
import 'package:sendbird_sdk/core/message/base_message.dart';
import 'package:sendbird_sdk/core/models/user.dart' as sendbird_user;
import 'package:sendbird_sdk/handlers/channel_event_handler.dart';

part 'chat_list_event.dart';

part 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState>
    with ChannelEventHandler {
  final ChatRepository _repository;

  ChatListBloc({required ChatRepository repository})
      : _repository = repository,
        super(ChatListState.initState) {
    on<LoadChatListRequested>(_loadChatList);
  }

  Future _loadChatList(
    LoadChatListRequested event,
    Emitter<ChatListState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          status: ChatListStatus.chatListReloading,
        ),
      );
      List<GroupChannel> groups =
          await _repository.loadChatList(reload: event.reload);
      emit(
        state.copyWith(
          groups: groups,
          status: ChatListStatus.chatListLoaded,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ChatListStatus.chatListLoadFailed,
        ),
      );
    }
  }

  @override
  void onChannelChanged(BaseChannel channel) {

  }

  @override
  void onReadReceiptUpdated(GroupChannel channel) {
    super.onReadReceiptUpdated(channel);
  }

  @override
  void onMessageReceived(BaseChannel channel, BaseMessage message) {}

  @override
  void onUserLeaved(GroupChannel channel, sendbird_user.User user) {}
}
