// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBf_9hSi45HkP3kZkUuRa02iYDbRb644Pk',
    appId: '1:271198244563:android:74e7540b368d5d1d1cce26',
    messagingSenderId: '271198244563',
    projectId: 'chat-room-6aec1',
    databaseURL: 'https://chat-room-6aec1.firebaseio.com',
    storageBucket: 'chat-room-6aec1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD4Lj1lvF7wGuTfh5MVgOBwbDvpGPOTdW8',
    appId: '1:271198244563:ios:af49252eefb5edf11cce26',
    messagingSenderId: '271198244563',
    projectId: 'chat-room-6aec1',
    databaseURL: 'https://chat-room-6aec1.firebaseio.com',
    storageBucket: 'chat-room-6aec1.appspot.com',
    androidClientId: '271198244563-1aahu13tbg8bf7l6j096o99dgm1990n8.apps.googleusercontent.com',
    iosClientId: '271198244563-695gv4c9p4j8p4d91lba8eqnlkoroucg.apps.googleusercontent.com',
    iosBundleId: 'com.chaubacho.app',
  );
}
