import 'dart:io';

import 'package:bloc_chat/data/repository/authentication_repository.dart';
import 'package:bloc_chat/ui/chat_detail/bloc/chat_detail_bloc.dart';
import 'package:bloc_chat/util/constants.dart';
import 'package:bloc_chat/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

class ChannelDetailScreen extends StatelessWidget {
  final BuildContext blocContext;

  const ChannelDetailScreen({
    Key? key,
    required this.blocContext,
  }) : super(key: key);

  static Route route(BuildContext context) => MaterialPageRoute(
        builder: (_) => ChannelDetailScreen(blocContext: context),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatDetailBloc>(
      create: (_) => BlocProvider.of<ChatDetailBloc>(blocContext),
      child: const _ChannelDetailScreen(),
    );
  }
}

class _ChannelDetailScreen extends StatefulWidget {
  const _ChannelDetailScreen({Key? key}) : super(key: key);

  @override
  _ChannelDetailScreenState createState() => _ChannelDetailScreenState();
}

class _ChannelDetailScreenState extends State<_ChannelDetailScreen> {
  late final channel = BlocProvider.of<ChatDetailBloc>(context).group
    ..members.sort((a, b) => a.nickname.compareTo(b.nickname))
    ..members.sort((a, b) => a.role == Role.chat_operator ? -1 : 1);
  final textController = TextEditingController();
  File? file;

  @override
  Widget build(BuildContext context) {
    if (textController.text.isEmpty) {
      textController.text = getNameChannel(channel);
    }
    return Scaffold(
      appBar: _buildAppBar(context),
      body: BlocListener<ChatDetailBloc, ChatDetailState>(
        listener: (context, state) {
          if (state.status == ChatDetailStatus.updateChannelInProgress) {
            ScaffoldMessenger.of(context)
              ..hideCurrentMaterialBanner()
              ..showSnackBar(const SnackBar(content: Text('Updating Group')));
          } else if (state.status == ChatDetailStatus.updateChannelSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentMaterialBanner()
              ..showSnackBar(const SnackBar(content: Text('Updated')));
          } else if (state.status == ChatDetailStatus.updateChannelInProgress) {
            ScaffoldMessenger.of(context)
              ..hideCurrentMaterialBanner()
              ..showSnackBar(
                  const SnackBar(content: Text(AppConstants.unknownException)));
          } else if (state.status == ChatDetailStatus.leaveChannelSuccess) {
            Navigator.pop(context);
            Navigator.pop(context);
          }
        },
        child: Column(
          children: [
            _buildChannelCover(channel, context),
            _buildTextFieldChannelName(),
            (channel.isDistinct)
                ? Container()
                : Column(
                    children: [
                      _buildButtonLeave(context),
                      const SizedBox(height: 8),
                    ],
                  ),
            const Divider(
              color: Colors.black,
            ),
            _buildListViewMember(channel),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonLeave(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Are you sure to leave this chat?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        BlocProvider.of<ChatDetailBloc>(this.context)
                            .add(LeaveChatRequested());
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                );
              });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.exit_to_app,
              color: Colors.red,
              size: 26,
            ),
            Text(
              'Leave this chat',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListViewMember(GroupChannel channel) {
    return Flexible(
      child: ListView.separated(
        itemBuilder: (context, index) {
          return Column(
            children: [
              _buildMemberItem(channel.members[index]),
              (index == channel.memberCount - 1)
                  ? const SizedBox(
                      height: 40,
                    )
                  : Container(),
            ],
          );
        },
        separatorBuilder: (_, index) => const SizedBox(
          height: 2,
        ),
        itemCount: channel.memberCount,
      ),
    );
  }

  TextField _buildTextFieldChannelName() {
    final currentUserId = channel.members.indexWhere(
        (element) => element.userId == sendbird.currentUser!.userId);
    return TextField(
      enabled: !channel.isDistinct &&
          channel.members[currentUserId].role == Role.chat_operator,
      controller: textController,
      textAlign: TextAlign.center,
      maxLines: 1,
      maxLength: 20,
      style: const TextStyle(
        fontSize: 20,
      ),
    );
  }

  Widget _buildChannelCover(GroupChannel channel, BuildContext context) {
    final currentUserId = channel.members.indexWhere(
        (element) => element.userId == sendbird.currentUser!.userId);
    return Container(
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 30,
      ),
      child: Hero(
        tag: channel.key,
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: MediaQuery.of(context).size.height * 0.2,
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: GestureDetector(
                onTap: (!channel.isDistinct &&
                        channel.members[currentUserId].role ==
                            Role.chat_operator)
                    ? () async {
                        final newFile = await getFile(context);
                        setState(() {
                          file = newFile;
                        });
                      }
                    : null,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: (file == null)
                      ? getGroupAvatar(channel)
                      : CircleAvatar(
                          backgroundImage: FileImage(file!),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      flexibleSpace: SafeArea(
        child: Stack(
          children: [
            BackButton(
              color: Theme.of(context).primaryColor,
            ),
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Detail',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            (textController.text == getNameChannel(channel) && file == null)
                ? Container()
                : Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        BlocProvider.of<ChatDetailBloc>(context).add(
                          UpdateGroupChat(
                            channel: channel,
                            file: file,
                            name: textController.text,
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberItem(Member member) {
    final avatarUrl = member.profileUrl ?? '';
    final name = member.nickname;
    return Container(
      padding: const EdgeInsets.all(4),
      height: 40,
      child: Row(
        children: [
          const SizedBox(
            width: 8,
          ),
          _buildAvatarWidget(avatarUrl),
          const SizedBox(
            width: 8,
          ),
          Expanded(child: Text(name)),
          Align(
            alignment: Alignment.center,
            child: Row(
              children: [
                (member.role == Role.chat_operator)
                    ? const Image(
                        image: AssetImage('assets/images/crown.png'),
                        width: 14,
                        height: 14,
                      )
                    : Container(),
                const SizedBox(
                  width: 2,
                ),
                (member.connectionStatus == UserConnectionStatus.online)
                    ? const Icon(
                        Icons.circle,
                        color: Colors.green,
                        size: 14,
                      )
                    : const Icon(
                        Icons.circle,
                        color: Colors.grey,
                        size: 14,
                      ),
              ],
            ),
          ),
          const SizedBox(
            width: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarWidget(String avatarUrl) {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: SizedBox(
        height: 2,
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
                      avatarUrl,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
