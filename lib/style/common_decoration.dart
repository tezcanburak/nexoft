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

  static BoxDecoration whiteTextFieldDecoration() {
    return BoxDecoration(
      color: ColorConstants.white,
      borderRadius: BorderRadius.circular(8),
    );
  }

  static InputDecoration commonLoginDecoration(String hintText) {
    return InputDecoration(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      hintText: hintText,
      hintStyle: TextStyle(
        color: ColorConstants.black,
        fontSize: 16,
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
      ),
    );
  }

  static Decoration gradientRedDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          ColorConstants.black,
          ColorConstants.green,
        ],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        stops: const [0, 1],
      ),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(32.0),
        topRight: Radius.circular(32.0),
      ),
    );
  }

  static Decoration appBarRedDecoration() {
    return BoxDecoration(
      borderRadius: const BorderRadius.only(
        bottomRight: Radius.circular(8),
        bottomLeft: Radius.circular(8),
      ),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          ColorConstants.green,
          ColorConstants.grey,
        ],
      ),
    );
  }

  static BoxDecoration bgPhotoDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      image: const DecorationImage(
        image: AssetImage(
          'assets/png/point_list_bg.png',
        ),
        fit: BoxFit.cover,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          offset: const Offset(0, 2),
          blurRadius: 2,
        ),
      ],
    );
  }
}
