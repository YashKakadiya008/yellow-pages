import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yellowpages/config/dimensions.dart';
import 'package:yellowpages/controllers/auth_controller.dart';
import 'package:yellowpages/routes/routes_name.dart';
import 'package:yellowpages/themes/themes.dart';
import 'package:yellowpages/utils/app_constants.dart';
import 'package:yellowpages/utils/services/helpers.dart';
import 'package:yellowpages/views/widgets/appDialog.dart';
import 'package:yellowpages/views/widgets/app_button.dart';
import 'package:yellowpages/views/widgets/app_textfield.dart';
import 'package:yellowpages/views/widgets/mediaquery_extension.dart';
import 'package:yellowpages/views/widgets/spacing.dart';

import '../../../config/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isRemember = false;
  @override
  Widget build(BuildContext context) {
    AuthController controller = Get.find<AuthController>();
    TextTheme t = Theme.of(context).textTheme;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                "$rootImageDir/login_bg_top.png",
                height: context.mQuery.height * .22,
                color: AppColors.mainColor.withOpacity(.06),
                fit: BoxFit.cover,
              )),
          Positioned(
              left: 0,
              right: 0,
              top: context.mQuery.height * .08,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Yellow Pages",
                    style: t.titleLarge?.copyWith(fontSize: 35.sp),
                  ),
                  Stack(
                    children: [
                      Image.asset(
                        "$rootIconDir/app_icon_main.png",
                        width: 62.w,
                        height: 36.h,
                      ),
                      Get.isDarkMode
                          ? Positioned(
                              left: 4.5.w,
                              top: 3.5.h,
                              child: Icon(
                                Icons.location_on_outlined,
                                size: 27.h,
                                color: AppThemes.getIconBlackColor(),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ],
              )),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                "$rootImageDir/login_bg_bottom.png",
                height: context.mQuery.height * .15,
                color: AppColors.mainColor.withOpacity(.06),
                fit: BoxFit.cover,
              )),
          Positioned(
            top: context.mQuery.height * .26,
            left: 0,
            right: 0,
            child: SizedBox(
              height: context.mQuery.height * .6,
              child: SingleChildScrollView(
                child: Padding(
                  padding: Dimensions.kDefaultPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Log In", style: t.titleLarge),
                      VSpace(5.h),
                      Text("Hello there, log in to continue!",
                          style: t.displayMedium
                              ?.copyWith(color: AppThemes.getGreyColor())),
                      VSpace(50.h),
                      Container(
                        padding: EdgeInsets.only(bottom: 15.h),
                        decoration: const BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(color: AppColors.dividerColor)),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              "$rootImageDir/person.png",
                              height: 16.h,
                              width: 16.h,
                              color: AppThemes.getGreyColor(),
                            ),
                            Expanded(
                                child: AppTextField(
                                    controller:
                                        controller.userNameEditingController,
                                    onChanged: (v) {
                                      controller.userNameVal.value = v;
                                    },
                                    hinText: "Username or Email")),
                          ],
                        ),
                      ),
                      VSpace(28.h),
                      GetBuilder(
                          init: AuthController(),
                          builder: (_) {
                            return Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: AppColors.dividerColor)),
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "$rootImageDir/lock.png",
                                    height: 16.h,
                                    width: 16.h,
                                    color: AppThemes.getGreyColor(),
                                  ),
                                  Expanded(
                                      child: AppTextField(
                                          controller: controller
                                              .signInPassEditingController,
                                          onChanged: (v) {
                                            controller.singInPassVal.value = v;
                                          },
                                          obscureText: controller.isNewPassShow
                                              ? true
                                              : false,
                                          hinText: "Password")),
                                  IconButton(
                                      onPressed: () {
                                        controller.forgotPassNewPassObscure();
                                      },
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      icon: Image.asset(
                                        controller.isNewPassShow
                                            ? "$rootImageDir/hide.png"
                                            : "$rootImageDir/show.png",
                                        height: 20.h,
                                        width: 20.w,
                                      )),
                                ],
                              ),
                            );
                          }),
                      VSpace(29.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isRemember = !isRemember;
                              });
                            },
                            child: Row(
                              children: [
                                Transform.scale(
                                  scale: .82,
                                  child: Checkbox(
                                      checkColor: AppThemes.getIconBlackColor(),
                                      activeColor: AppColors.mainColor,
                                      visualDensity: const VisualDensity(
                                        horizontal:
                                            -4.0, // Adjust the horizontal padding
                                        vertical:
                                            -4.0, // Adjust the vertical padding
                                      ),
                                      side: BorderSide(
                                        color: AppThemes.getHintColor(),
                                      ),
                                      value: isRemember,
                                      onChanged: (v) {
                                        setState(() {
                                          isRemember = v!;
                                        });
                                      }),
                                ),
                                HSpace(5.w),
                                Text(
                                  "Remember me",
                                  style: t.displayMedium?.copyWith(
                                      color: AppThemes.getHintColor()),
                                )
                              ],
                            ),
                          ),
                          // InkWell(
                          //   onTap: () {
                          //     buildForgotPassDialog(context, t, controller);
                          //   },
                          //   child: Container(
                          //       padding: EdgeInsets.symmetric(vertical: 8.h),
                          //       child: Text(
                          //         "Forgot Your Password?",
                          //         style: t.displayMedium
                          //             ?.copyWith(color: AppColors.mainColor),
                          //       )),
                          // )
                        ],
                      ),
                      VSpace(48.h),
                      Obx(
                        () => AppButton(
                          text: "Log In",
                          isLoading: controller.isLoading.value ? true : false,
                          bgColor: AppColors.mainColor,
                          onTap: () {
                            controller.signIn();
                          },
                        ),
                      ),
                      // Obx(
                      //   () => AppButton(
                      //     text: "Log In",
                      //     isLoading: controller.isLoading.value ? true : false,
                      //     bgColor: controller.userNameVal.value.isEmpty ||
                      //             controller.singInPassVal.value.isEmpty
                      //         ? AppThemes.getInactiveColor()
                      //         : AppColors.mainColor,
                      //     onTap: controller.userNameVal.value.isEmpty ||
                      //             controller.singInPassVal.value.isEmpty
                      //         ? null
                      //         : () {
                      //             Get.toNamed(RoutesName.bottomNavBar);
                      //           },
                      //   ),
                      // ),
                      VSpace(32.h),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Don’t have an account?",
                          style: t.displayMedium
                              ?.copyWith(color: AppThemes.getHintColor()),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {
                            Get.toNamed(RoutesName.signUpScreen);
                          },
                          child: Text(
                            "Create account",
                            style: t.displayMedium
                                ?.copyWith(color: AppColors.mainColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  buildForgotPassDialog(
      BuildContext context, TextTheme t, AuthController controller) {
    appDialog(
      context: context,
      title: Align(
        alignment: Alignment.center,
        child: Text(
          "Forgot Password",
          style: t.titleLarge?.copyWith(color: AppColors.mainColor),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
              alignment: Alignment.center,
              child: Text(
                "Please enter your email address to\nreceive a verification code",
                textAlign: TextAlign.center,
                style: t.displayMedium
                    ?.copyWith(color: AppThemes.getGreyColor(), height: 1.7),
              )),
          VSpace(32.h),
          Container(
            padding: EdgeInsets.only(bottom: 15.h),
            decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: AppThemes.getHintColor())),
            ),
            child: Row(
              children: [
                Image.asset(
                  "$rootImageDir/person.png",
                  height: 16.h,
                  width: 16.h,
                  color: AppThemes.getGreyColor(),
                ),
                Expanded(
                    child: AppTextField(
                        controller: controller.forgotPassEmailEditingController,
                        onChanged: (v) {
                          controller.forgotPassEmailVal.value = v;
                          if (!v.contains('@')) {
                            controller.forgotPassEmailVal.value = "";
                            controller.update();
                          }
                        },
                        hinText: "Enter your Email")),
              ],
            ),
          ),
          VSpace(32.h),
          Obx(
            () => AppButton(
              isLoading: controller.isLoading.value ? true : false,
              bgColor: controller.forgotPassEmailVal.value.isEmpty
                  ? AppThemes.getInactiveColor()
                  : AppColors.mainColor,
              onTap: controller.forgotPassEmailVal.value.isEmpty
                  ? null
                  : () {
                      Get.back();
                      buildOtpDialog(context, t, controller);
                    },
            ),
          ),
        ],
      ),
    );
  }

  buildNewPassDialog(
      BuildContext context, TextTheme t, AuthController controller) {
    appDialog(
      context: context,
      title: Align(
        alignment: Alignment.center,
        child: Text(
          "Create New Password",
          style: t.titleLarge?.copyWith(color: AppColors.mainColor),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
              alignment: Alignment.center,
              child: Text(
                "Set the new password for your account so that you can login and access all the features.",
                textAlign: TextAlign.center,
                style: t.displayMedium
                    ?.copyWith(color: AppThemes.getGreyColor(), height: 1.7),
              )),
          VSpace(32.h),
          GetBuilder<AuthController>(builder: (_) {
            return Container(
              decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: AppThemes.getHintColor())),
              ),
              child: Row(
                children: [
                  Image.asset(
                    "$rootImageDir/lock.png",
                    height: 16.h,
                    width: 16.h,
                    color: AppThemes.getGreyColor(),
                  ),
                  Expanded(
                      child: AppTextField(
                          controller:
                              controller.forgotPassNewPassEditingController,
                          onChanged: (v) {
                            controller.forgotPassNewPassVal.value = v;
                          },
                          obscureText: controller.isNewPassShow ? true : false,
                          hinText: "New Password")),
                  IconButton(
                      onPressed: () {
                        controller.forgotPassNewPassObscure();
                      },
                      icon: Image.asset(
                        controller.isNewPassShow
                            ? "$rootImageDir/hide.png"
                            : "$rootImageDir/show.png",
                        height: 20.h,
                        width: 20.w,
                      )),
                ],
              ),
            );
          }),
          VSpace(32.h),
          GetBuilder<AuthController>(builder: (_) {
            return Container(
              decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: AppThemes.getHintColor())),
              ),
              child: Row(
                children: [
                  Image.asset(
                    "$rootImageDir/lock.png",
                    height: 16.h,
                    width: 16.h,
                    color: AppThemes.getGreyColor(),
                  ),
                  Expanded(
                      child: AppTextField(
                          controller:
                              controller.forgotPassConfirmPassEditingController,
                          onChanged: (v) {
                            controller.forgotPassConfirmPassVal.value = v;
                          },
                          obscureText:
                              controller.isConfirmPassShow ? true : false,
                          hinText: "Confirm Password")),
                  IconButton(
                      onPressed: () {
                        controller.forgotPassConfirmPassObscure();
                      },
                      icon: Image.asset(
                        controller.isConfirmPassShow
                            ? "$rootImageDir/hide.png"
                            : "$rootImageDir/show.png",
                        height: 20.h,
                        width: 20.w,
                      )),
                ],
              ),
            );
          }),
          VSpace(32.h),
          Obx(
            () => AppButton(
              isLoading: controller.isLoading.value ? true : false,
              bgColor: controller.forgotPassNewPassVal.value.isEmpty ||
                      controller.forgotPassConfirmPassVal.value.isEmpty
                  ? AppThemes.getInactiveColor()
                  : AppColors.mainColor,
              onTap: controller.forgotPassNewPassVal.value.isEmpty ||
                      controller.forgotPassConfirmPassVal.value.isEmpty
                  ? null
                  : () {
                      Get.back();
                    },
            ),
          ),
        ],
      ),
    );
  }

  buildOtpDialog(BuildContext context, TextTheme t, AuthController controller) {
    return appDialog(
      context: context,
      title: Align(
        alignment: Alignment.center,
        child: Text(
          "Enter Your OTP Code",
          style: t.titleLarge?.copyWith(color: AppColors.mainColor),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
              alignment: Alignment.center,
              child: Text(
                "Enter the 4 digits code that you\nreceived on your email",
                textAlign: TextAlign.center,
                style: t.displayMedium
                    ?.copyWith(color: AppThemes.getGreyColor(), height: 1.7),
              )),
          VSpace(32.h),
          Padding(
            padding: Dimensions.kDefaultPadding,
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  padding: EdgeInsets.only(bottom: 5.h),
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: AppThemes.getHintColor())),
                  ),
                  child: AppTextField(
                    controller: controller.otpEditingController1,
                    onChanged: (v) {
                      controller.otpVal1.value = v;
                      if (v.length == 1) {
                        FocusManager.instance.primaryFocus?.nextFocus();
                      }
                    },
                    keyboardType: TextInputType.number,
                    contentPadding: EdgeInsets.zero,
                    textAlign: TextAlign.center,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(1),
                    ],
                  ),
                )),
                HSpace(40.w),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.only(bottom: 5.h),
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: AppThemes.getHintColor())),
                  ),
                  child: AppTextField(
                    controller: controller.otpEditingController2,
                    onChanged: (v) {
                      controller.otpVal2.value = v;
                      if (v.length == 1) {
                        FocusManager.instance.primaryFocus?.nextFocus();
                      }
                    },
                    contentPadding: EdgeInsets.zero,
                    textAlign: TextAlign.center,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(1),
                    ],
                  ),
                )),
                HSpace(40.w),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.only(bottom: 5.h),
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: AppThemes.getHintColor())),
                  ),
                  child: AppTextField(
                    controller: controller.otpEditingController3,
                    onChanged: (v) {
                      controller.otpVal3.value = v;
                      if (v.length == 1) {
                        FocusManager.instance.primaryFocus?.nextFocus();
                      }
                    },
                    contentPadding: EdgeInsets.zero,
                    textAlign: TextAlign.center,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(1),
                    ],
                  ),
                )),
                HSpace(40.w),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.only(bottom: 5.h),
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: AppThemes.getHintColor())),
                  ),
                  child: AppTextField(
                    controller: controller.otpEditingController4,
                    onChanged: (v) {
                      controller.otpVal4.value = v;
                      if (v.length == 1) {
                        Helpers.hideKeyboard();
                      }
                    },
                    contentPadding: EdgeInsets.zero,
                    textAlign: TextAlign.center,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(1),
                    ],
                  ),
                )),
              ],
            ),
          ),
          VSpace(32.h),
          Obx(
            () => AppButton(
              isLoading: controller.isLoading.value ? true : false,
              bgColor: controller.otpVal1.value.isEmpty ||
                      controller.otpVal2.value.isEmpty ||
                      controller.otpVal3.value.isEmpty ||
                      controller.otpVal4.value.isEmpty
                  ? AppThemes.getInactiveColor()
                  : AppColors.mainColor,
              onTap: controller.otpVal1.value.isEmpty ||
                      controller.otpVal2.value.isEmpty ||
                      controller.otpVal3.value.isEmpty ||
                      controller.otpVal4.value.isEmpty
                  ? null
                  : () {
                      Get.back();
                      buildNewPassDialog(context, t, controller);
                    },
            ),
          ),
        ],
      ),
    );
  }
}
