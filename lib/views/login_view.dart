import 'package:chat_app/cubit/auth_cubit/auth_cubit.dart';
import 'package:chat_app/helper/show_snack_bar.dart';
import 'package:chat_app/helper/validators.dart';
import 'package:chat_app/views/sign_up_view.dart';
import 'package:chat_app/widget/auth_scaffold.dart';
import 'package:chat_app/widget/custom_button.dart';
import 'package:chat_app/widget/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  static const route = '/loginPage';

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
      context.read<AuthCubit>().logInUser(
            email: _emailController.text,
            password: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginFailureState) {
          showSnackBar(context, state.errMessage);
        }
        // النجاح يتكفّل به AuthGate تلقائياً عبر تغيّر حالة المصادقة.
      },
      builder: (context, state) {
        return AuthScaffold(
          isLoading: state is LoginLoadingState,
          formKey: _formKey,
          title: 'Login',
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
            CustomButton(label: 'Login', onTap: _submit),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",
                  style: TextStyle(color: Colors.white),
                ),
                GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, SignUpView.route),
                  child: const Text(
                    '  Sign Up',
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
