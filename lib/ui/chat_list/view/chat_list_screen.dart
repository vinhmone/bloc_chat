import 'package:bloc_chat/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_chat/ui/chat_list/chat_list.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.textAllChat),
      ),
      body: BlocBuilder<ChatListBloc, ChatListState>(
        buildWhen: (_, current) =>
            current.status == ChatListStatus.chatListLoaded,
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context
                  .read<ChatListBloc>()
                  .add(const LoadChatListRequested(reload: true));
            },
            child: ListView.separated(
              itemBuilder: (context, index) {
                return Text(state.groups[index].lastMessage?.message ?? '4235435');
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 4);
              },
              itemCount: state.groups.length,
            ),
          );
        },
      ),
    );
  }
}
