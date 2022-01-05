import 'package:flutter/material.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

class ContactItem extends StatefulWidget {
  final User user;
  bool isSelected;

  ContactItem({
    Key? key,
    required this.user,
    this.isSelected = false,
  }) : super(key: key);

  @override
  _ContactItemState createState() => _ContactItemState();
}

class _ContactItemState extends State<ContactItem> {
  @override
  Widget build(BuildContext context) {
    final avatarUrl = widget.user.profileUrl ?? '';
    final name = widget.user.nickname;

    return ListTile(
      title: Text(name),
      leading: _buildAvatarWidget(avatarUrl),
      trailing: Checkbox(
        value: widget.isSelected,
        onChanged: (bool? value) {
          setState(() {
            widget.isSelected = value ?? false;
          });
        },
      ),
    );
  }

  Widget _buildAvatarWidget(String avatarUrl) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: Hero(
          tag: widget.user.userId,
          child: SizedBox(
            height: 22,
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: FittedBox(
                fit: BoxFit.contain,
                child: avatarUrl.isEmpty
                    ? const CircleAvatar(
                        child: Icon(Icons.person),
                      )
                    : CircleAvatar(
                        backgroundImage: NetworkImage(
                          avatarUrl,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
