import 'package:bloc/bloc.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  CollectionReference messages =
      FirebaseFirestore.instance.collection(KMessagesCollection);

  void sendMessage({required String message, required String email}) async {
    List<Message> currentMessages = [];
    if (state is ChatSuccess) {
      currentMessages = List<Message>.from((state as ChatSuccess).messageList);
    } else if (state is ChatLoading) {
      currentMessages = List<Message>.from((state as ChatLoading).messageList);
    }
    final tempMsg = Message(message, email, isLoading: true);
    currentMessages.add(tempMsg);
    emit(ChatLoading(messageList: currentMessages));

    try {
      await messages.add({
        KMessages: message,
        KCreatedAt: DateTime.now(),
        KEmail: email,
      });
      // عند النجاح، getMessages سيجلب الرسائل من السيرفر وتختفي علامة الساعة تلقائياً
    } catch (e) {
      // عند الفشل، غيّر الرسالة الأخيرة إلى isFailed
      currentMessages.remove(tempMsg);
      currentMessages.add(Message(message, email, isFailed: true));
      emit(ChatSuccess(messageList: currentMessages));
    }
  }

  void getMessages() {
    messages.orderBy(KCreatedAt).snapshots().listen((event) {
      List<Message> messageList = [];
      for (var doc in event.docs) {
        messageList.add(Message.fromJson(doc));
      }
      emit(ChatSuccess(messageList: messageList));
    });
  }
}
