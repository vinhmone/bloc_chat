import 'package:bloc_chat/data/repository/authentication_repository.dart';
import 'package:bloc_chat/util/constants.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

abstract class ContactRepository {
  Future<List<User>> loadAllUser();

  Future<BaseChannel> createChannel(List<User> users);
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
  Future<BaseChannel> createChannel(List<User> users) async {
    try {
      final userIds = users.map((u) => u.userId).toList();
      final params = GroupChannelParams();
      params.userIds = userIds;
      return await GroupChannel.createChannel(params);
    } catch (_) {
      throw Exception(AppConstants.unknownException);
    }
  }
}
