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
      return PhoneNumber(value: value, showError: false);

      /* RegExp turkishPhoneNumberRegExp = RegExp(r'^(d{10})$');
      var replacedValue = value.replaceAll(' ', '');
      String phoneNumber = replacedValue; // Example phone number
      if (turkishPhoneNumberRegExp.hasMatch(phoneNumber)) {
        return PhoneNumber(value: replacedValue, showError: false);
      } else {
        return PhoneNumber(value: replacedValue, showError: true, errorMessage: 'invalid');
      }*/
    }
    return const PhoneNumber(value: '', showError: true, errorMessage: 'invalid');
  }

  @override
  List<Object?> get props => [
        value,
        showError,
        errorMessage,
      ];
}
