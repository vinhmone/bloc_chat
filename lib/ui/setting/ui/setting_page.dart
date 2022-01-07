import 'package:bloc_chat/ui/setting/bloc/setting_bloc.dart';
import 'package:bloc_chat/ui/setting/ui/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  static Route route() =>
      MaterialPageRoute(builder: (_) => const SettingPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingBloc>(
      create: (_) => SettingBloc(repository: context.read()),
      child: SettingScreen(),
    );
  }
}
