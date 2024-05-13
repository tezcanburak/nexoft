import 'package:nexoft/exports.dart';

enum NameValidationError {
  /// Generic invalid error.
  lessThan2,
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
      if (value.length < 2) {
        return Name(
          value: value,
          showError: true,
          errorMessage: _getErrorMessage(NameValidationError.lessThan2),
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

  bool containsNonLetter(String input) {
    RegExp regExp = RegExp(r'[^a-zA-ZğüşöçİĞÜŞÖÇ]');
    return regExp.hasMatch(input);
  }

  String? _getErrorMessage(NameValidationError error) {
    switch (error) {
      case NameValidationError.lessThan2:
        return "You cannot enter less than 2 chars!";

      case NameValidationError.moreThan50:
        return "You cannot enter more than 50 chars!";

      case NameValidationError.containsSymbol:
        return "Contains Symbol!";
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
