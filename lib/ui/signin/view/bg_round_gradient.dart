import 'package:flutter/material.dart';

class BackgroundRoundGradient extends StatelessWidget {
  const BackgroundRoundGradient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.indigoAccent,
              Colors.indigo,
            ],
          ),
        ),
      ),
    );
  }
}
