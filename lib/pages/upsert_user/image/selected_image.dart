import 'package:image_picker/image_picker.dart';

class SelectedImage {
  static final SelectedImage _instance = SelectedImage._internal();

  factory SelectedImage() => _instance;

  SelectedImage._internal();

  XFile pickedImage = XFile('');
}
