import 'package:bloc_chat/ui/home/view/home_page.dart';
import 'package:bloc_chat/ui/signin/view/bg_round_gradient.dart';
import 'package:bloc_chat/ui/signup/bloc/signup_bloc.dart';
import 'package:bloc_chat/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state.status == SignupStatus.submissionInProgress ||
            state.status == SignupStatus.submissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentMaterialBanner()
            ..showSnackBar(SnackBar(content: Text(state.message ?? ' ')));
        } else if (state.status == SignupStatus.submissionSuccess) {
          ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
          Navigator.push(context, HomePage.route());
        }
      },
      child: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Positioned(
                top: 100,
                right: 20,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: 16.0,
                      ),
                      child: Text(
                        AppConstants.textSignin,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    AppConstants.textSignup,
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
                          UsernameInput(),
                          SizedBox(
                            height: 4.0,
                          ),
                          EmailInput(),
                          SizedBox(
                            height: 4.0,
                          ),
                          PasswordInput(),
                        ],
                      ),
                      const SignupButton(),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignupButton extends StatelessWidget {
  const SignupButton({
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
          heightFactor: 0.4,
          child: BlocBuilder<SignupBloc, SignupState>(
            builder: (context, state) {
              return InkWell(
                onTap: (state.status == SignupStatus.usernameIsEmpty ||
                        state.status == SignupStatus.initState ||
                        state.status == SignupStatus.emailIsEmpty ||
                        state.status == SignupStatus.emailNotValid ||
                        state.status == SignupStatus.passwordIsEmpty ||
                        state.status == SignupStatus.passwordNotValid)
                    ? null
                    : () {
                        context
                            .read<SignupBloc>()
                            .add(SignupWithEmailRequested());
                      },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const AspectRatio(
                        aspectRatio: 1 / 1, child: BackgroundRoundGradient()),
                    (state.status == SignupStatus.submissionInProgress)
                        ? const CircularProgressIndicator()
                        : const Icon(
                            Icons.check,
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

class UsernameInput extends StatelessWidget {
  const UsernameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(buildWhen: (previous, current) {
      return previous.username != current.username;
    }, builder: (context, state) {
      return TextField(
        maxLines: 1,
        style:
            const TextStyle(backgroundColor: Colors.white, color: Colors.black),
        onChanged: (username) {
          context.read<SignupBloc>().add(UsernameChanged(username: username));
        },
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
            hintText: AppConstants.hintUsername,
            border: InputBorder.none,
            prefixIcon: const Icon(
              Icons.people,
            ),
            errorText: state.message),
        keyboardType: TextInputType.emailAddress,
      );
    });
  }
}

class EmailInput extends StatelessWidget {
  const EmailInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(buildWhen: (previous, current) {
      return previous.email != current.email;
    }, builder: (context, state) {
      return TextField(
        maxLines: 1,
        style:
            const TextStyle(backgroundColor: Colors.white, color: Colors.black),
        onChanged: (email) {
          context.read<SignupBloc>().add(EmailChanged(email: email));
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
    return BlocBuilder<SignupBloc, SignupState>(buildWhen: (previous, current) {
      return previous.password != current.password;
    }, builder: (context, state) {
      return TextField(
        maxLines: 1,
        style:
            const TextStyle(backgroundColor: Colors.white, color: Colors.black),
        onChanged: (password) {
          context.read<SignupBloc>().add(PasswordChanged(password: password));
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
