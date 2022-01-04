import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bloc_chat/data/repository/authentication_repository.dart';
import 'package:bloc_chat/data/repository/chat_repository.dart';
import 'package:bloc_chat/util/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

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
    on<SendTextMessageRequested>(_sendTextMessageRequested);
    on<SendFileMessageRequested>(_sendFileMessageRequested);
    add(LoadAllMessageRequested());
    sendbird.addChannelEventHandler(
      SendbirdConstants.textIdentifierChatDetail,
      this,
    );
  }

  Future<List<BaseMessage>?> _loadAllMessage(
    LoadAllMessageRequested event,
    Emitter<ChatDetailState> emit,
  ) async {
    emit(state.copyWith(
      status: ChatDetailStatus.chatLoadInProgress,
    ));
    await _repository.markChannelAsRead(group);
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
  void onUserLeaved(GroupChannel channel, User user) {}

  @override
  void onReadReceiptUpdated(GroupChannel channel) {
    super.onReadReceiptUpdated(channel);
  }

  Future sendTextMessage(String text) async {
    if (text.isNotEmpty) {
      final message = await _repository.sendTextMessage(
        group,
        text.trim(),
        () => null,
        () => null,
      );
      add(SendTextMessageRequested(message: message));
    }
  }

  void _sendTextMessageRequested(
    SendTextMessageRequested event,
    Emitter<ChatDetailState> emit,
  ) {
    emit(state.copyWith(
      status: ChatDetailStatus.messageSendInProgress,
    ));
    List<BaseMessage> list = state.listMessage;
    list.insert(0, event.message);
    emit(state.copyWith(
      listMessage: list,
      status: ChatDetailStatus.newMessageReceived,
    ));
  }

  Future sendFileMessage(File file) async {
    final message = await _repository.sendFileMessage(
      group,
      file,
      () => add(LoadAllMessageRequested()),
    );
    print('Bloc: ${message.secureUrl}');
    // add(SendFileMessageRequested(message: message));
  }

  void _sendFileMessageRequested(
    SendFileMessageRequested event,
    Emitter<ChatDetailState> emit,
  ) {
    print('SendFileMessageRequested');
    emit(state.copyWith(
      status: ChatDetailStatus.messageSendInProgress,
    ));
    List<BaseMessage> list = state.listMessage;
    list.insert(0, event.message);
    emit(state.copyWith(
      listMessage: list,
      status: ChatDetailStatus.newMessageReceived,
    ));
  }

  @override
  Future<void> close() async {
    sendbird.removeChannelEventHandler(
      SendbirdConstants.textIdentifierChatDetail,
    );
    super.close();
  }
}
