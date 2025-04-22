import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:yellowpages/config/dimensions.dart';
import '../../config/app_colors.dart';
import '../../config/styles.dart';
import '../../main.dart';

class Helpers {
  static showToast(
      {Color? bgColor,
      Color? textColor,
      String? msg,
      ToastGravity? gravity = ToastGravity.CENTER}) {
    return Fluttertoast.showToast(
      msg: msg ?? 'Field must not be empty!',
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity ?? ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: bgColor ?? Colors.red,
      textColor: textColor ?? Colors.white,
      fontSize: 16.sp,
    );
  }

  /// hide keyboard automatically when click anywhere in screen
  static hideKeyboard() {
    return FocusManager.instance.primaryFocus?.unfocus();
  }

  /// SHOW VALIDATION ERROR DIALOG
  showValidationErrorDialog({
    String errorText = "Field must not be empty!",
    String title = "Warning!",
    int? durationTime = 3,
    Widget? icon,
    Widget? titleText,
    Widget? messageText,
    Color? textColor,
    Color? bgColor,
    SnackPosition? snackPosition = SnackPosition.TOP,
  }) {
    Get.snackbar(
      title,
      titleText: titleText,
      errorText,
      snackPosition: snackPosition,
      messageText: messageText,
      colorText: textColor ?? AppColors.whiteColor,
      backgroundColor: bgColor ?? AppColors.redColor,
      duration: Duration(seconds: durationTime!),
    );
  }

  static appLoader({Color? color}) {
    return SizedBox(
      height: 20.h,
      width: 20.w,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color ?? AppColors.whiteColor),
      ),
    );
  }

  static showSnackBar({required String msg, Color? bgColor}) {
    final snackBar = SnackBar(
      content: Center(
        child: Text(
          msg,
          style: Styles.bodySmall
              .copyWith(color: AppColors.whiteColor, fontWeight: FontWeight.w400),
        ),
      ),
      backgroundColor: bgColor ?? AppColors.redColor,
      duration: const Duration(seconds: 2),
    
      shape: RoundedRectangleBorder(
        borderRadius: Dimensions.kBorderRadius,
      ),
      elevation: 10,
    );

    MyApp.scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }
}
