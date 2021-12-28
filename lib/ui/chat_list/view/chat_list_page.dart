import 'package:bloc_chat/ui/chat_list/bloc/chat_list_bloc.dart';
import 'package:bloc_chat/ui/chat_list/view/chat_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatListBloc>(
      create: (_) => ChatListBloc(repository: context.read()),
      child: const ChatListScreen(),
    );
  }
}
