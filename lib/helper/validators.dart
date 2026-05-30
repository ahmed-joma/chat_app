/// دوال تحقّق مشتركة لحقول النماذج.
class Validators {
  Validators._();

  static final _emailRegExp = RegExp(r'^[\w.\-]+@[\w\-]+\.[\w.\-]+$');

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Email is required';
    if (!_emailRegExp.hasMatch(text)) return 'Enter a valid email';
    return null;
  }

  static String? password(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return 'Password is required';
    if (text.length < 6) return 'Password must be at least 6 characters';
    return null;
  }
}
