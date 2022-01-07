import 'package:bloc_chat/data/repository/authentication_repository.dart';
import 'package:bloc_chat/data/repository/chat_repository.dart';
import 'package:bloc_chat/data/repository/contact_repository.dart';
import 'package:bloc_chat/ui/chat_list/chat_list.dart';
import 'package:bloc_chat/ui/contact/view/contact_page.dart';
import 'package:bloc_chat/ui/home/bloc/home_bloc.dart';
import 'package:bloc_chat/ui/setting/setting.dart';
import 'package:bloc_chat/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

const chatListPage = ChatListPage();
const contactPage = ContactPage();
const settingPage = SettingPage();

class _HomeScreenState extends State<HomeScreen> {
  final ChatRepository _chatRepository = ChatRepositoryImpl();
  final ContactRepository _contactRepository = ContactRepositoryImpl();
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
        body: MultiRepositoryProvider(
          providers: [
            RepositoryProvider(create: (_) => _chatRepository),
            RepositoryProvider(create: (_) => _contactRepository),
            RepositoryProvider(
                create: (_) => context.read<AuthenticationRepository>()),
          ],
          child: bodyWidgets[_currentIndex],
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 1,
                offset: Offset(0.0, 0.75),
              )
            ]
          ),
          child: BottomNavigationBar(
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
      ),
    );
  }

  static List<Widget> bodyWidgets = [
    chatListPage,
    contactPage,
    settingPage,
  ];

  static List<BottomNavigationBarItem> bottomBarItems = [
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
}
