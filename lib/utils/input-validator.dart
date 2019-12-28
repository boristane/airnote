import 'package:email_validator/email_validator.dart';

class InputValidator {
  static String email(String value) {
    if (value.isEmpty) {
      return "Please provide your email address";
    }
    if (!EmailValidator.validate(value)) {
      return "Please provide a valid email address";
    }
    return null;
  }

  static String password(String value) {
    if (value.isEmpty) {
      return "Please provide your password";
    }
    if (value.length < 8) {
      return "Passwords should be at leat 8 characters long";
    }
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      return 'Sorry, special characters are not allowed!';
    }
    return null;
  }

  static String name(String value) {
    if (value.isEmpty) {
      return "Please provide your name";
    }
    return null;
  }
}