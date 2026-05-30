import 'dart:async';

import 'package:chat_app/constants.dart';
import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(const ChatInitial());

  final CollectionReference<Map<String, dynamic>> _messages =
      FirebaseFirestore.instance.collection(kMessagesCollection);

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;

  /// يفتح بثاً واحداً فقط لرسائل Firestore مرتبة حسب وقت الإنشاء.
  void getMessages() {
    // نتجنب فتح أكثر من اشتراك إذا استُدعيت الدالة مرة أخرى.
    if (_subscription != null) return;

    // ترتيب تنازلي ليُعرض في قائمة معكوسة (reverse: true): الأحدث في الأسفل
    // بدون الحاجة لتحريك السكروول يدوياً.
    _subscription = _messages
        .orderBy(kCreatedAtField, descending: true)
        .snapshots()
        .listen(
      (snapshot) {
        final messageList =
            snapshot.docs.map(Message.fromJson).toList();
        emit(ChatSuccess(messageList: messageList));
      },
      onError: (_) => emit(const ChatFailure()),
    );
  }

  Future<void> sendMessage({
    required String message,
    required String email,
  }) async {
    final text = message.trim();
    if (text.isEmpty) return;

    final currentMessages = _currentMessages();
    final tempMsg = Message(text, email, isLoading: true);
    // الإرسال التفاؤلي: نعرض الرسالة فوراً ثم يصحّحها البث القادم من السيرفر.
    emit(ChatSuccess(messageList: [tempMsg, ...currentMessages]));

    try {
      await _messages.add({
        kMessageField: text,
        kCreatedAtField: FieldValue.serverTimestamp(),
        kSenderField: email,
      });
    } catch (_) {
      // عند الفشل نستبدل الرسالة المؤقتة بأخرى عليها علامة خطأ.
      final reconciled = [
        Message(text, email, isFailed: true),
        ...currentMessages,
      ];
      emit(ChatSuccess(messageList: reconciled));
    }
  }

  List<Message> _currentMessages() {
    final current = state;
    if (current is ChatSuccess) {
      return List<Message>.from(current.messageList);
    }
    return <Message>[];
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
