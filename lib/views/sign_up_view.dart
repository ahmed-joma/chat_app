import 'package:chat_app/cubit/auth_cubit/auth_cubit.dart';
import 'package:chat_app/helper/show_snack_bar.dart';
import 'package:chat_app/helper/validators.dart';
import 'package:chat_app/widget/auth_scaffold.dart';
import 'package:chat_app/widget/custom_button.dart';
import 'package:chat_app/widget/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  static const route = '/signUpPage';

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().signUpUser(
            email: _emailController.text,
            password: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is RegisterFailureState) {
          showSnackBar(context, state.errMessages);
        } else if (state is RegisterSuccessState) {
          // نعود للجذر ليتكفّل AuthGate بعرض المحادثة بعد إنشاء الحساب.
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      },
      builder: (context, state) {
        return AuthScaffold(
          isLoading: state is RegisterLoadingState,
          formKey: _formKey,
          title: 'Sign Up',
          children: [
            CustomTextField(
              controller: _emailController,
              hintText: 'Email',
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: _passwordController,
              hintText: 'Password',
              obscureText: _obscure,
              validator: Validators.password,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(label: 'Sign Up', onTap: _submit),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account?',
                  style: TextStyle(color: Colors.white),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    '  Log in',
                    style: TextStyle(color: Color(0xffC7EDE6)),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
