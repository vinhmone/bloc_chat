import 'package:bloc_chat/ui/chat_detail/chat_detail.dart';
import 'package:bloc_chat/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_chat/ui/chat_list/chat_list.dart';

import 'chat_list_item.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    _reloadListView(true);
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.textAllChat),
      ),
      body: BlocBuilder<ChatListBloc, ChatListState>(
        buildWhen: (_, current) {
          return current.status == ChatListStatus.chatListLoaded ||
              current.status == ChatListStatus.onMessageReceived;
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () => _reloadListView(true),
            child: ListView.separated(
              itemBuilder: (context, index) {
                return (index == state.groups.length &&
                        BlocProvider.of<ChatListBloc>(context).hasNext)
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(),
                      )
                    : InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            ChatDetailPage.route(
                                channel: state.groups[index]),
                          );
                        },
                        child: ChatListItem(channel: state.groups[index]),
                      );
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

  Future _reloadListView(bool reload) async {
    context.read<ChatListBloc>().add(LoadChatListRequested(reload: reload));
  }
}
