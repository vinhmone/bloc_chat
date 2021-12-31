import 'package:bloc_chat/data/repository/authentication_repository.dart';
import 'package:intl/intl.dart';
import 'package:sendbird_sdk/core/message/base_message.dart';

extension DateUtil on int {
  String toReadableTime() {
    final formatter = DateFormat('HH:mm a');
    final date = DateTime.fromMillisecondsSinceEpoch(this);
    return formatter.format(date);
  }

  String toReadableDateWeekTime() {
    final date = DateTime.fromMillisecondsSinceEpoch(this);
    return DateFormat('E, MMM d').format(date);
  }
}

extension BaseMessageX on BaseMessage {
  bool get isMyMessage => sender?.userId == sendbird.currentUser?.userId;
}

extension DateTimeX on DateTime {
  bool isSameDate(DateTime a) =>
      (a.year == year) && (a.month == month) && (a.day == day);

  bool isSendAtSameMinute(DateTime a) =>
      (a.year == year) &&
      (a.month == month) &&
      (a.day == day) &&
      (a.hour == hour) &&
      (a.minute == minute);
}
