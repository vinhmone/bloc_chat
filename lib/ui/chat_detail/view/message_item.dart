import 'package:bloc_chat/util/constants.dart';
import 'package:bloc_chat/util/extensions.dart';
import 'package:flutter/material.dart';
import 'package:sendbird_sdk/core/message/admin_message.dart';
import 'package:sendbird_sdk/core/message/base_message.dart';
import 'package:sendbird_sdk/core/message/file_message.dart';
import 'package:sendbird_sdk/core/message/user_message.dart';

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
    if (current is AdminMessage) {
      return _buildAdminWidget(context);
    } else {
      return Align(
        alignment: current.isMyMessage ? Alignment.topRight : Alignment.topLeft,
        child: Column(
          children: [
            !_isSameDate(previous, current) ? _buildDateWidget() : Container(),
            current.isMyMessage
                ? _buildRightWidget(context)
                : _buildLeftWidget(context),
            SizedBox(
              height: (next != null) ? 4 : 20,
            ),
          ],
        ),
      );
    }
  }

  Widget _buildRightWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.25,
        right: 8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          (!_isSendAtSameMinute(current, next))
              ? _buildDateSentWidget()
              : Container(),
          const SizedBox(
            width: 2,
          ),
          current is FileMessage
              ? _buildFileMessageWidget(context)
              : Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.blue,
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      current.message,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildFileMessageWidget(BuildContext context) {
    return Flexible(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Image(
          image: NetworkImage(
            (current as FileMessage).secureUrl ?? (current as FileMessage).url,
            scale: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildLeftWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: MediaQuery.of(context).size.width * 0.2,
        left: 8.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          !_isSameUser(previous, current)
              ? _buildUserNameWidget()
              : Container(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              (!_isSendAtSameMinute(current, next))
                  ? _buildAvatarWidget()
                  : Container(),
              const SizedBox(
                width: 2,
              ),
              current is FileMessage
                  ? _buildFileMessageWidget(context)
                  : Flexible(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.black.withOpacity(0.14),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        margin: EdgeInsets.only(
                          left: (_isSendAtSameMinute(current, next)) ? 22 : 0,
                        ),
                        child: Text(
                          current.message,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
              const SizedBox(
                width: 2,
              ),
              (!_isSendAtSameMinute(current, next))
                  ? _buildDateSentWidget()
                  : Container()
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarWidget() {
    final avatarUrl = current.sender?.profileUrl ?? '';
    return SizedBox(
      height: 22,
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: FittedBox(
          fit: BoxFit.contain,
          child: avatarUrl.isEmpty
              ? const CircleAvatar(
                  child: Icon(Icons.person),
                )
              : CircleAvatar(
                  backgroundImage: NetworkImage(
                    current.sender!.profileUrl!,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildDateSentWidget() {
    final time = current.createdAt.toReadableTime();
    return Text(
      time,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildUserNameWidget() {
    final name =
        current.sender?.nickname ?? SendbirdConstants.textDefaultUsername;
    return Column(
      children: [
        const SizedBox(
          height: 8,
        ),
        Container(
          margin: const EdgeInsets.only(left: 22),
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateWidget() {
    final date = current.createdAt.toReadableDateWeekTime();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          (previous != null)
              ? const FractionallySizedBox(
                  widthFactor: 0.6,
                  child: Divider(
                    color: Colors.black,
                  ),
                )
              : Container(),
          Text(
            date,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminWidget(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: FractionallySizedBox(
        widthFactor: 0.8,
        child: Column(
          children: [
            const SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 18,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: CircleAvatar(
                      child: Icon(
                        Icons.notifications_on_outlined,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Flexible(child: Text(current.message)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _isSameDate(BaseMessage? a, BaseMessage? b) {
    if (a == null || b == null) return false;
    final aTime = DateTime.fromMillisecondsSinceEpoch(a.createdAt);
    final bTime = DateTime.fromMillisecondsSinceEpoch(b.createdAt);

    return aTime.isSameDate(bTime);
  }

  bool _isSendAtSameMinute(BaseMessage? a, BaseMessage? b) {
    if (a == null || b == null) return false;
    if (a.sender?.userId != b.sender?.userId) return false;

    final aTime = DateTime.fromMillisecondsSinceEpoch(a.createdAt);
    final bTime = DateTime.fromMillisecondsSinceEpoch(b.createdAt);
    return aTime.isSendAtSameMinute(bTime);
  }

  bool _isSameUser(BaseMessage? a, BaseMessage? b) {
    if (a == null || b == null) return false;
    return a.sender?.userId == b.sender?.userId;
  }
}
