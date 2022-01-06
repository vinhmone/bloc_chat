import 'dart:io';

import 'package:bloc_chat/data/repository/authentication_repository.dart';
import 'package:bloc_chat/util/constants.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

abstract class ContactRepository {
  Future<List<User>> loadAllUser();

  Future<GroupChannel> createChannel({required List<User> users, String? name});

  Future<GroupChannel> createPrivateChannel({required User user});
}

class ContactRepositoryImpl extends ContactRepository {
  @override
  Future<List<User>> loadAllUser() async {
    final query = ApplicationUserListQuery();
    try {
      final list = await query.loadNext();
      final currentUserIndex = list.indexWhere(
          (element) => element.userId == sendbird.currentUser?.userId);
      if (currentUserIndex > -1) list.removeAt(currentUserIndex);
      print(list.length);
      return list;
    } catch (e) {
      throw Exception(AppConstants.unknownException);
    }
  }

  @override
  Future<GroupChannel> createChannel(
      {required List<User> users, String? name}) async {
    try {
      final userIds = users.map((u) => u.userId).toList();
      final params = GroupChannelParams();
      params
        ..userIds = userIds
        ..operatorUserIds = [sendbird.currentUser!.userId];
      if (name != null && name.isNotEmpty) {
        params.name = name;
      }
      final newChannel = await GroupChannel.createChannel(params);
      return newChannel;
    } catch (_) {
      throw Exception(AppConstants.unknownException);
    }
  }

  @override
  Future<GroupChannel> createPrivateChannel({required User user}) async {
    try {
      final userIds = [sendbird.currentUser!.userId, user.userId];
      final params = GroupChannelParams();
      params
        ..userIds = userIds
        ..isDistinct = true;
      final newChannel = await GroupChannel.createChannel(params);
      return newChannel;
    } catch (_) {
      throw Exception(AppConstants.unknownException);
    }
  }
}
