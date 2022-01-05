import 'package:flutter/material.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

class ContactDetail extends StatelessWidget {
  final User user;

  const ContactDetail({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildAvatarWidget(context, user.profileUrl ?? ''),
          Text(
            user.nickname,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Send Private Message'),
                const SizedBox(
                  width: 4,
                ),
                Icon(
                  Icons.send,
                  color: ThemeData.light().primaryColor,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAvatarWidget(BuildContext context, String avatarUrl) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.2,
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
    );
  }
}
