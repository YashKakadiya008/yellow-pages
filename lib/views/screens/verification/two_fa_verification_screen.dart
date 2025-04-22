import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yellowpages/config/dimensions.dart';
import 'package:yellowpages/themes/themes.dart';
import 'package:yellowpages/utils/app_constants.dart';
import 'package:yellowpages/utils/services/helpers.dart';
import 'package:yellowpages/views/widgets/custom_appbar.dart';
import 'package:yellowpages/views/widgets/custom_textfield.dart';
import 'package:yellowpages/views/widgets/text_theme_extension.dart';
import 'package:yellowpages/views/widgets/spacing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../config/app_colors.dart';

class TwoFaVerificationScreen extends StatelessWidget {
  const TwoFaVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "2 Step Security",
        actions: [],
      ),
      body: Column(
        children: [
          VSpace(20.h),
          Expanded(
            child: Container(
              padding: Dimensions.kDefaultPadding,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Get.isDarkMode
                    ? AppColors.darkCardColor
                    : AppColors.whiteColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    VSpace(24.h),
                    Image.asset(
                      "$rootImageDir/security.png",
                      height: 148.h,
                      width: 148.h,
                      fit: BoxFit.cover,
                    ),
                    VSpace(24.h),
                    Text(
                      "Two Factor Authenticator",
                      style: context.t.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w400),
                    ),
                    VSpace(16.h),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 43.h,
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 16.h),
                            decoration: BoxDecoration(
                              border: const Border(
                                bottom: BorderSide(color: AppColors.black10),
                                top: BorderSide(color: AppColors.black10),
                                left: BorderSide(color: AppColors.black10),
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(6.r),
                                bottomLeft: Radius.circular(6.r),
                              ),
                            ),
                            child: Text(
                              "N2WXIMHXRLHIAKPZ",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.t.bodySmall?.copyWith(
                                  color: Get.isDarkMode
                                      ? AppColors.whiteColor
                                      : AppColors.black50),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context)
                                .removeCurrentSnackBar();
                            const ClipboardData(
                              text: "ljdf343",
                            );
                            Helpers.showSnackBar(
                                msg: "Copied Successfully",
                                bgColor: AppColors.greenColor);
                          },
                          child: Container(
                            height: 44.h,
                            width: 41.w,
                            padding: EdgeInsets.all(12.h),
                            decoration: BoxDecoration(
                              color: AppColors.mainColor,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(6.r),
                                bottomRight: Radius.circular(6.r),
                              ),
                            ),
                            child: Image.asset("$rootImageDir/copy.png"),
                          ),
                        ),
                      ],
                    ),
                    VSpace(32.h),
                    Container(
                      height: 270.h,
                      width: 220.h,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.mainColor),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10.h),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                  "$rootImageDir/frame.png",
                                )),
                              ),
                              child: QrImageView(
                                data: '1234567890',
                                version: QrVersions.auto,
                                size: 200.h,
                                dataModuleStyle: QrDataModuleStyle(
                                    dataModuleShape: QrDataModuleShape.square,
                                    color: AppThemes.getIconBlackColor()),
                                eyeStyle: QrEyeStyle(
                                    color: AppThemes.getIconBlackColor(),
                                    eyeShape: QrEyeShape.square),
                              ),
                            ),
                          ),
                          const Spacer(),
                          Stack(
                            alignment: Alignment.topCenter,
                            clipBehavior: Clip.none,
                            children: [
                              Transform.rotate(
                                angle: .85,
                                child: Container(
                                  height: 20.h,
                                  width: 35.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.mainColor,
                                  ),
                                ),
                              ),
                              Container(
                                height: 30.h,
                                width: 220.h,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.mainColor,
                                  borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(8.r)),
                                ),
                                child: Text(
                                  "Scane Here",
                                  style: context.t.displayMedium
                                      ?.copyWith(color: AppColors.whiteColor),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    VSpace(32.h),
                    SizedBox(
                      width: double.maxFinite,
                      height: Dimensions.buttonHeight,
                      child: MaterialButton(
                        color: AppColors.mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.r),
                        ),
                        onPressed: () {
                          Get.defaultDialog(
                            barrierDismissible: false,
                            titlePadding: EdgeInsets.only(top: 10.h),
                            titleStyle: context.t.bodyLarge,
                            title: '2 Step Security',
                            content: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Verify your OTP',
                                    style: context.t.bodySmall,
                                  ),
                                  SizedBox(height: 10.h),
                                  CustomTextField(
                                      bgColor: AppThemes.getDarkBgColor(),
                                      keyboardType: TextInputType.number,
                                      hintext: "Enter Code",
                                      controller: TextEditingController()),
                                ],
                              ),
                            ),
                            cancel: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.red, // Customize the button color
                              ),
                              onPressed: () {
                                Get.back(); // Close the dialog
                              },
                              child: Text(
                                'Cancel',
                                style: context.t.bodySmall
                                    ?.copyWith(color: AppColors.whiteColor),
                              ),
                            ),
                            confirm: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors
                                      .mainColor // Customize the button color
                                  ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Verify',
                                style: context.t.bodySmall
                                    ?.copyWith(color: AppColors.whiteColor),
                              ),
                            ),
                          );
                        },
                        child: Center(
                          child: Text(
                            "Enable Two Factor Authenticator",
                            style: context.t.bodyLarge
                                ?.copyWith(color: AppColors.whiteColor),
                          ),
                        ),
                      ),
                    ),
                    VSpace(32.h),
                    Text("Google Authenticator", style: context.t.bodyLarge),
                    VSpace(8.h),
                    const Divider(color: AppColors.black10),
                    VSpace(12.h),
                    Text(
                      "Use Google Authenticator to Scan The QR code or use the code",
                      style: context.t.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w400),
                    ),
                    VSpace(12.h),
                    Text(
                      "Google Authenticator is a multifactor app for mobile devices. It generates timed codes used during the Two-step verification process. To use Google Authenticator, install the Google Authenticator application on your mobile device.",
                      style: context.t.bodyMedium?.copyWith(
                          color: Get.isDarkMode
                              ? AppColors.black20
                              : AppColors.black50),
                    ),
                    VSpace(50.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
