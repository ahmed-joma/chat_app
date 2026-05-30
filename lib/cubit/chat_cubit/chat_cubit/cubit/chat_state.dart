part of 'chat_cubit.dart';

@immutable
sealed class ChatState {
  const ChatState();
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatSuccess extends ChatState {
  final List<Message> messageList;
  const ChatSuccess({required this.messageList});
}

class ChatFailure extends ChatState {
  const ChatFailure();
}
