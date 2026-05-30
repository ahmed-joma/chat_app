import 'package:chat_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String message;
  final String kEmail;
  final bool isFailed;
  final bool isLoading;

  Message(this.message, this.kEmail,
      {this.isFailed = false, this.isLoading = false});

  factory Message.fromJson(DocumentSnapshot<Object?> json) {
    final data = json.data() as Map<String, dynamic>;
    return Message(
      data[KMessages] as String? ?? '',
      data[KEmail] as String? ?? '',
    );
  }
}
