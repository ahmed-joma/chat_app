import 'package:chat_app/constants.dart';
import 'package:chat_app/cubit/chat_cubit/chat_cubit/cubit/chat_cubit.dart';
import 'package:chat_app/widget/chat_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  static const route = '/chatPage';

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _controller = TextEditingController();
  late final String _email = FirebaseAuth.instance.currentUser?.email ?? '';

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().getMessages();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    context.read<ChatCubit>().sendMessage(message: text, email: _email);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/scholar.png', height: 50),
            const SizedBox(width: 8),
            const Text(
              'Chat',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontFamily: 'Pacifico',
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                if (state is ChatFailure) {
                  return const Center(
                    child: Text('Failed to load messages.'),
                  );
                }
                if (state is! ChatSuccess) {
                  return const Center(child: CircularProgressIndicator());
                }
                final messages = state.messageList;
                if (messages.isEmpty) {
                  return const Center(
                    child: Text(
                      'No messages yet. Say hi! 👋',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }
                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return message.senderEmail == _email
                        ? ChatBubble(message: message)
                        : FriendChatBubble(message: message);
                  },
                );
              },
            ),
          ),
          _MessageComposer(controller: _controller, onSend: _send),
        ],
      ),
    );
  }
}

class _MessageComposer extends StatelessWidget {
  const _MessageComposer({required this.controller, required this.onSend});

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
        child: TextField(
          controller: controller,
          textInputAction: TextInputAction.send,
          onSubmitted: (_) => onSend(),
          decoration: InputDecoration(
            hintText: 'Type a message...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: kPrimaryColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: kPrimaryColor),
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.send, color: kPrimaryColor),
              onPressed: onSend,
            ),
          ),
        ),
      ),
    );
  }
}
