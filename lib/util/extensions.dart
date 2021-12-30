import 'package:bloc_chat/data/repository/authentication_repository.dart';
import 'package:intl/intl.dart';
import 'package:sendbird_sdk/core/message/base_message.dart';

extension DateUtil on int {
  String toReadableTime() {
    final formatter = DateFormat('HH:mm a');
    final date = DateTime.fromMillisecondsSinceEpoch(this);
    return formatter.format(date);
  }
}

extension BaseMessageX on BaseMessage {
  bool get isMyMessage => sender?.userId == sendbird.currentUser?.userId;
}
