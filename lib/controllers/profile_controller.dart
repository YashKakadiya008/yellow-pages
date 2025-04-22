import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:yellowpages/data/models/profile.dart';
import 'package:yellowpages/data/services/SharedPreferencesService.dart';
import 'package:yellowpages/utils/app_constants.dart';
import 'package:yellowpages/utils/services/helpers.dart';
import 'package:http/http.dart' as http;

import '../config/app_colors.dart';

class ProfileController extends GetxController {
  static ProfileController get to => Get.find<ProfileController>();

  RxBool isLoading = false.obs;

  // -----------------------edit profile--------------------------
  TextEditingController fullNameEditingController = TextEditingController();
  TextEditingController userNameEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController phoneNumberEditingController = TextEditingController();
  TextEditingController addressEditingController = TextEditingController();
  TextEditingController profileController = TextEditingController();

  //--------------------------change password--------------------------
  TextEditingController currentPassEditingController = TextEditingController();
  TextEditingController newPassEditingController = TextEditingController();
  TextEditingController confirmEditingController = TextEditingController();

  Rx<User> user = User().obs;
  @override
  void onInit() {
    super.onInit();
    fetchUserData(); // Fetch user data when the controller is initialized
  }

  Future<void> fetchUserData() async {
    isLoading.value = true;
    final url = "${AppConstants.baseUri}/user";
    final token = await SharedPreferencesService.getAccessToken();
    print('token: $token');
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        User fetchedUser = User.fromJson(data['user']);
        user.value = fetchedUser;
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (error) {
      print('Error fetching user data: $error');
    } finally {
      isLoading.value = false;
    }
  }

  void updateUser(User updatedUser) {
    user.value = updatedUser;
    update();
    // You can add additional logic to update user on the server here
  }

  RxString currentPassVal = "".obs;
  RxString newPassVal = "".obs;
  RxString confirmPassVal = "".obs;

  bool currentPassShow = true;
  bool isNewPassShow = true;
  bool isConfirmPassShow = true;

  currentPassObscure() {
    currentPassShow = !currentPassShow;
    update();
  }

  newPassObscure() {
    isNewPassShow = !isNewPassShow;
    update();
  }

  confirmPassObscure() {
    isConfirmPassShow = !isConfirmPassShow;
    update();
  }

  void validateUpdatePass() {
    if (newPassVal.value != confirmPassVal.value) {
      Helpers.showToast(
        msg: "New Password and Confirm Password didn't match!",
        gravity: ToastGravity.CENTER,
        bgColor: AppColors.redColor,
      );
    } else {}
  }
}
