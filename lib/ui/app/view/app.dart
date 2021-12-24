import 'package:bloc_chat/data/repository/authentication_repository.dart';
import 'package:bloc_chat/ui/app/app.dart';
import 'package:bloc_chat/ui/home/view/home_page.dart';
import 'package:bloc_chat/ui/signin/view/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository;

  const App(
      {Key? key, required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => _authenticationRepository,
      child: BlocProvider<AppBloc>(
        create: (_) => AppBloc(
          authenticationRepository: _authenticationRepository,
        ),
        child: MaterialApp(
          home: BlocListener<AppBloc, AppState>(
            listener: (context, state) {
              if (state.status == AppStatus.authenticated) {
                Navigator.push(
                  context,
                  HomePage.route(),
                );
              } else {
                Navigator.of(context).push(
                  SignInPage.route(),
                );
              }
            },
            child: const SignInPage(),
          ),
        ),
      ),
    );
  }
}
