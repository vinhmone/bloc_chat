import 'package:bloc_chat/util/extensions.dart';
import 'package:flutter/material.dart';
import 'package:sendbird_sdk/core/message/base_message.dart';

enum MessageStatus {
  sent,
  read,
  none,
}

class MessageItem extends StatelessWidget {
  final BaseMessage current;
  final BaseMessage? previous;
  final BaseMessage? next;

  const MessageItem({
    Key? key,
    required this.current,
    this.previous,
    this.next,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Align(
        alignment: current.isMyMessage ? Alignment.topRight : Alignment.topLeft,
        child: Column(
          children: [
            current.isMyMessage
                ? _buildRightWidget(context)
                : Container(
                    child: Text(current.message),
                  ),
            const SizedBox(
              height: 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRightWidget(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.blue,
      ),
      padding: const EdgeInsets.all(8.0),
      child: LimitedBox(
        maxWidth: MediaQuery.of(context).size.width * 0.5,
        child: Text(current.message),
      ),
    );
  }
}
