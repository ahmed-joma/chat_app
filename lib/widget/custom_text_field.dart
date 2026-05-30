import 'package:flutter/material.dart';

/// حقل إدخال موحّد بنمط فاتح فوق خلفية التطبيق الداكنة.
class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
  });

  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    const white = Colors.white;
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: const TextStyle(color: white),
      cursorColor: white,
      validator: validator ??
          (value) =>
              (value == null || value.trim().isEmpty) ? 'This field is required' : null,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: white),
        suffixIcon: suffixIcon,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: white),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: white, width: 2),
        ),
        errorStyle: const TextStyle(color: Color(0xffFFD7D7)),
      ),
    );
  }
}
