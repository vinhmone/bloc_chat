import 'package:bloc_chat/data/repository/authentication_repository.dart';
import 'package:bloc_chat/util/constants.dart';
import 'package:bloc_chat/util/extensions.dart';
import 'package:bloc_chat/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:sendbird_sdk/core/channel/group/group_channel.dart';
import 'package:sendbird_sdk/core/message/file_message.dart';

class ChatListItem extends StatelessWidget {
  final GroupChannel channel;

  const ChatListItem({
    Key? key,
    required this.channel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxHeight: 80,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildChatImageCover(),
            _buildContentWidget(),
            _buildTailing(),
          ],
        ),
      ),
    );
  }

  Widget _buildChatImageCover() {
    return Hero(
      tag: channel.key,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AspectRatio(
          aspectRatio: 1 / 1,
          child: FittedBox(
            fit: BoxFit.contain,
            child: getGroupAvatar(channel),
          ),
        ),
      ),
    );
  }

  Widget _buildContentWidget() {
    String message = '';
    if (channel.lastMessage is FileMessage) {
      message = ChatConstants.textNewFileMessage;
    } else {
      message = channel.lastMessage?.message ?? '';
    }
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints.expand(),
              child: Text(
                getNameChannel(channel),
                maxLines: 1,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints.expand(),
              child: Text(
                message,
                maxLines: 2,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTailing() {
    String lastMessageDate =
        channel.lastMessage?.createdAt.toReadableTime() ?? '';
    String newMessageCount = (channel.unreadMessageCount < 100)
        ? channel.unreadMessageCount.toString()
        : '99+';

    return Column(
      children: [
        Flexible(
          flex: 1,
          child: Text(lastMessageDate),
        ),
        Flexible(
          flex: 2,
          child: (newMessageCount != '0')
              ? Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 24,
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(newMessageCount),
                    ),
                  ),
                )
              : Container(),
        ),
      ],
    );
  }
}
