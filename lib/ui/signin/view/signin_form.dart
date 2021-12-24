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
      child: BlocBuilder<SigninBloc, SigninState>(
        buildWhen: (pre, cur) {
          print(pre.email);
          return pre.email != cur.email;
        },
        builder: (context, state) {
          return Column(
            children: [
              TextField(
                style: const TextStyle(backgroundColor: Colors.white, color: Colors.black),
                onChanged: (email) {
                  context.read<SigninBloc>().add(EmailChanged(email: email));
                  print("DASDDDDDD");
                },
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                    hintText: AppConstants.hintEmail,
                    border: InputBorder.none,
                    prefixIcon: const Icon(
                      Icons.email,
                    ),
                  errorText: state.message
                ),
              ),
              Text(state.message ?? "?????"),
            ],
          );
        }
      ),
    );
  }
}
