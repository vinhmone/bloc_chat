import 'package:bloc_chat/ui/chat_detail/bloc/chat_detail_bloc.dart';
import 'package:bloc_chat/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sendbird_sdk/constant/enums.dart';
import 'package:sendbird_sdk/core/channel/group/group_channel.dart';
import 'package:sendbird_sdk/core/models/member.dart';

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
    ..members.sort((a, b) => a.nickname.compareTo(b.nickname));
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (textController.text.isEmpty) {
      textController.text =
          channel.name ?? ChatConstants.textDefaultGroupChatName;
    }
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildChannelCover(channel, context),
          _buildTextFieldChannelName(),
          _buildListViewMember(channel),
        ],
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
    return TextField(
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
            width: MediaQuery.of(context).size.width * 0.3,
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
      child: ListTile(
          title: Text(name),
          leading: _buildAvatarWidget(avatarUrl),
          trailing: (member.connectionStatus == UserConnectionStatus.online)
              ? const Icon(
                  Icons.circle,
                  color: Colors.green,
                  size: 14,
                )
              : const Icon(
                  Icons.circle,
                  color: Colors.grey,
                  size: 14,
                )),
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
