import 'package:nexoft/exports.dart';

class CommonDecorations {
  static BoxDecoration commonUpsertUserPageDecoration() {
    return BoxDecoration(
      color: ColorConstants.white,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          offset: const Offset(0, 6),
          blurRadius: 40,
        ),
      ],
    );
  }

  static BoxDecoration pageColorBorder10() {
    return BoxDecoration(
      color: ColorConstants.pageColor,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          offset: const Offset(0, 0),
          blurRadius: 4,
        ),
      ],
    );
  }

  static BoxDecoration pageColorBorder15() {
    return BoxDecoration(
      color: ColorConstants.pageColor,
      borderRadius: BorderRadius.circular(15),
    );
  }

  static BoxDecoration whiteColorBorder12() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: ColorConstants.white,
    );
  }

  static InputDecoration textFormFieldDecoration(String hintText) {
    return InputDecoration(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      hintText: hintText,
      hintStyle: CommonStyles.bodyLargeGrey(),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: ColorConstants.black, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: ColorConstants.black, width: 1),
      ),
    );
  }

  static InputDecoration textFormFieldUnderlineDecoration(String hintText) {
    return InputDecoration(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      hintText: hintText,
      hintStyle: CommonStyles.bodyLargeGrey(),
      disabledBorder: const UnderlineInputBorder(),
    );
  }
}
