import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:image_picker/image_picker.dart';

class StorageServisi {
  final FirebaseStorage _storage = FirebaseStorage.instance






  Future<String> urlGetir(Reference ref) async {
    return await ref.getDownloadURL();
  }

  Future<void> dosyaSil(String dosyaYolu) async {
    final Reference ref
  }
}