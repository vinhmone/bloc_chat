import 'package:flutter/material.dart';

class MessageInput extends StatefulWidget {
  final String? placeHolder;
  final VoidCallback? onPressPlus;
  final Function(String) onPressSend;
  final Function(String?)? onEditing;
  final Function(String) onChanged;
  final bool isEditing;
  final inputController = TextEditingController();

  MessageInput({
    Key? key,
    this.placeHolder,
    this.onPressPlus,
    required this.onPressSend,
    this.onEditing,
    required this.onChanged,
    this.isEditing = false,
  }) : super(key: key);

  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
