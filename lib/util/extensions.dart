import 'package:intl/intl.dart';

extension DateUtil on int {
  String toReadableTime() {
    final formatter = DateFormat('HH:mm a');
    final date = DateTime.fromMillisecondsSinceEpoch(this);
    return formatter.format(date);
  }
}
