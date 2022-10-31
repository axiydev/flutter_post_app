import 'dart:developer';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class FileConvert {
  static File? convertFileFromXFile(XFile xfile) {
    try {
      final File file = File(xfile.path);
      return file;
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
