import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class Pick {
  ImagePicker? _imagePicker;
  Pick._internal() {
    _imagePicker = ImagePicker();
  }

  static final _instance = Pick._internal();

  factory Pick() => _instance;

  Future<XFile?> getImageFromGallery() async {
    try {
      XFile? image = await _imagePicker!.pickImage(source: ImageSource.gallery);
      return image!;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<XFile?> getImageFromCamera() async {
    try {
      XFile? image = await _imagePicker!.pickImage(source: ImageSource.camera);
      return image!;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
