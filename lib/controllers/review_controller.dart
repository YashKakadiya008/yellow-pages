import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:yellowpages/data/services/SharedPreferencesService.dart';
import 'package:yellowpages/utils/app_constants.dart';

class ReviewController extends GetxController {
  var rating = 0.0.obs;
  var feedback = ''.obs;
  var images = <File>[].obs;
  var isLoading = false.obs;

  // update isloading
  void onLoading(bool value) {
    isLoading.value = value;
  }
}
