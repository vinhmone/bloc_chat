import 'dart:async';
import 'dart:io';

import 'package:bloc_chat/data/repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sendbird_sdk/core/channel/group/group_channel.dart';

import 'constants.dart';

Future<File?> getFile(BuildContext context) {
  final wait = Completer<File?>();

  showModalBottomSheet(
    context: context,
    builder: (buildContext) {
      return Wrap(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ListTile(
                title: const Text('Camera'),
                trailing: Icon(
                  Icons.camera_alt_outlined,
                  color: ThemeData.light().primaryColor,
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final res = await _showPicker(ImageSource.camera);
                  wait.complete(res);
                },
              ),
              ListTile(
                title: const Text('Library'),
                trailing: Icon(
                  Icons.photo_camera_back,
                  color: ThemeData.light().primaryColor,
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final res = await _showPicker(ImageSource.gallery);
                  wait.complete(res);
                },
              ),
              ListTile(
                title: const Text('Cancel'),
                trailing: Icon(
                  Icons.cancel_outlined,
                  color: ThemeData.light().primaryColor,
                ),
                onTap: () async {
                  Navigator.pop(context);
                  wait.complete(null);
                },
              ),
            ],
          ),
        ],
      );
    },
  );

  return wait.future;
}

Future<File?> _showPicker(ImageSource source) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: source);
  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  return null;
}

String getNameChannel(GroupChannel channel) {
  String name = '';
  if (!channel.isDistinct) {
    name = channel.name ?? ChatConstants.textDefaultGroupChatName;
  } else {
    final list = channel.members;
    final currentUserId = list.indexWhere(
        (element) => element.userId == sendbird.currentUser!.userId);
    final otherUserId = (currentUserId == 0) ? 1 : 0;
    name = list[otherUserId].nickname;
  }
  return name;
}

Widget getGroupAvatar(GroupChannel channel) {
  Widget widget = Container();
  if (!channel.isDistinct) {
    widget = (channel.coverUrl != null)
        ? CircleAvatar(
            backgroundImage: NetworkImage(channel.coverUrl!),
          )
        : const CircleAvatar(
            backgroundImage: AssetImage('assets/images/group_cover_holder.png'),
          );
  } else {
    final list = channel.members;
    final currentUserId = list.indexWhere(
        (element) => element.userId == sendbird.currentUser?.userId);
    final otherUserId = (currentUserId == 0) ? 1 : 0;
    final avatarUrl = list[otherUserId].profileUrl ?? '';
    widget = avatarUrl.isEmpty
        ? const CircleAvatar(
            child: Icon(Icons.person),
          )
        : CircleAvatar(
            backgroundImage: NetworkImage(
              avatarUrl,
            ),
          );
  }
  return widget;
}
