part of 'chat_cubit.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {
  final List<Message> messageList;
  ChatLoading({required this.messageList});
}

class ChatSuccess extends ChatState {
  final List<Message> messageList;
  ChatSuccess({required this.messageList});
}

class ChatFailure extends ChatState {
  final Message failedMessage;
  ChatFailure({required this.failedMessage});
}

class ChatDelete extends ChatState {}
