import 'package:bloc_chat/data/repository/chat_repository.dart';
import 'package:bloc_chat/ui/home/bloc/home_bloc.dart';
import 'package:bloc_chat/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  final ChatRepository _repository = ChatRepositoryImpl();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<HomeBloc>(context).add(const SigninToSendbirdRequested());
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state.status == HomeStatus.connectFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentMaterialBanner()
            ..showSnackBar(
              const SnackBar(
                content: Text(AppConstants.errorAuthSendbird),
              ),
            );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('BLoC Chat'),
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: RepositoryProvider(
          create: (_) => widget._repository,
          child: bodyWidgets[_currentIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          items: bottomBarItems,
          onTap: (index) {
            setState(
              () {
                _currentIndex = index;
              },
            );
          },
        ),
      ),
    );
  }
}

List<Widget> bodyWidgets = [
  Container(
    color: Colors.black,
  ),
  Container(
    color: Colors.red,
  ),
  Container(
    color: Colors.green,
  ),
];

List<BottomNavigationBarItem> bottomBarItems = [
  const BottomNavigationBarItem(
    label: AppConstants.textMessage,
    icon: Icon(Icons.message),
  ),
  const BottomNavigationBarItem(
    label: AppConstants.textContact,
    icon: Icon(Icons.people),
  ),
  const BottomNavigationBarItem(
    label: AppConstants.textSetting,
    icon: Icon(Icons.settings),
  )
];