import 'package:nexoft/exports.dart';

class ScreenUtil {
  static Size _screenSize = const Size(0, 0);

  static void setScreenSize(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
  }

  static Size getScreenSize() {
    return _screenSize;
  }
}
