import 'package:bloc_chat/data/repository/authentication_repository.dart';
import 'package:bloc_chat/ui/app/view/app.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final authenticationRepository = AuthenticationRepositoryImpl();
  runApp(App(authenticationRepository: authenticationRepository));
}
