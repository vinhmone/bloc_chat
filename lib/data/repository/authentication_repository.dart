import 'dart:developer';
import 'dart:io';

import 'package:bloc_chat/data/model/user.dart';
import 'package:bloc_chat/util/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sendbird_sdk/constant/enums.dart';
import 'package:sendbird_sdk/core/models/file_info.dart';
import 'package:sendbird_sdk/sdk/sendbird_sdk_api.dart';

abstract class AuthenticationRepository {
  Stream<People> get people;

  People get currentPeople;

  Future<void> signup(
      {required String email, required String password, String? username});

  Future<void> signinToFirebase(
      {required String email, required String password});

  Future<void> signout();

  Future<void> signinToSendbird();

  Future<void> updateUser({File? file, String? name});
}

late final SendbirdSdk sendbird;

class AuthenticationRepositoryImpl extends AuthenticationRepository {
  final FirebaseAuth _firebaseAuth;

  AuthenticationRepositoryImpl({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance {
    initSendbird();
  }

  @override
  People get currentPeople => (_firebaseAuth.currentUser != null)
      ? People.fromUser(_firebaseAuth.currentUser!)
      : People.empty;

  void initSendbird() {
    try {
      sendbird = SendbirdSdk(
        appId: AppConstants.sendbirdAppID,
        apiToken: AppConstants.sendbirdApiToken,
      );
    } catch (e) {}
  }

  @override
  Future<void> signinToFirebase(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw e.code;
    } catch (_) {
      throw AppConstants.unknownException;
    }
  }

  @override
  Future<void> signinToSendbird() async {
    try {
      sendbird.setLogLevel(LogLevel.error);
      //TODO change to firebase uid
      await sendbird.connect(_firebaseAuth.currentUser?.uid ?? '');
      // await sendbird.connect('vinh');
    } catch (_) {
      throw AppConstants.errorAuthSendbird;
    }
  }

  @override
  Future<void> signout() async {
    try {
      await _firebaseAuth.signOut();
      await sendbird.disconnect();
    } catch (_) {
      throw AppConstants.unknownException;
    }
  }

  @override
  Future<void> signup(
      {required String email,
      required String password,
      String? username}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _firebaseAuth.currentUser?.updateDisplayName(username);
      (username != null)
          ? sendbird.currentUser?.nickname = username
          : sendbird.currentUser?.nickname = email;
    } on FirebaseAuthException catch (e) {
      throw e.code;
    } catch (_) {
      throw AppConstants.unknownException;
    }
  }

  @override
  Future<void> updateUser({File? file, String? name}) async {
    try {
      log(file?.path ?? 'null');
      if (name != null) {
        await sendbird.updateCurrentUserInfo(
          nickname: name,
          fileInfo: FileInfo.fromData(
            name: 'avatar',
            file: file,
            mimeType: 'image/jpeg',
          ),
        );
      }
      // if (file != null) sendbird.currentUser?.p
    } catch (e) {
      log(e.toString());
      throw Exception(AppConstants.unknownException);
    }
  }

  @override
  Stream<People> get people {
    return _firebaseAuth.authStateChanges().map((user) {
      return user != null ? People.fromUser(user) : People.empty;
    });
  }
}
