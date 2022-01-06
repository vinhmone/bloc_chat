import 'dart:developer';
import 'dart:io';

import 'package:bloc_chat/util/constants.dart';
import 'package:sendbird_sdk/constant/enums.dart';
import 'package:sendbird_sdk/core/channel/base/base_channel.dart';
import 'package:sendbird_sdk/core/channel/group/group_channel.dart';
import 'package:sendbird_sdk/core/message/base_message.dart';
import 'package:sendbird_sdk/core/message/file_message.dart';
import 'package:sendbird_sdk/core/message/user_message.dart';
import 'package:sendbird_sdk/core/models/file_info.dart';
import 'package:sendbird_sdk/params/file_message_params.dart';
import 'package:sendbird_sdk/params/group_channel_params.dart';
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
    Function(BaseMessage message) success,
  );

  Future updateGroupChat({
    required BaseChannel channel,
    File? file,
    String? name,
  });

  Future leaveChat({required BaseChannel channel});
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
    try {
      if (channel is GroupChannel) channel.markAsRead();
    } catch (e) {
      log(e.toString());
    }
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
        if (error != null) {
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
    Function(BaseMessage message) success,
  ) async {
    final params = FileMessageParams.withFile(file);
    return channel.sendFileMessage(
      params,
      onCompleted: (msg, error) {
        log('sent file succeed ${msg.url}');
        success(msg);
      },
    );
  }

  @override
  Future updateGroupChat({
    required BaseChannel channel,
    File? file,
    String? name,
  }) async {
    try {
      final params = GroupChannelParams(isUpdate: true);
      if (name != null && name.isNotEmpty) {
        params.name = name;
      }

      if (file != null) {
        params.coverImage = FileInfo.fromData(
          name: 'image',
          file: file,
          mimeType: 'image/jpeg',
        );
      }
      await (channel as GroupChannel).updateChannel(params);
    } catch (e) {
      throw (AppConstants.unknownException);
    }
  }

  @override
  Future leaveChat({required BaseChannel channel}) async {
    try {
      await (channel as GroupChannel).leave();
    } catch (e) {
      throw (AppConstants.unknownException);
    }
  }
}
