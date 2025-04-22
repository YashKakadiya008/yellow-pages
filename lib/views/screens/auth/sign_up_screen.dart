import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yellowpages/config/dimensions.dart';
import 'package:yellowpages/routes/routes_name.dart';
import 'package:yellowpages/themes/themes.dart';
import 'package:yellowpages/utils/app_constants.dart';
import 'package:yellowpages/views/widgets/app_button.dart';
import 'package:yellowpages/views/widgets/app_textfield.dart';
import 'package:yellowpages/views/widgets/mediaquery_extension.dart';
import 'package:yellowpages/views/widgets/spacing.dart';

import '../../../config/app_colors.dart';
import '../../../controllers/auth_controller.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    AuthController controller = Get.find<AuthController>();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: SizedBox(
          height: Dimensions.screenHeight,
          width: Dimensions.screenWidth,
          child: Stack(
            children: [
              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    "$rootImageDir/login_bg_top.png",
                    height: MediaQuery.sizeOf(context).height * .22,
                    color: AppColors.mainColor.withOpacity(.06),
                    fit: BoxFit.cover,
                  )),
              Positioned(
                  left: 0,
                  right: 0,
                  top: MediaQuery.sizeOf(context).height * .08,
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
                    height: MediaQuery.sizeOf(context).height * .1,
                    color: AppColors.mainColor.withOpacity(.06),
                    fit: BoxFit.cover,
                  )),
              Positioned(
                top: MediaQuery.sizeOf(context).height * .22,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: context.mQuery.height * .8,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: Dimensions.kDefaultPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Sign Up", style: t.titleLarge),
                          VSpace(5.h),
                          Text("Hey there, Sign Up to continue!",
                              style: t.displayMedium
                                  ?.copyWith(color: AppThemes.getGreyColor())),
                          // VSpace(20.h),
                          // Container(
                          //   padding: EdgeInsets.only(bottom: 15.h),
                          //   decoration: const BoxDecoration(
                          //     border: Border(
                          //         bottom: BorderSide(
                          //             color: AppColors.dividerColor)),
                          //   ),
                          //   child: Row(
                          //     children: [
                          //       Image.asset(
                          //         "$rootImageDir/person.png",
                          //         height: 16.h,
                          //         width: 16.h,
                          //         color: AppThemes.getGreyColor(),
                          //       ),
                          //       Expanded(
                          //           child: AppTextField(
                          //               controller: controller
                          //                   .fullNameEditingController,
                          //               onChanged: (v) {
                          //                 controller.fullNameVal.value = v;
                          //               },
                          //               hinText: "Enter Full Name")),
                          //     ],
                          //   ),
                          // ),
                          VSpace(55.h),
                          Container(
                            padding: EdgeInsets.only(bottom: 15.h),
                            decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: AppColors.dividerColor)),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.email_outlined,
                                  size: 18.h,
                                  color: Get.isDarkMode
                                      ? AppColors.greyColor
                                      : AppColors.textFieldHintColor,
                                ),
                                Expanded(
                                  child: AppTextField(
                                      controller:
                                          controller.emailEditingController,
                                      hinText: "Email OR Phone"),
                                ),
                              ],
                            ),
                          ),
                          // VSpace(25.h),
                          // Container(
                          //   padding: EdgeInsets.only(bottom: 15.h),
                          //   decoration: const BoxDecoration(
                          //     border: Border(
                          //         bottom: BorderSide(
                          //             color: AppColors.dividerColor)),
                          //   ),
                          //   child: Row(
                          //     children: [
                          //       Image.asset(
                          //         "$rootImageDir/person.png",
                          //         height: 16.h,
                          //         width: 16.h,
                          //         color: AppThemes.getGreyColor(),
                          //       ),
                          //       Expanded(
                          //           child: AppTextField(
                          //               controller: controller
                          //                   .signUpUserNameEditingController,
                          //               onChanged: (v) {
                          //                 controller.signUpUserNameVal.value =
                          //                     v;
                          //               },
                          //               hinText: "Username")),
                          //     ],
                          //   ),
                          // ),
                          // VSpace(25.h),
                          // Row(
                          //   children: [
                          //     CountryCodePicker(
                          //       dialogBackgroundColor:
                          //           AppThemes.getDarkCardColor(),
                          //       dialogTextStyle: t.bodyMedium,
                          //       textStyle: t.displayMedium
                          //           ?.copyWith(color: AppColors.mainColor),
                          //       onChanged: (CountryCode countryCode) {},
                          //       initialSelection: 'US',
                          //       showCountryOnly: false,
                          //       showOnlyCountryWhenClosed: false,
                          //       alignLeft: false,
                          //     ),
                          //     Expanded(
                          //       child: Container(
                          //         padding: EdgeInsets.only(bottom: 15.h),
                          //         decoration: const BoxDecoration(
                          //           border: Border(
                          //               bottom: BorderSide(
                          //                   color: AppColors.dividerColor)),
                          //         ),
                          //         child: Row(
                          //           children: [
                          //             Image.asset(
                          //               "$rootImageDir/call.png",
                          //               height: 16.h,
                          //               width: 16.h,
                          //               color: AppThemes.getGreyColor(),
                          //             ),
                          //             Expanded(
                          //                 child: AppTextField(
                          //                     controller: controller
                          //                         .phoneNumberEditingController,
                          //                     onChanged: (v) {
                          //                       controller
                          //                           .phoneNumberVal.value = v;
                          //                     },
                          //                     keyboardType:
                          //                         TextInputType.number,
                          //                     inputFormatters: <TextInputFormatter>[
                          //                       FilteringTextInputFormatter
                          //                           .digitsOnly,
                          //                     ],
                          //                     hinText: "Phone Number")),
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          VSpace(15.h),
                          GetBuilder<AuthController>(builder: (_) {
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
                                              .signUpPassEditingController,
                                          onChanged: (v) {
                                            controller.signUpPassVal.value = v;
                                          },
                                          obscureText: controller.isNewPassShow
                                              ? true
                                              : false,
                                          hinText: "Password")),
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
                          VSpace(15.h),
                          GetBuilder<AuthController>(builder: (_) {
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
                                              .confirmPassEditingController,
                                          onChanged: (v) {
                                            controller
                                                .signUpConfirmPassVal.value = v;
                                          },
                                          obscureText:
                                              controller.isConfirmPassShow
                                                  ? true
                                                  : false,
                                          hinText: "Confirm Password")),
                                  IconButton(
                                      onPressed: () {
                                        controller
                                            .forgotPassConfirmPassObscure();
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
                          VSpace(20.h),
                          Obx(
                            () => AppButton(
                              text: "Create an Account",
                              isLoading:
                                  controller.isLoading.value ? true : false,
                              bgColor: AppColors.mainColor,
                              onTap: () {
                                // Get.toNamed(RoutesName.bottomNavBar);
                                if (controller.emailEditingController.text == "") {
                                  Get.snackbar("Error", "Email is required",
                                      snackPosition: SnackPosition.BOTTOM);
                                } else if (controller
                                    .signUpPassVal.value.isEmpty) {
                                  Get.snackbar("Error", "Password is required",
                                      snackPosition: SnackPosition.BOTTOM);
                                } else if (controller
                                    .signUpConfirmPassVal.value.isEmpty) {
                                  Get.snackbar(
                                      "Error", "Confirm Password is required",
                                      snackPosition: SnackPosition.BOTTOM);
                                } else if (controller.signUpPassVal.value !=
                                    controller.signUpConfirmPassVal.value) {
                                  Get.snackbar("Error",
                                      "Password and Confirm Password didn't match!",
                                      snackPosition: SnackPosition.BOTTOM);
                                } else {
                                  controller.signUp();
                                }
                              },
                            ),
                          ),
                          // Obx(
                          //   () => AppButton(
                          //     text: "Create an Account",
                          //     isLoading:
                          //         controller.isLoading.value ? true : false,
                          //     bgColor: controller.fullNameVal.value.isEmpty ||
                          //             controller.emailVal.value.isEmpty ||
                          //             controller
                          //                 .signUpUserNameVal.value.isEmpty ||
                          //             controller.phoneNumberVal.value.isEmpty ||
                          //             controller.signUpPassVal.value.isEmpty ||
                          //             controller
                          //                 .signUpConfirmPassVal.value.isEmpty
                          //         ? AppThemes.getInactiveColor()
                          //         : AppColors.mainColor,
                          //     onTap: controller.fullNameVal.value.isEmpty ||
                          //             controller.emailVal.value.isEmpty ||
                          //             controller
                          //                 .signUpUserNameVal.value.isEmpty ||
                          //             controller.phoneNumberVal.value.isEmpty ||
                          //             controller.signUpPassVal.value.isEmpty ||
                          //             controller
                          //                 .signUpConfirmPassVal.value.isEmpty
                          //         ? null
                          //         : () {},
                          //   ),
                          // ),
                          VSpace(10.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account?",
                                style: t.displayMedium
                                    ?.copyWith(color: AppThemes.getHintColor()),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.toNamed(RoutesName.loginScreen);
                                },
                                child: Text(
                                  "Login",
                                  style: t.displayMedium
                                      ?.copyWith(color: AppColors.mainColor),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
