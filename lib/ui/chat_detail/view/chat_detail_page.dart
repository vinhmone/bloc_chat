import 'package:bloc_chat/data/repository/chat_repository.dart';
import 'package:bloc_chat/ui/chat_detail/bloc/chat_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sendbird_sdk/core/channel/group/group_channel.dart';

import 'chat_detail_screen.dart';

class ChatDetailPage extends StatelessWidget {
  final GroupChannel _channel;

  final ChatRepository _repository = ChatRepositoryImpl();

  ChatDetailPage({Key? key, required GroupChannel channel})
      : _channel = channel,
        super(key: key);

  static Route route({required GroupChannel channel}) => MaterialPageRoute(
        builder: (_) => ChatDetailPage(
          channel: channel,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => _repository,
      child: BlocProvider<ChatDetailBloc>(
        create: (context) => ChatDetailBloc(
          repository: context.read(),
          group: _channel,
        ),
        child: const ChatDetailScreen(),
      ),
    );
  }
}
