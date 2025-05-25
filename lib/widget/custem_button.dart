import 'package:flutter/material.dart';

// ignore: must_be_immutable
class custemButton extends StatelessWidget {
  custemButton({super.key, required this.nameButton, this.onTap});
  String? nameButton;
  VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector( //بستخدم الجستشر للتفاعل مع الزرار
      onTap: onTap, //التفاعل بيكون عند الضغط علي الزرار
      //عندما ينقر المستخدم على العنصر، يتم تشغيل الكود داخل onTap.
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        width: double.infinity,
        height: 60,
        child: Center(
          child: Text(
            nameButton!,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
