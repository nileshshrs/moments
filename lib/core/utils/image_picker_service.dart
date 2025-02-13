import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ImagePickerService {
  Future<Map<String, dynamic>?> uploadImageToFirebase(File imageFile) async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef =
          FirebaseStorage.instance.ref().child('posts/$fileName');

      // Upload file to Firebase
      await storageRef.putFile(imageFile);
      final imageUrl = await storageRef.getDownloadURL();

      return {
        "url": imageUrl, // Firebase Image URL
        "path": storageRef.fullPath, // Firebase Path
      };
    } catch (e) {
      debugPrint("Error uploading image: $e");
      return null;
    }
  }

  /// Delete an image from Firebase Storage
  Future<void> deleteImage(String imagePath) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(imagePath);
      await storageRef.delete();
      print("image deleted");
    } catch (e) {
      debugPrint("Error deleting image: $e");
    }
  }
}
