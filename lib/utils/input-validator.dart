import 'package:email_validator/email_validator.dart';

class InputValidator {
  static String email(String value) {
    if (value.isEmpty) {
      return "Please provide your email address";
    }
    if (!EmailValidator.validate(value.trim())) {
      return "Please provide a valid email address";
    }
    return null;
  }

  static String password(String value) {
    if (value.trim().isEmpty) {
      return "Please provide your password";
    }
    if (value.trim().length < 8) {
      return "Passwords should be at leat 8 characters long";
    }
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      return 'Sorry, special characters are not allowed!';
    }
    return null;
  }

  static String passPhrase(String value) {
    if (value.trim().isEmpty) {
      return "Please provide your pass phrase";
    }
    if (value.length < 15) {
      return "Passwords should be at leat 15 characters long";
    }
    return null;
  }

  static String name(String value) {
    if (value.trim().isEmpty) {
      return "Please provide your name";
    }
    return null;
  }

  static String title(String value) {
    if (value.trim().isEmpty) {
      return "Please enter a headline";
    }
    return null;
  }

  static String promotionCode(String value) {
    if (value.trim().isEmpty) {
      return "Please enter a promotion code";
    }
    return null;
  }

  static String content(String value) {
    if (value.trim().isEmpty) {
      return 'Hey! You haven\'t told me anything yet!';
    }
    return null;
  }
}