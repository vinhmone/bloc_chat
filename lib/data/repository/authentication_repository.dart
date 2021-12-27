import 'package:bloc_chat/data/model/user.dart';
import 'package:bloc_chat/util/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationRepository {
  Stream<People> get people;

  People get currentPeople;

  Future<void> signup({required String email, required String password});

  Future<void> signin({required String email, required String password});

  Future<void> signout();
}

class AuthenticationRepositoryImpl extends AuthenticationRepository {
  final FirebaseAuth _firebaseAuth;

  AuthenticationRepositoryImpl({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  People get currentPeople => (_firebaseAuth.currentUser != null)
      ? People.fromUser(_firebaseAuth.currentUser!)
      : People.empty;

  @override
  Future<void> signin({required String email, required String password}) async {
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
  Future<void> signout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (_) {
      throw AppConstants.unknownException;
    }
  }

  // TODO change username
  @override
  Future<void> signup({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw e.code;
    } catch (_) {
      throw AppConstants.unknownException;
    }
  }

  @override
  Stream<People> get people {
    return _firebaseAuth.authStateChanges().map((user) {
      return user != null ? People.fromUser(user) : People.empty;
    });
  }
}
