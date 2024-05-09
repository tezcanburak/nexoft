import 'package:nexoft/exports.dart';

Color hexToColor(String hex) {
  assert(
  RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex),
  'hex color must be #rrggbb or #rrggbbaa',
  );

  return Color(
    int.parse(hex.substring(1), radix: 16) + (hex.length == 7 ? 0xff000000 : 0x00000000),
  );
}

class ColorConstants {
  static Color white = hexToColor('#FFFFFF');
  static Color pageColor = hexToColor('#F4F4F4');
  static Color grey = hexToColor('#BABABA');
  static Color black = hexToColor('#000000');
  static Color blue = hexToColor('#0075FF');
  static Color green = hexToColor('#008505');
  static Color red = hexToColor('#FF0000');
}
