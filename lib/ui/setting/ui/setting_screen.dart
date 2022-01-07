import 'dart:io';

import 'package:bloc_chat/data/repository/authentication_repository.dart';
import 'package:bloc_chat/ui/setting/bloc/setting_bloc.dart';
import 'package:bloc_chat/util/constants.dart';
import 'package:bloc_chat/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_chat/util/extensions.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final textController = TextEditingController();
  File? file;
  final name = sendbird.currentUser?.nickname ?? '';
  bool shouldShow = false;

  @override
  Widget build(BuildContext context) {
    if (textController.text.isEmpty) {
      textController.text = name;
    }
    return Scaffold(
      appBar: _buildAppBar(context),
      body: BlocListener<SettingBloc, SettingState>(
        listener: (context, state) {
          switch (state.status) {
            case SettingStatus.initState:
              break;
            case SettingStatus.userLoadingInProgress:
              break;
            case SettingStatus.userLoadingSuccess:
              break;
            case SettingStatus.userLoadingFailure:
              break;
            case SettingStatus.updateUserSuccess:
              ScaffoldMessenger.of(context)
                ..hideCurrentMaterialBanner()
                ..showSnackBar(const SnackBar(content: Text('Updated')));
              break;
            case SettingStatus.updateUserInProgress:
              ScaffoldMessenger.of(context)
                ..hideCurrentMaterialBanner()
                ..showSnackBar(
                    const SnackBar(content: Text('Updating information')));
              break;
            case SettingStatus.updateUserFailure:
              ScaffoldMessenger.of(context)
                ..hideCurrentMaterialBanner()
                ..showSnackBar(const SnackBar(
                    content: Text('Cannot update your information')));
              break;
            case SettingStatus.signOutInProgress:
              ScaffoldMessenger.of(context)
                ..hideCurrentMaterialBanner()
                ..showSnackBar(
                    const SnackBar(content: Text('Signing you out...')));
              break;
            case SettingStatus.signOutSuccess:
              ScaffoldMessenger.of(context)
                ..hideCurrentMaterialBanner()
                ..showSnackBar(
                    const SnackBar(content: Text('Until next time!')));
              break;
          }
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAvatarWidget(context),
              _buildTextFieldChannelName(),
              _buildSignout(context),
            ],
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
                AppConstants.textSetting,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            !shouldShow
                ? Container()
                : Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        BlocProvider.of<SettingBloc>(context).add(
                          UpdateUserRequest(
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

  Widget _buildAvatarWidget(BuildContext context) {
    final avatarUrl = sendbird.currentUser?.profileUrl ?? '';

    return Container(
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 30,
      ),
      alignment: Alignment.center,
      child: SizedBox(
        width: MediaQuery.of(context).size.height * 0.2,
        child: AspectRatio(
          aspectRatio: 1 / 1,
          child: InkWell(
            onTap: () async {
              final newFile = await getFile(context);
              setState(() {
                file = newFile;
                shouldShow = (file != null);
              });
            },
            child: FittedBox(
              fit: BoxFit.fill,
              child: (file == null)
                  ? (avatarUrl.isEmpty
                      ? const CircleAvatar(
                          child: Icon(Icons.person),
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(
                            avatarUrl,
                          ),
                        ))
                  : CircleAvatar(
                      backgroundImage: FileImage (file!),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  TextField _buildTextFieldChannelName() {
    return TextField(
      enabled: true,
      controller: textController,
      textAlign: TextAlign.center,
      maxLines: 1,
      maxLength: 20,
      style: const TextStyle(
        fontSize: 24,
      ),
      onChanged: (text) {
        setState(() {
          shouldShow = (text != name);
        });
      },
    );
  }

  Widget _buildSignout(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Are you sure to sign out?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        BlocProvider.of<SettingBloc>(this.context)
                            .add(SignoutRequest());
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
              'Sign out',
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
}
