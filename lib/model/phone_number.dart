import 'package:nexoft/exports.dart';

enum PhoneNumberValidationError {
  /// Generic invalid error.
  lessThan2,
  moreThan50,
  containsLetter,
}

class PhoneNumber extends Equatable {
  const PhoneNumber({
    required this.value,
    this.showError = false,
    this.errorMessage,
  });

  PhoneNumber copyWith({
    String? value,
    bool? showError,
    String? errorMessage,
  }) {
    return PhoneNumber(
      value: value ?? this.value,
      showError: showError ?? this.showError,
      errorMessage: errorMessage,
    );
  }

  static const empty = PhoneNumber(value: '');
  final String value;
  final bool showError;
  final String? errorMessage;

  PhoneNumber? validator() {
    if (value != '') {
      if (value.length < 2) {
        return PhoneNumber(
          value: value,
          showError: true,
          errorMessage: _getErrorMessage(PhoneNumberValidationError.lessThan2),
        );
      }
      if (value.length > 50) {
        return PhoneNumber(
          value: value,
          showError: true,
          errorMessage: _getErrorMessage(PhoneNumberValidationError.moreThan50),
        );
      }
      if (containsLetter(value) == true) {
        return PhoneNumber(
          value: value,
          showError: true,
          errorMessage: _getErrorMessage(PhoneNumberValidationError.containsLetter),
        );
      }
      /*
      RegExp turkishPhoneNumberRegExp = RegExp(r'^(d{10})$');
      var replacedValue = value.replaceAll(' ', '');
      String phoneNumber = replacedValue; // Example phone number
      if (turkishPhoneNumberRegExp.hasMatch(phoneNumber)) {
        return PhoneNumber(value: replacedValue, showError: false);
        } else {
          return PhoneNumber(value: replacedValue, showError: true, errorMessage: 'invalid');
      }
      */
    }
    return PhoneNumber(value: value, showError: false);
  }

  bool containsLetter(String input) {
    RegExp regExp = RegExp(r'[^0-9]');
    return regExp.hasMatch(input);
  }

  String? _getErrorMessage(PhoneNumberValidationError error) {
    switch (error) {
      case PhoneNumberValidationError.lessThan2:
        return "You cannot enter less than 2 chars!";

      case PhoneNumberValidationError.moreThan50:
        return "You cannot enter more than 50 chars!";

      case PhoneNumberValidationError.containsLetter:
        return "Contains Letter!";
      default:
        return null;
    }
  }

  @override
  List<Object?> get props => [
        value,
        showError,
        errorMessage,
      ];
}
