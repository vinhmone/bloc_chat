import 'package:bloc_chat/ui/home/home.dart';
import 'package:bloc_chat/ui/home/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute(builder: (_) => const HomePage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (_) => HomeBloc(repository: context.read()),
      child: const HomeScreen(),
    );
  }
}
