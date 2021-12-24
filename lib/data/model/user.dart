import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class People extends Equatable {
  final String uid;
  final String email;
  final String? name;
  final String? photo;

  const People({required this.uid, required this.email, this.name, this.photo});

  static const empty = People(uid: '', email: '');

  bool get isEmpty => this == People.empty;

  factory People.fromUser(User user) {
    return People(
      uid: user.uid,
      email: user.email ?? '',
      name: user.displayName,
      photo: user.photoURL,
    );
  }

  @override
  List<Object?> get props => [uid, email, name, photo];
}
