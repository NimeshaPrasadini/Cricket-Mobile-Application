import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> uploadImage(
    String filePath,
    String fileName,
  ) async {
    File file = File(filePath);

    try {
      await storage.ref('Players/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  Future<firebase_storage.ListResult> listFiles() async {
    firebase_storage.ListResult results =
        await storage.ref('Players').listAll();

    results.items.forEach((firebase_storage.Reference ref) {
      print('Found files: $ref');
    });
    return results;
  }

  Future<String> downloadURL(
    String imageName,
  ) async {
    String downloadURL =
        await storage.ref('Players/$imageName').getDownloadURL();
    return downloadURL;
  }

  //News Image Upload
  Future<void> uploadNewsImage(
    String filePath,
    String fileName,
  ) async {
    File file = File(filePath);

    try {
      await storage.ref('News/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  Future<firebase_storage.ListResult> listNewsFiles() async {
    firebase_storage.ListResult results =
        await storage.ref('News').listAll();

    results.items.forEach((firebase_storage.Reference ref) {
      print('Found files: $ref');
    });
    return results;
  }

  Future<String> downloadNewsURL(
    String imageName,
  ) async {
    String downloadURL =
        await storage.ref('News/$imageName').getDownloadURL();
    return downloadURL;
  }
}
