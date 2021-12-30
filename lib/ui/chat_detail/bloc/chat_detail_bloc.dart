import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_chat/data/repository/authentication_repository.dart';
import 'package:bloc_chat/data/repository/chat_repository.dart';
import 'package:bloc_chat/util/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:sendbird_sdk/core/channel/base/base_channel.dart';
import 'package:sendbird_sdk/core/channel/group/group_channel.dart';
import 'package:sendbird_sdk/core/message/base_message.dart';
import 'package:sendbird_sdk/handlers/channel_event_handler.dart';

part 'chat_detail_event.dart';

part 'chat_detail_state.dart';

class ChatDetailBloc extends Bloc<ChatDetailEvent, ChatDetailState>
    with ChannelEventHandler {
  final ChatRepository _repository;
  final GroupChannel group;

  ChatDetailBloc({
    required ChatRepository repository,
    required this.group,
  })  : _repository = repository,
        super(ChatDetailState.initState) {
    on<LoadAllMessageRequested>(_loadAllMessage);
    on<NewMessageReceived>(_newMessageReceived);
    sendbird.addChannelEventHandler(
      SendbirdConstants.textIdentifierChatDetail,
      this,
    );
    add(LoadAllMessageRequested());
  }

  Future<List<BaseMessage>?> _loadAllMessage(
    LoadAllMessageRequested event,
    Emitter<ChatDetailState> emit,
  ) async {
    final result = await _repository.loadAllMessage(group);
    if (result != null) {
      emit(state.copyWith(
        listMessage: result,
        status: ChatDetailStatus.chatLoadSuccess,
      ));
      return result;
    } else {
      emit(
        state.copyWith(status: ChatDetailStatus.chatLoadFailure),
      );
    }

    return null;
  }

  void _newMessageReceived(
    NewMessageReceived event,
    Emitter<ChatDetailState> emit,
  ) {
    if (group.channelUrl == event.channel.channelUrl) {
      print(event.message.message);
      var newList = [...state.listMessage]..insert(0, event.message);
      emit(state.copyWith(
        listMessage: newList,
        status: ChatDetailStatus.newMessageReceived,
      ));
    }
  }

  @override
  void onMessageReceived(BaseChannel channel, BaseMessage message) =>
      add(NewMessageReceived(
        channel: channel,
        message: message,
      ));

  @override
  Future<void> close() async {
    sendbird.removeChannelEventHandler(
      SendbirdConstants.textIdentifierChatDetail,
    );
    super.close();
  }
}
