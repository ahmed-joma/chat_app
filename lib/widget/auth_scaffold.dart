import 'package:chat_app/constants.dart';
import 'package:flutter/material.dart';

/// تخطيط مشترك لشاشتي الدخول والتسجيل: الشعار والعنوان والنموذج،
/// مع طبقة تحميل تغطي الشاشة أثناء عمليات المصادقة.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.formKey,
    required this.children,
    this.isLoading = false,
  });

  final String title;
  final GlobalKey<FormState> formKey;
  final List<Widget> children;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    const SizedBox(height: 120),
                    Image.asset('assets/images/scholar.png', height: 100),
                    const Text(
                      'Scolar Chat',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.white,
                        fontFamily: 'Pacifico',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...children,
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            const ModalBarrier(dismissible: false, color: Colors.black45),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
        ],
      ),
    );
  }
}
