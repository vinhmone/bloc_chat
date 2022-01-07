import 'package:bloc_chat/ui/signup/bloc/signup_bloc.dart';
import 'package:bloc_chat/ui/signup/view/signup_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute(builder: (_) => const SignUpPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider<SignupBloc>(
          create: (_) => SignupBloc(repository: context.read()),
          child: const SignupForm(),
        ));
  }
}
