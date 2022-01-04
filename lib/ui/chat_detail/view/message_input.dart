import 'package:bloc_chat/util/constants.dart';
import 'package:flutter/material.dart';

class MessageInput extends StatefulWidget {
  final String? placeHolder;
  final VoidCallback? onPressPlus;
  final Function(String) onPressSend;
  final Function(String) onChanged;
  final inputController = TextEditingController();

  MessageInput({
    Key? key,
    this.placeHolder,
    this.onPressPlus,
    required this.onPressSend,
    required this.onChanged,
  }) : super(key: key);

  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  bool shouldShowSendButton = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: FittedBox(
              fit: BoxFit.contain,
              alignment: Alignment.center,
              child: IconButton(
                onPressed: widget.onPressPlus,
                icon: Icon(
                  Icons.add_box_outlined,
                  color: ThemeData.light().primaryColor,
                ),
              ),
            ),
          ),
          Expanded(
            child: TextField(
              maxLines: 3,
              minLines: 1,
              decoration: const InputDecoration(
                hintText: ChatConstants.textSendAMessage,
                isDense: true,
                contentPadding: EdgeInsets.all(2),
              ),
              controller: widget.inputController,
              onChanged: (text) {
                widget.onChanged(text);
                setState(() {
                  shouldShowSendButton = (text.isNotEmpty);
                });
              },
            ),
          ),
          shouldShowSendButton
              ? SizedBox(
                  width: 50,
                  height: 50,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                    child: IconButton(
                      onPressed: () {
                        widget.onPressSend(widget.inputController.text);
                        widget.inputController.clear();
                      },
                      icon: Icon(
                        Icons.send,
                        color: ThemeData.light().primaryColor,
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
