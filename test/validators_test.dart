import 'package:chat_app/helper/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators.email', () {
    test('rejects empty input', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email('   '), isNotNull);
      expect(Validators.email(null), isNotNull);
    });

    test('rejects malformed addresses', () {
      expect(Validators.email('not-an-email'), isNotNull);
      expect(Validators.email('foo@bar'), isNotNull);
      expect(Validators.email('foo@@bar.com'), isNotNull);
    });

    test('accepts well-formed addresses', () {
      expect(Validators.email('user@example.com'), isNull);
      expect(Validators.email('  user.name-1@sub.example.co  '), isNull);
    });
  });

  group('Validators.password', () {
    test('rejects empty or short passwords', () {
      expect(Validators.password(''), isNotNull);
      expect(Validators.password('123'), isNotNull);
      expect(Validators.password(null), isNotNull);
    });

    test('accepts passwords of at least 6 characters', () {
      expect(Validators.password('123456'), isNull);
      expect(Validators.password('a strong password'), isNull);
    });
  });
}
