import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_chat/data/repository/authentication_repository.dart';
import 'package:bloc_chat/data/repository/chat_repository.dart';
import 'package:bloc_chat/util/constants.dart';
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
    sendbird.addChannelEventHandler(
      SendbirdConstants.textIdentifierChatList,
      this,
    );
    on<LoadChatListRequested>(_loadChatList);
    on<MessageReceived>(_onMessageReceived);
  }

  bool get hasNext => _repository.hasNext;

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
  void onChannelChanged(BaseChannel channel) {}

  @override
  void onReadReceiptUpdated(GroupChannel channel) {
    super.onReadReceiptUpdated(channel);
  }

  @override
  void onMessageReceived(BaseChannel channel, BaseMessage message) {
    if (channel is! GroupChannel) return;

    List<GroupChannel> newGroups = state.groups;
    final index =
        newGroups.indexWhere((group) => group.channelUrl == channel.channelUrl);
    if (index != -1) {
      newGroups.removeAt(index);
    }
    // channel.dirty = true;
    newGroups.insert(0, channel);
    add(MessageReceived(groups: newGroups));
  }

  @override
  void onUserLeaved(GroupChannel channel, sendbird_user.User user) {}

  void _onMessageReceived(MessageReceived event, Emitter<ChatListState> emit) {
    emit(state.copyWith(
      message: null,
    ));
    emit(state.copyWith(
      groups: event.groups,
      status: ChatListStatus.onMessageReceived,
      message: AppConstants.textReceivedNewMessage,
    ));
  }

  @override
  Future<void> close() async {
    sendbird
        .removeChannelEventHandler(SendbirdConstants.textIdentifierChatList);
    super.close();
  }
}
