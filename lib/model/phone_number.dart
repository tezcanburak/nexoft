import 'package:nexoft/exports.dart';

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
      RegExp turkishPhoneNumberRegExp = RegExp(r'^(5\d{9})$');
      var replacedValue = value.replaceAll(' ', '');
      String phoneNumber = replacedValue; // Example phone number
      if (turkishPhoneNumberRegExp.hasMatch(phoneNumber)) {
        return PhoneNumber(value: replacedValue, showError: false);
      } else {
        return PhoneNumber(value: replacedValue, showError: true, errorMessage: 'invalid');
      }
    }
    return PhoneNumber(value: value, showError: false);
  }

  @override
  List<Object?> get props => [
        value,
        showError,
        errorMessage,
      ];
}
