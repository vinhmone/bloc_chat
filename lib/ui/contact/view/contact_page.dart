import 'package:bloc_chat/ui/contact/bloc/contact_bloc.dart';
import 'package:bloc_chat/ui/contact/view/contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContactBloc>(
      create: (_) => ContactBloc(repository: context.read()),
      child: const ContactScreen(),
    );
  }
}
