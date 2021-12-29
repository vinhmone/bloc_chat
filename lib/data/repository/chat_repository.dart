import 'dart:io';

import 'package:bloc_chat/util/constants.dart';
import 'package:sendbird_sdk/constant/enums.dart';
import 'package:sendbird_sdk/core/channel/base/base_channel.dart';
import 'package:sendbird_sdk/core/channel/group/group_channel.dart';
import 'package:sendbird_sdk/query/channel_list/group_channel_list_query.dart';

abstract class ChatRepository {
  Future<List<GroupChannel>> loadChatList({bool reload = false});

  bool get hasNext;

  Future sendTextMessage(BaseChannel channel, String message);

  Future sendFileMessage(BaseChannel channel, File file);

  Future deleteMessage(BaseChannel channel, int messageId);
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
      print(e);
      throw AppConstants.errorGetChatList;
    }
  }

  @override
  Future deleteMessage(BaseChannel channel, int messageId) async {
  }

  @override
  Future sendFileMessage(BaseChannel channel, File file) async {}

  @override
  Future sendTextMessage(BaseChannel channel, String message) async {
    if (message.isEmpty) return;

  }
}
