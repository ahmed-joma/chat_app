import 'package:chat_app/constants.dart';
import 'package:chat_app/models/message.dart';
import 'package:flutter/material.dart';

/// فقاعة رسالة المستخدم الحالي (تظهر على اليمين).
class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (message.isLoading)
            const Padding(
              padding: EdgeInsets.only(right: 4, bottom: 12),
              child: Icon(Icons.access_time, color: Colors.grey, size: 18),
            ),
          if (!message.isLoading && message.isFailed)
            const Padding(
              padding: EdgeInsets.only(right: 4, bottom: 12),
              child: Icon(Icons.error, color: Colors.red, size: 18),
            ),
          Flexible(
            child: _Bubble(
              message: message,
              color: kPrimaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// فقاعة رسالة الطرف الآخر (تظهر على اليسار).
class FriendChatBubble extends StatelessWidget {
  const FriendChatBubble({super.key, required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: _Bubble(
        message: message,
        color: Colors.orange,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({
    required this.message,
    required this.color,
    required this.borderRadius,
  });

  final Message message;
  final Color color;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
      decoration: BoxDecoration(color: color, borderRadius: borderRadius),
      child: Text(
        message.message,
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ),
    );
  }
}
