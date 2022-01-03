import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/app/sign_in/validators.dart';

void main() {
  test('non empty String', () {
    final validator = NonEmptyStringValidator();
    expect(validator.isValid('test'), true);
  });
  test('non empty string', () {
    final validator = NonEmptyStringValidator();
    expect(validator.isValid(''), false);
  });
  test('null string', () {
    final validator = NonEmptyStringValidator();
    expect(validator.isValid(null), false);
  });
}
