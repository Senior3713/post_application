import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:post_comments_with_firebase/services/db_service.dart';

sealed class StoreService {
  static final storage = FirebaseStorage.instance;

  static Future<String> uploadFile(File file) async {
    final image = storage.ref(Folder.postImages).child("image_${DateTime.now().toIso8601String()}${file.path.substring(file.path.lastIndexOf("."))}" );
    final task = image.putFile(file);
    await task.whenComplete(() {});
    return image.getDownloadURL();
  }
}