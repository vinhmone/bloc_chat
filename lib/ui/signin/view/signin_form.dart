import 'package:bloc_chat/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_chat/ui/signin/signin.dart';

class SigninForm extends StatefulWidget {
  const SigninForm({Key? key}) : super(key: key);

  @override
  _SigninFormState createState() => _SigninFormState();
}

class _SigninFormState extends State<SigninForm> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: const [
          EmailInput(),
          PasswordInput(),
        ],
      ),
    );
  }
}

class EmailInput extends StatelessWidget {
  const EmailInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SigninBloc, SigninState>(buildWhen: (previous, current) {
      return previous.email != current.email;
    }, builder: (context, state) {
      return TextField(
        style:
            const TextStyle(backgroundColor: Colors.white, color: Colors.black),
        onChanged: (email) {
          context.read<SigninBloc>().add(EmailChanged(email: email));
        },
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
            hintText: AppConstants.hintEmail,
            border: InputBorder.none,
            prefixIcon: const Icon(
              Icons.email,
            ),
            errorText: state.message),
      );
    });
  }
}

class PasswordInput extends StatelessWidget {
  const PasswordInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SigninBloc, SigninState>(buildWhen: (previous, current) {
      return previous.password != current.password;
    }, builder: (context, state) {
      return TextField(
        style:
            const TextStyle(backgroundColor: Colors.white, color: Colors.black),
        onChanged: (password) {
          context.read<SigninBloc>().add(PasswordChanged(password: password));
        },
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
            hintText: AppConstants.hintPassword,
            border: InputBorder.none,
            prefixIcon: const Icon(
              Icons.password,
            ),
            errorText: state.message),
      );
    });
  }
}
