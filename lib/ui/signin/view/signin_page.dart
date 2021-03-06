import 'package:bloc_chat/data/repository/authentication_repository.dart';
import 'package:bloc_chat/ui/signin/signin.dart';
import 'package:bloc_chat/ui/signin/view/signin_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute(builder: (_) => const SignInPage());

  @override
  Widget build(BuildContext context) {
    // context.read<AuthenticationRepository>().signout();
    return Scaffold(
        body: BlocProvider<SigninBloc>(
      create: (_) => SigninBloc(repository: context.read()),
      child: const SigninForm(),
    ));
  }
}
