import 'dart:io';

import 'package:charity_with_happiness_firebase/other/image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageServices {
  static StorageReference storage = FirebaseStorage.instance.ref();

  static Future<String> uploadsImage({File fileImage, String tipe}) async {
    String imageId = Uuid().v4();
    File image = await ImageConfig.compressImage(imageId, fileImage);
    StorageUploadTask uploadTask =
        storage.child("image/$tipe/photo-$imageId.jpg").putFile(image);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    String imageUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }

  static Future<void> deleteImage({String imageUrl}) async {
    StorageReference store =
        await FirebaseStorage.instance.getReferenceFromUrl(imageUrl);
    return store.delete();
  }
}
