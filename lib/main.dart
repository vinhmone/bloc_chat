import 'package:bloc_chat/data/repository/authentication_repository.dart';
import 'package:bloc_chat/ui/app/view/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

// late final SendbirdSdk sendbird;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // sendbird = SendbirdSdk(appId: '7B3D3223-0109-4478-8461-62731F2D1AD2');
  final authenticationRepository = AuthenticationRepositoryImpl();
  runApp(App(authenticationRepository: authenticationRepository));
}
