// ignore: unused_import
import 'package:chat_app/Views/Login_view.dart';
import 'package:chat_app/Views/SignUpview.dart';
import 'package:chat_app/Views/chat_page.dart';
import 'package:chat_app/cubit/auth_cubit/auth_cubit.dart';
import 'package:chat_app/cubit/chat_cubit/chat_cubit/cubit/chat_cubit.dart';
import 'package:chat_app/firebase_options.dart';
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
        BlocProvider(
          create: (context) => ChatCubit(),
        )
      ],
      child: MaterialApp(routes: {
        '/loginPage': (context) => loginView(),
        '/chatPage': (context) => chatPage(),
        '/signUpPage': (context) => Signupview(),
      }, debugShowCheckedModeBanner: false, initialRoute: '/loginPage'),
    );
  }
}
