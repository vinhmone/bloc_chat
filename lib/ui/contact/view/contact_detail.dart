import 'dart:developer';

import 'package:bloc_chat/ui/chat_detail/view/chat_detail_page.dart';
import 'package:bloc_chat/ui/contact/bloc/contact_bloc.dart';
import 'package:bloc_chat/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

class ContactDetail extends StatelessWidget {
  final User user;

  const ContactDetail({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<ContactBloc, ContactState>(
      listener: (context, state) {
        if (state.status == ContactStatus.createNewChatSuccess) {
          log('Success');
          Navigator.pop(context);
          Navigator.push(
            context,
            ChatDetailPage.route(channel: state.channel!),
          );
        }
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildAvatarWidget(context, user.profileUrl ?? ''),
            Text(
              user.nickname,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                _sendPrivateMessage(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(AppConstants.textSendMessage),
                  const SizedBox(
                    width: 4,
                  ),
                  Icon(
                    Icons.send,
                    color: ThemeData.light().primaryColor,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarWidget(BuildContext context, String avatarUrl) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.width * 0.2,
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: avatarUrl.isEmpty
                  ? const CircleAvatar(child: Icon(Icons.person))
                  : CircleAvatar(backgroundImage: NetworkImage(avatarUrl)),
            ),
          ),
        ),
      ),
    );
  }

  void _sendPrivateMessage(BuildContext context) {
    BlocProvider.of<ContactBloc>(context).add(SendPrivateChat(user: user));
  }
}
