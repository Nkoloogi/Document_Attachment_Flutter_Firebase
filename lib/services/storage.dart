// import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static Future<void> uploadFileBytes(Uint8List fileBytes, String fileName,
      Function(String, String) onSuccess, Function(double) onProgress) async {
    try {
      Reference ref =
          FirebaseStorage.instance.ref().child('documents/$fileName');
      UploadTask uploadTask = ref.putData(fileBytes);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = (snapshot.bytesTransferred.toDouble() /
                snapshot.totalBytes.toDouble()) *
            100;
        onProgress(progress);
      });

      TaskSnapshot completedSnapshot = await uploadTask;
      String downloadURL = await completedSnapshot.ref.getDownloadURL();

      onSuccess(downloadURL, fileName);
    } catch (e) {
      print('Error uploading file: $e');
    }
  }
}
