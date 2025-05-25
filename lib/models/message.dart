import 'package:chat_app/constants.dart';

class Message {
  final String message;
  final String kEmail;
  final bool isFailed;
  final bool isLoading;

  Message(this.message, this.kEmail,
      {this.isFailed = false, this.isLoading = false});

  factory Message.fromJson(json) {
    return Message(json[KMessages], json[KEmail]);
  }
}
