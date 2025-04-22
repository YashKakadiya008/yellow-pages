import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class ImageUploadService {
  static Future<String?> uploadImage(dynamic imageFile) async {
    const String cloudinaryUrl = "https://api.cloudinary.com/v1_1/dcbx4umof/image/upload";
    const String uploadPreset = "YellowPages";
    
    try {
      var request = http.MultipartRequest("POST", Uri.parse(cloudinaryUrl))
        ..fields['upload_preset'] = uploadPreset;

      if (kIsWeb) {
        // Handle web file upload
        if (imageFile is List<int>) {
          request.files.add(http.MultipartFile.fromBytes(
            'file',
            imageFile,
            filename: 'image.jpg',
          ));
        }
      } else {
        // Handle mobile file upload
        if (imageFile is File) {
          request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));
        }
      }

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      if (response.statusCode == 200) {
        return jsonResponse['secure_url'];
      } else {
        Get.snackbar("Error", "Failed to upload image");
        return null;
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
      return null;
    }
  }
}
