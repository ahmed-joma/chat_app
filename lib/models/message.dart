import 'package:chat_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// تمثيل لرسالة محادثة واحدة.
///
/// [isLoading] و[isFailed] أعلام محلية للواجهة فقط ولا تُحفظ في Firestore.
class Message {
  final String message;
  final String senderEmail;
  final DateTime? sentAt;
  final bool isFailed;
  final bool isLoading;

  const Message(
    this.message,
    this.senderEmail, {
    this.sentAt,
    this.isFailed = false,
    this.isLoading = false,
  });

  factory Message.fromJson(DocumentSnapshot<Object?> doc) {
    final data = doc.data() as Map<String, dynamic>? ?? const {};
    final createdAt = data[kCreatedAtField];
    return Message(
      data[kMessageField] as String? ?? '',
      data[kSenderField] as String? ?? '',
      sentAt: createdAt is Timestamp ? createdAt.toDate() : null,
    );
  }
}
