import 'package:bloc_chat/ui/contact/bloc/contact_bloc.dart';
import 'package:bloc_chat/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

import 'contact_item.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final List<User> selectedUser = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.textContact)),
      body: BlocBuilder<ContactBloc, ContactState>(
        buildWhen: (_, current) {
          return current.status == ContactStatus.loadContactSuccess;
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async =>
                context.read<ContactBloc>().add(LoadAllContact()),
            child: ListView.separated(
              itemBuilder: (context, index) {
                return ContactItem(
                  user: state.users[index],
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
}
