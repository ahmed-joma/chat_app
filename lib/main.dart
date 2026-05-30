import 'package:chat_app/constants.dart';
import 'package:chat_app/cubit/auth_cubit/auth_cubit.dart';
import 'package:chat_app/cubit/chat_cubit/chat_cubit/cubit/chat_cubit.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/views/chat_page.dart';
import 'package:chat_app/views/login_view.dart';
import 'package:chat_app/views/sign_up_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => ChatCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryColor),
          scaffoldBackgroundColor: kPrimaryColor,
        ),
        routes: {
          LoginView.route: (_) => const LoginView(),
          SignUpView.route: (_) => const SignUpView(),
          ChatPage.route: (_) => const ChatPage(),
        },
        home: const AuthGate(),
      ),
    );
  }
}

/// يوجّه المستخدم تلقائياً حسب حالة تسجيل الدخول (تسجيل دخول دائم).
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        }
        return snapshot.hasData ? const ChatPage() : const LoginView();
      },
    );
  }
}
