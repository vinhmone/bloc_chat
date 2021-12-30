import 'package:bloc_chat/ui/chat_detail/bloc/chat_detail_bloc.dart';
import 'package:bloc_chat/ui/chat_detail/view/message_input.dart';
import 'package:bloc_chat/ui/chat_list/bloc/chat_list_bloc.dart';
import 'package:bloc_chat/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sendbird_sdk/core/channel/group/group_channel.dart';
import 'package:sendbird_sdk/core/message/base_message.dart';

import 'message_item.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({Key? key}) : super(key: key);

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        flexibleSpace: SafeArea(
          child: Row(
            children: [
              BackButton(
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(
                width: 2,
              ),
              _buildChatImageCover(),
              _buildAppBarChatName(),
              _buildAppBarTailIcon()
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildChatMessages(),
            MessageInput(
              onPressPlus: () {},
              onPressSend: (text) {},
              onEditing: (text) {},
              onChanged: (text) {},
              placeHolder: 'Vinh',
              isEditing: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatMessages() {
    return Expanded(
      child: Container(
        color: Colors.white,
        child: BlocBuilder<ChatDetailBloc, ChatDetailState>(
          buildWhen: (_, current) {
            return current.status == ChatDetailStatus.chatLoadSuccess ||
                current.status == ChatDetailStatus.newMessageReceived;
          },
          builder: (context, state) {
            return ListView.builder(
              itemCount: state.listMessage.length,
              reverse: true,
              itemBuilder: (context, index) {
                final current = state.listMessage[index];
                final previous = (index < state.listMessage.length - 1)
                    ? state.listMessage[index + 1]
                    : null;
                final next = (index > 0) ? state.listMessage[index - 1] : null;
                // return Text(
                //   state.listMessage[index].message.toString(),
                //   key: Key(state.listMessage[index].messageId.toString()),
                // );
                return MessageItem(
                  previous: previous,
                  current: current,
                  next: next,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBarTailIcon() {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: FittedBox(
        fit: BoxFit.cover,
        child: MaterialButton(
          onPressed: () {},
          shape: const CircleBorder(),
          child: const Icon(
            Icons.info_outline,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildAppBarChatName() {
    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          BlocProvider.of<ChatDetailBloc>(context).group.name ??
              ChatConstants.textDefaultGroupChatName,
          maxLines: 1,
          textAlign: TextAlign.justify,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildChatImageCover() {
    final channel = BlocProvider.of<ChatDetailBloc>(context).group;
    return Hero(
      tag: channel.key,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: AspectRatio(
          aspectRatio: 1 / 1,
          child: FittedBox(
            fit: BoxFit.contain,
            child: (channel.coverUrl != null)
                ? CircleAvatar(
                    backgroundImage: NetworkImage(channel.coverUrl!),
                  )
                : const CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/group_cover_holder.png'),
                  ),
          ),
        ),
      ),
    );
  }
}
