import 'package:bloc_chat/data/repository/authentication_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    final now = DateTime.now();
    if (date.isSameDate(now)) return 'Today';
    if (date.isYesterday(now)) return 'Yesterday';
    return DateFormat('E, MMM d').format(date);
  }
}

extension BaseMessageX on BaseMessage {
  bool get isMyMessage => sender?.userId == sendbird.currentUser?.userId;
}

extension DateTimeX on DateTime {
  bool isSameDate(DateTime a) =>
      (a.year == year) && (a.month == month) && (a.day == day);

  bool isYesterday(DateTime a) => difference(a).inDays == -1;

  bool isSendAtSameMinute(DateTime a) =>
      (a.year == year) &&
      (a.month == month) &&
      (a.day == day) &&
      (a.hour == hour) &&
      (a.minute == minute);
}

extension WidgetX on Widget {
  void showSnackBar({
    required BuildContext context,
    required String message,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentMaterialBanner()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
