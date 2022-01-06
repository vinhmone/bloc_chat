import 'package:bloc_chat/data/repository/authentication_repository.dart';
import 'package:bloc_chat/ui/chat_detail/view/chat_detail_page.dart';
import 'package:bloc_chat/ui/contact/bloc/contact_bloc.dart';
import 'package:bloc_chat/ui/contact/view/contact_detail.dart';
import 'package:bloc_chat/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  late List<User> users = [];
  late List<bool> selectedList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        flexibleSpace: SafeArea(
          child: Row(
            children: [
              const SizedBox(
                width: 12,
              ),
              const Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppConstants.textContact,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              FittedBox(
                fit: BoxFit.contain,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: MaterialButton(
                    onPressed: () {
                      _createNewChat(context);
                    },
                    shape: const RoundedRectangleBorder(),
                    child: const Text(
                      'Create',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: BlocConsumer<ContactBloc, ContactState>(
        listener: (context, state) {
          if (state.status == ContactStatus.createNewChatSuccess) {
            Navigator.push(
              context,
              ChatDetailPage.route(channel: state.channel!),
            );
          }
        },
        buildWhen: (_, current) {
          users = current.users.toList();
          selectedList = List<bool>.filled(users.length, false);
          return current.status == ContactStatus.loadContactSuccess;
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async =>
                context.read<ContactBloc>().add(LoadAllContact()),
            child: ListView.separated(
              itemBuilder: (context, index) {
                return _buildItem(
                  state.users[index],
                  index,
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount: state.users.length,
            ),
          );
        },
      ),
    );
  }

  void _createNewChat(BuildContext context) {
    List<User> selectedUsers = [];
    for (int i = 0; i < selectedList.length; i++) {
      if (selectedList[i]) selectedUsers.add(users[i]);
    }
    if (selectedUsers.isNotEmpty) {
      selectedUsers.add(sendbird.currentUser!);
      _buildChatFormNameWidget(context).then((value) {
        if (value != null) {
          BlocProvider.of<ContactBloc>(context).add(CreateNewChat(
            users: selectedUsers,
            name: value,
          ));
        }
      });
    }
  }

  Widget _buildItem(User user, int index) {
    final avatarUrl = user.profileUrl ?? '';
    final name = user.nickname;

    return ListTile(
      title: Text(name),
      leading: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                )),
            builder: (BuildContext bc) {
              return BlocProvider<ContactBloc>(
                create: (_) => BlocProvider.of<ContactBloc>(context),
                child: ContactDetail(user: user),
              );
            },
          );
        },
        customBorder: const CircleBorder(),
        child: _buildAvatarWidget(avatarUrl),
      ),
      trailing: Checkbox(
        value: selectedList[index],
        onChanged: (bool? value) {
          setState(() {
            selectedList[index] = value ?? false;
          });
        },
      ),
    );
  }

  Widget _buildAvatarWidget(String avatarUrl) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: SizedBox(
          height: 22,
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
      ),
    );
  }

  Future<String?> _buildChatFormNameWidget(BuildContext context) {
    final inputController = TextEditingController();
    return showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: const Text('Set a new name:'),
            content: SingleChildScrollView(
              child: TextField(
                maxLines: 1,
                maxLength: 20,
                controller: inputController,
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, inputController.text.toString());
                  },
                  child: const Text('OK')),
            ],
          );
        });
  }
}
