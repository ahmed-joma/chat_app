import 'package:flutter/material.dart';

// ignore: must_be_immutable, camel_case_types
class  custemFormTextFiled extends StatelessWidget {
  custemFormTextFiled(
      {super.key, this.hintText, this.onChanged, this.obscureText = false});
  Function(String)? onChanged;
  String? hintText;
  bool obscureText; //عشان اخفي النص في الباسبورد
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      // ignore: body_might_complete_normally_nullable
      validator: (data) {
        if (data!.isEmpty) {
          return 'faild is required';
        }
      },
      onChanged: onChanged, //بتقول لتطبيق انوا في شي اتغير ماذا تريد ان تفعل
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle:const TextStyle(
          color: Colors.white, //لون الخط
        ),
        border:const OutlineInputBorder(
          //نوع من انواع البوردر
          borderSide: BorderSide(
            //بستخدم البوردر سايد عشان اقدر ارفق لون
            color: Colors.white,
          ),
        ),
        enabledBorder:const  OutlineInputBorder(
          //نوع من انواع البوردر
          borderSide: BorderSide(
            //بستخدم البوردر سايد عشان اقدر ارفق لون
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
