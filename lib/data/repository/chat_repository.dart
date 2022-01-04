import 'dart:io';

import 'package:bloc_chat/util/constants.dart';
import 'package:sendbird_sdk/constant/enums.dart';
import 'package:sendbird_sdk/core/channel/base/base_channel.dart';
import 'package:sendbird_sdk/core/channel/group/group_channel.dart';
import 'package:sendbird_sdk/core/message/base_message.dart';
import 'package:sendbird_sdk/core/message/file_message.dart';
import 'package:sendbird_sdk/core/message/user_message.dart';
import 'package:sendbird_sdk/params/file_message_params.dart';
import 'package:sendbird_sdk/params/message_list_params.dart';
import 'package:sendbird_sdk/query/channel_list/group_channel_list_query.dart';

abstract class ChatRepository {
  Future<List<GroupChannel>> loadChatList({bool reload = false});

  bool get hasNext;

  Future<List<BaseMessage>?> loadAllMessage(GroupChannel group);

  Future markChannelAsRead(BaseChannel channel);

  Future<UserMessage> sendTextMessage(
    BaseChannel channel,
    String text,
    Function() success,
    Function() failure,
  );

  Future<FileMessage> sendFileMessage(
    BaseChannel channel,
    File file,
    Function() success,
  );
}

class ChatRepositoryImpl extends ChatRepository {
  GroupChannelListQuery listQuery = GroupChannelListQuery()
    ..limit = 20
    ..order = GroupChannelListOrder.latestLastMessage;

  @override
  bool get hasNext => listQuery.hasNext;

  @override
  Future<List<GroupChannel>> loadChatList({bool reload = false}) async {
    List<GroupChannel> groupChannels = [];
    try {
      if (reload) {
        listQuery = GroupChannelListQuery()
          ..limit = 20
          ..order = GroupChannelListOrder.latestLastMessage;
      }

      final groups = await listQuery.loadNext();
      if (reload) {
        groupChannels = groups;
      } else {
        groupChannels += groups;
      }
      return groupChannels;
    } catch (e) {
      throw AppConstants.errorGetChatList;
    }
  }

  @override
  Future<List<BaseMessage>?> loadAllMessage(GroupChannel group) async {
    final params = MessageListParams()
      ..isInclusive = false
      ..includeThreadInfo = true
      ..reverse = true
      ..previousResultSize = 30;

    return await group.getMessagesByTimestamp(
      DateTime.now().millisecondsSinceEpoch,
      params,
    );
  }

  @override
  Future markChannelAsRead(BaseChannel channel) async {
    if (channel is GroupChannel) channel.markAsRead();
  }

  @override
  Future<UserMessage> sendTextMessage(
    BaseChannel channel,
    String text,
    Function() success,
    Function() failure,
  ) async {
    return channel.sendUserMessageWithText(
      text,
      onCompleted: (msg, error) {
        print('repository');
        if (error != null) {
          print('error');
          failure;
        } else {
          success.call();
        }
      },
    );
  }

  @override
  Future<FileMessage> sendFileMessage(
    BaseChannel channel,
    File file,
    Function() success,
  ) async {
    final params = FileMessageParams.withFile(file);
    return channel.sendFileMessage(params, onCompleted: (msg, error) {
      print('sendFileMessage');
      success.call();
    });
  }
}
