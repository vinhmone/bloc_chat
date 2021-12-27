import 'package:bloc_chat/ui/home/view/home_page.dart';
import 'package:bloc_chat/ui/signin/signin.dart';
import 'package:bloc_chat/ui/signin/view/bg_round_gradient.dart';
import 'package:bloc_chat/ui/signup/view/signup_page.dart';
import 'package:bloc_chat/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SigninForm extends StatefulWidget {
  const SigninForm({Key? key}) : super(key: key);

  @override
  _SigninFormState createState() => _SigninFormState();
}

class _SigninFormState extends State<SigninForm> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SigninBloc, SigninState>(
      listener: (context, state) {
        if (state.status == SigninStatus.submissionInProgress ||
            state.status == SigninStatus.submissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentMaterialBanner()
            ..showSnackBar(SnackBar(content: Text(state.message ?? ' ')));
        } else if (state.status == SigninStatus.submissionSuccess) {
          ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
          Navigator.push(context, HomePage.route());
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                AppConstants.textSignin,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Stack(
                children: [
                  Column(
                    children: const [
                      EmailInput(),
                      SizedBox(
                        height: 4.0,
                      ),
                      PasswordInput(),
                    ],
                  ),
                  const _SigninButton(),
                ],
              ),
              const SizedBox(
                height: 14.0,
              ),
              InkWell(
                onTap: () {},
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    AppConstants.textForgotPassword,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, SignUpPage.route());
                },
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 10.0,
                    ),
                    child: Text(
                      AppConstants.textSignup,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _SigninButton extends StatelessWidget {
  const _SigninButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      right: 10.0,
      child: Align(
        alignment: Alignment.centerRight,
        child: FractionallySizedBox(
          widthFactor: 0.12,
          heightFactor: 0.5,
          child: BlocBuilder<SigninBloc, SigninState>(
            builder: (context, state) {
              return InkWell(
                onTap: (state.status == SigninStatus.initState ||
                        state.status == SigninStatus.emailIsEmpty ||
                        state.status == SigninStatus.emailNotValid ||
                        state.status == SigninStatus.passwordIsEmpty ||
                        state.status == SigninStatus.passwordNotValid)
                    ? null
                    : () {
                        context
                            .read<SigninBloc>()
                            .add(LoginWithEmailRequested());
                      },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const AspectRatio(
                        aspectRatio: 1 / 1, child: BackgroundRoundGradient()),
                    (state.status == SigninStatus.submissionInProgress)
                        ? const CircularProgressIndicator()
                        : const Icon(
                            Icons.arrow_right_alt,
                            color: Colors.white,
                          ),
                  ],
                ),
              );
            },
          ),
        ),
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
        maxLines: 1,
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
        keyboardType: TextInputType.emailAddress,
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
        maxLines: 1,
        style:
            const TextStyle(backgroundColor: Colors.white, color: Colors.black),
        onChanged: (password) {
          context.read<SigninBloc>().add(PasswordChanged(password: password));
        },
        obscureText: true,
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
