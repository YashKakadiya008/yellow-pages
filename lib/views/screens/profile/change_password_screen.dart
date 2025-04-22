import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yellowpages/config/dimensions.dart';
import 'package:yellowpages/data/services/SharedPreferencesService.dart';
import 'package:yellowpages/themes/themes.dart';
import 'package:yellowpages/utils/services/helpers.dart';
import 'package:yellowpages/views/widgets/custom_appbar.dart';
import 'package:yellowpages/views/widgets/custom_textfield.dart';
import 'package:yellowpages/views/widgets/spacing.dart';
import '../../../config/app_colors.dart';
import '../../../utils/app_constants.dart';
import 'package:http/http.dart' as http;

class ChangePasswordScreen extends StatefulWidget {
  ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController emailOrPhoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  final RxBool isOtpSent = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSendingOtp = false.obs;
  final RxString emailOrPhoneVal = ''.obs;
  final RxString otpVal = ''.obs;
  final RxString newPassVal = ''.obs;
  final RxString confirmPassVal = ''.obs;

  void sendOtp() async {
    isSendingOtp.value = true;
    final url = "${AppConstants.baseUri}/otp/send-otp";
    final token = await SharedPreferencesService.getAccessToken();

    try {
      final body = json.encode({
        "email": emailOrPhoneController.text,
      });
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        isOtpSent.value = true;
        Get.snackbar("Success", "OTP sent successfully");
      } else {
        Get.snackbar("Error", data['message'] ?? "Something went wrong");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to Send OTP");
    } finally {
      isSendingOtp.value = false;
    }
  }

  void validateUpdatePass() async {
    isLoading.value = true;
    try {
      final token = await SharedPreferencesService.getAccessToken();
      final url = "${AppConstants.baseUri}/otp/reset-password";

      final body = json.encode({
        "email": emailOrPhoneController.text,
        "otp": otpController.text,
        "newPassword": newPassController.text
      });
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );
      print(response.body);
      final data = json.decode(response.body);

      Get.snackbar("Success", "Password updated successfully");
      if (response.statusCode == 200) {
        isOtpSent.value = true;
        Get.snackbar("Success", "Password updated successfully");
      } else {
        Get.snackbar("Error", data['message'] ?? "Something went wrong");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to Update Password");
    }
    isLoading.value = false;
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? AppColors.darkCardColor
          : AppColors.mainColorWithOpacity,
      appBar: CustomAppBar(
        bgColor: Get.isDarkMode
            ? AppColors.darkCardColor
            : AppColors.mainColorWithOpacity,
        isReverseIconBgColor: true,
        title: "Change Password",
        actions: const [],
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VSpace(Dimensions.screenHeight * .05),
            Container(
              height: Dimensions.screenHeight * .85,
              width: double.maxFinite,
              padding: Dimensions.kDefaultPadding,
              decoration: BoxDecoration(
                color: AppThemes.getDarkBgColor(),
                borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
              ),
              child: Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isOtpSent.value) ...[
                        VSpace(42.h),
                        Text("Email or Phone Number", style: t.displayMedium),
                        VSpace(10.h),
                        CustomTextField(
                          height: 50.h,
                          hintext: "Enter Email or Phone Number",
                          controller: emailOrPhoneController,
                          onChanged: (v) {
                            emailOrPhoneVal.value = v;
                          },
                          bgColor: Colors.transparent,
                        ),
                        VSpace(24.h),
                        InkWell(
                          onTap: emailOrPhoneVal.value.isEmpty
                              ? null
                              : () {
                                  sendOtp();
                                },
                          borderRadius: Dimensions.kBorderRadius,
                          child: Container(
                            width: double.maxFinite,
                            height: Dimensions.buttonHeight,
                            decoration: BoxDecoration(
                              color: emailOrPhoneVal.value.isEmpty
                                  ? AppThemes.getInactiveColor()
                                  : AppColors.mainColor,
                              borderRadius: Dimensions.kBorderRadius,
                            ),
                            child: Center(
                              child: isSendingOtp.value
                                  ? Helpers.appLoader(
                                      color: AppColors.whiteColor)
                                  : Text(
                                      "Send OTP",
                                      style: t.bodyLarge?.copyWith(
                                          color: AppColors.whiteColor),
                                    ),
                            ),
                          ),
                        ),
                      ],
                      if (isOtpSent.value) ...[
                        VSpace(24.h),
                        Text("OTP", style: t.displayMedium),
                        VSpace(10.h),
                        CustomTextField(
                          height: 50.h,
                          hintext: "Enter OTP",
                          controller: otpController,
                          onChanged: (v) {
                            otpVal.value = v;
                          },
                          bgColor: Colors.transparent,
                        ),
                        VSpace(24.h),
                        Text("New Password", style: t.displayMedium),
                        VSpace(10.h),
                        CustomTextField(
                          height: 50.h,
                          obsCureText: true,
                          hintext: "Enter New Password",
                          controller: newPassController,
                          onChanged: (v) {
                            newPassVal.value = v;
                          },
                          bgColor: Colors.transparent,
                        ),
                        VSpace(24.h),
                        Text("Confirm Password", style: t.displayMedium),
                        VSpace(10.h),
                        CustomTextField(
                          height: 50.h,
                          obsCureText: true,
                          hintext: "Confirm Password",
                          controller: confirmPassController,
                          onChanged: (v) {
                            confirmPassVal.value = v;
                          },
                          bgColor: Colors.transparent,
                        ),
                        VSpace(24.h),
                        InkWell(
                          onTap: otpVal.value.isEmpty ||
                                  newPassVal.value.isEmpty ||
                                  confirmPassVal.value.isEmpty
                              ? null
                              : () {
                                  validateUpdatePass();
                                },
                          borderRadius: Dimensions.kBorderRadius,
                          child: Container(
                            width: double.maxFinite,
                            height: Dimensions.buttonHeight,
                            decoration: BoxDecoration(
                              color: otpVal.value.isEmpty ||
                                      newPassVal.value.isEmpty ||
                                      confirmPassVal.value.isEmpty
                                  ? AppThemes.getInactiveColor()
                                  : AppColors.mainColor,
                              borderRadius: Dimensions.kBorderRadius,
                            ),
                            child: Center(
                              child: isLoading.value
                                  ? Helpers.appLoader(
                                      color: AppColors.whiteColor)
                                  : Text(
                                      "Save Password",
                                      style: t.bodyLarge?.copyWith(
                                          color: AppColors.whiteColor),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
