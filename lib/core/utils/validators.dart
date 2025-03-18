/// Utility class for form validation
class Validators {
  /// Validates if a string is empty
  static String? validateRequired(
    String? value, {
    String message = 'This field is required',
  }) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  /// Validates email format
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validates password strength
  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    bool hasUppercase = value.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = value.contains(RegExp(r'[a-z]'));
    bool hasDigit = value.contains(RegExp(r'[0-9]'));
    bool hasSpecialChar = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (!(hasUppercase && hasLowercase && hasDigit)) {
      return 'Password must contain uppercase, lowercase, and number';
    }

    if (!hasSpecialChar) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  /// Validates if passwords match
  static String? validatePasswordMatch(
    String? password,
    String? confirmPassword,
  ) {
    if (confirmPassword == null || confirmPassword.trim().isEmpty) {
      return 'Please confirm your password';
    }

    if (password != confirmPassword) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Validates phone number format
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Phone can be optional
    }

    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');

    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[\s\-\(\)]'), ''))) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  /// Validates name (no numbers or special characters)
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }

    if (value.length < 2) {
      return 'Name must be at least 2 characters long';
    }

    if (value.contains(RegExp(r'[0-9!@#$%^&*(),.?":{}|<>]'))) {
      return 'Name should not contain numbers or special characters';
    }

    return null;
  }

  /// Validates date format
  static String? validateDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Date is required';
    }

    try {
      final date = DateTime.parse(value);
      if (date.isAfter(DateTime.now().add(const Duration(days: 365 * 100)))) {
        return 'Date is too far in the future';
      }
      return null;
    } catch (e) {
      return 'Please enter a valid date';
    }
  }
}
