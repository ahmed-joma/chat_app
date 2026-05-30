import 'package:chat_app/constants.dart';
import 'package:chat_app/cubit/auth_cubit/auth_cubit.dart';
import 'package:chat_app/helper/show_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../widget/custem_button.dart';
import '../widget/custem_text_filed.dart';

// ignore: must_be_immutable
class Signupview extends StatelessWidget {
  bool isLoading = false;
  String? email;
  String? password;
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is RegisterLoadingState) {
          isLoading = true;
        } else if (state is RegisterSuccessState) {
          Navigator.pushNamed(context, '/chatPage', arguments: email);
          isLoading = false;
        } else if (state is RegisterFailureState) {
          showSnackBar(context, state.errMessages);
          isLoading = false;
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          //هذه الدالة عشان اعمل لودنج اثناء التسجيل ووضعتها فوق لسكافولد عشان بدي الصفحه كلها تتغير
          inAsyncCall: isLoading,
          child: Scaffold(
            backgroundColor: kPrimaryColor,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Form(
                key: formKey,
                child: ListView(
                  //column = listview
                  children: [
                    const SizedBox(
                      height: 170,
                    ),
                    Image.asset(
                      'assets/images/scholar.png',
                      height: 100,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Scolar Chat',
                          style: TextStyle(
                            fontSize: 35,
                            color: Colors.white,
                            fontFamily: 'Pacifico',
                          ),
                        ),
                      ],
                    ),
                    const Row(
                      children: [
                        Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    custemFormTextFiled(
                      onChanged: (data) {
                        //الداتا هذه بينحفظ بدالخلها المدخلات الي هيدخلها المستخدم ك الايمل
                        email = data; //المدخلات هتتخزن داخل الايميل
                      },
                      hintText: 'Email',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    custemFormTextFiled(
                      onChanged: (data) {
                        //الداتا هذه بينحفظ بدالخلها المدخلات الي هيدخلها المستخدم ك الباسورد
                        password = data; //المدخلات هتتخزن داخل الباسورد
                      },
                      hintText: 'password',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    custemButton(
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          BlocProvider.of<AuthCubit>(context)
                              .signUpUser(email: email!, password: password!);
                        }
                      },
                      nameButton: 'Sign Up',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text(
                        'Already have account?',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child:const Text(
                          '  Log in',
                          style: TextStyle(
                            color: Color(0xffC7EDE6),
                          ),
                        ),
                      )
                    ])
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
