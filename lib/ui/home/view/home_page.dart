import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static Route route() =>
      MaterialPageRoute(builder: (_) => const HomePage());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
    );
  }
}
