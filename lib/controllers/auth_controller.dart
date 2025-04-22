import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yellowpages/data/api_helper/Auth_helper.dart';
import 'package:yellowpages/data/services/SharedPreferencesService.dart';
import 'package:yellowpages/routes/routes_name.dart';
import 'package:yellowpages/controllers/businessController.dart';
import 'package:yellowpages/controllers/profile_controller.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find<AuthController>();

  RxBool isLoading = false.obs;
  RxBool isLogginIn = false.obs;

  void updateLoginStatus(bool status) {
    isLogginIn.value = status;
    update();
  }

  // -----------------------sign in--------------------------
  TextEditingController userNameEditingController = TextEditingController();
  TextEditingController signInPassEditingController = TextEditingController();

  RxString userNameVal = "".obs;
  RxString singInPassVal = "".obs;

  clearSignInController() {
    userNameEditingController.clear();
    signInPassEditingController.clear();
    userNameVal.value = "";
    singInPassVal.value = "";
  }

  // -----------------------sign up--------------------------
  TextEditingController fullNameEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController signUpUserNameEditingController =
      TextEditingController();
  TextEditingController phoneNumberEditingController = TextEditingController();
  TextEditingController signUpPassEditingController = TextEditingController();
  TextEditingController confirmPassEditingController = TextEditingController();

  RxString fullNameVal = "".obs;
  RxString signUpUserNameVal = "".obs;
  RxString emailVal = "".obs;
  RxString phoneNumberVal = "".obs;
  RxString signUpPassVal = "".obs;
  RxString signUpConfirmPassVal = "".obs;

  clearSignUpController() {
    fullNameEditingController.clear();
    emailEditingController.clear();
    signUpUserNameEditingController.clear();
    phoneNumberEditingController.clear();
    signUpPassEditingController.clear();
    confirmPassEditingController.clear();
    fullNameVal.value = "";
    signUpUserNameVal.value = "";
    emailVal.value = "";
    phoneNumberVal.value = "";
    signUpPassVal.value = "";
    signUpConfirmPassVal.value = "";
  }

  //------------------------forgot password----------------------
  TextEditingController forgotPassEmailEditingController =
      TextEditingController();
  TextEditingController forgotPassNewPassEditingController =
      TextEditingController();
  TextEditingController forgotPassConfirmPassEditingController =
      TextEditingController();
  TextEditingController otpEditingController1 = TextEditingController();
  TextEditingController otpEditingController2 = TextEditingController();
  TextEditingController otpEditingController3 = TextEditingController();
  TextEditingController otpEditingController4 = TextEditingController();

  RxString forgotPassEmailVal = "".obs;
  RxString forgotPassNewPassVal = "".obs;
  RxString forgotPassConfirmPassVal = "".obs;
  RxString otpVal1 = "".obs;
  RxString otpVal2 = "".obs;
  RxString otpVal3 = "".obs;
  RxString otpVal4 = "".obs;

  bool isNewPassShow = true;
  bool isConfirmPassShow = true;

  forgotPassNewPassObscure() {
    isNewPassShow = !isNewPassShow;
    update();
  }

  void signUp() {
    print("Sign up");
    isLoading.value = true; // Updating isLoading directly

    ApiHelper apiHelper = ApiHelper();
    apiHelper
        .registerUser(
      email: emailEditingController.text,
      password: signUpPassEditingController.text,
    )
        .then((value) {
      isLoading.value = false;
      if (value != null) {
        // Check if the status code is 201 (successfully registered)
        if (value['statusCode'] == 201 || value['user'] != null) {
          print("Sign up success");

          // Redirect to HomeMain page
          Get.toNamed(RoutesName.loginScreen);

          // Clear the input fields
          clearSignUpController();
        } else {
          // Handle failure in a more specific way, maybe check for the message
          print("Sign up failed: ${value['message'] ?? 'Unknown error'}");
        }
      } else {
        print("Sign up failed: No response");
      }
    }).catchError((error) {
      isLoading.value = false; // Make sure loading is false in case of error
      print("Error during sign up: $error");
      // Show error to the user if needed
    });
  }

  void signIn() {
    print("Sign in");
    isLoading.value = true; // Updating isLoading directly

    ApiHelper apiHelper = ApiHelper();
    apiHelper
        .loginUser(
      email: userNameEditingController.text,
      password: signInPassEditingController.text,
    )
        .then((value) async {
      if (value != null) {
        // Check if the status code is 200 (successfully logged in)
        if (value['statusCode'] == 200 || value['accessToken'] != null) {
          print("Sign in success");

          // Save access token and login status in shared preferences
          SharedPreferencesService.saveAccessToken(value['accessToken']);
          SharedPreferencesService.saveUserID(value['userId']);
          SharedPreferencesService.saveLoginStatus(true);

          updateLoginStatus(true);

          await Get.put(BusinessController());
          await Get.put(ProfileController());

            Get.toNamed(RoutesName.bottomNavBar);
            isLoading.value = false;

          // Clear the input fields
          clearSignInController();
        } else {
          // Handle failure in a more specific way, maybe check for the message
          print("Sign in failed: ${value['message'] ?? 'Unknown error'}");
        }
      } else {
        print("Sign in failed: No response");
      }
      isLoading.value = false;
    }).catchError((error) {
      isLoading.value = false; // Make sure loading is false in case of error
      print("Error during sign in: $error");
      // Show error to the user if needed
    });
  }

  forgotPassConfirmPassObscure() {
    isConfirmPassShow = !isConfirmPassShow;
    update();
  }

  clearForgotPassVal() {
    forgotPassEmailEditingController.clear();
    forgotPassEmailVal.value = "";
  }

  clearForgotPassNewPassVal() {
    forgotPassNewPassEditingController.clear();
    forgotPassConfirmPassEditingController.clear();
    forgotPassNewPassVal.value = "";
    forgotPassConfirmPassVal.value = "";
  }

  clearForgotPassOtpVal() {
    otpEditingController1.clear();
    otpEditingController2.clear();
    otpEditingController3.clear();
    otpEditingController4.clear();
    otpVal1.value = "";
    otpVal2.value = "";
    otpVal3.value = "";
    otpVal4.value = "";
  }
}
