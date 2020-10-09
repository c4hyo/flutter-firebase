import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ImageConfig {
  static compressImage(String imageId, File image) async {
    final tempDir = await getTemporaryDirectory();
    final paths = tempDir.path;
    File compress = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      "$paths/img_$imageId.jpg",
      quality: 70,
    );
    return compress;
  }
}
