import 'package:nexoft/exports.dart';

enum NameValidationError {
  /// Generic invalid error.
  lessThan3,
  moreThan50,
  containsSymbol,
}

class Name extends Equatable {
  const Name({
    required this.value,
    this.showError = false,
    this.errorMessage,
  });

  Name copyWith({
    String? value,
    bool? showError,
    String? errorMessage,
  }) {
    return Name(
      value: value ?? this.value,
      showError: showError ?? this.showError,
      errorMessage: errorMessage,
    );
  }

  static const empty = Name(value: '');
  final String value;
  final bool showError;
  final String? errorMessage;

  Name? validator() {
    if (value != '') {
      /// TODO: Redundant initilization to 'null'.
      ///
      if (value.length < 3) {
        return Name(
          value: value,
          showError: true,
          errorMessage: _getErrorMessage(NameValidationError.lessThan3),
        );
      }

      if (value.length > 50) {
        return Name(
          value: value,
          showError: true,
          errorMessage: _getErrorMessage(NameValidationError.moreThan50),
        );
      }

      if (containsNonLetter(value) == true) {
        return Name(
          value: value,
          showError: true,
          errorMessage: _getErrorMessage(NameValidationError.containsSymbol),
        );
      }
    }
    return Name(value: value, showError: false);
  }

  /// TODO: This RegExp doesn't contain Turkish characters!!!
  bool containsNonLetter(String input) {
    RegExp regExp = RegExp(r'[^a-zA-Z]');
    return regExp.hasMatch(input);
  }

  String? _getErrorMessage(NameValidationError error) {
    switch (error) {
      case NameValidationError.lessThan3:
        return "lessThan3";

      case NameValidationError.moreThan50:
        return "moreThan50";

      case NameValidationError.containsSymbol:
        return "containsSymbol";
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
