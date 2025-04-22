import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yellowpages/themes/themes.dart';
import 'package:yellowpages/views/widgets/spacing.dart';
import '../../config/app_colors.dart';
import '../../config/dimensions.dart';
import '../../utils/app_constants.dart';
import 'app_textfield.dart';

class CustomTextField extends StatelessWidget {
  final bool? isSearchIcon;
  final bool? isSubmitIcon;
  final String hintext;
  final dynamic Function(String)? onChanged;
  final TextEditingController controller;
  final void Function()? onSubmitPressed;
  final Color? bgColor;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final double? height;
  final int? minLines;
  final int? maxLines;
  final EdgeInsetsGeometry? contentPadding;
  final AlignmentGeometry? alignment;
  final bool? obsCureText;
  final FocusNode? focusNode; // Added optional focusNode parameter

  const CustomTextField({
    super.key,
    this.isSearchIcon = false,
    this.isSubmitIcon = false,
    required this.hintext,
    required this.controller,
    this.onChanged,
    this.onSubmitPressed,
    this.bgColor,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.height,
    this.minLines,
    this.maxLines,
    this.contentPadding,
    this.obsCureText = false,
    this.alignment,
    this.focusNode, // Added to constructor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 46.h,
      alignment: alignment ?? Alignment.center,
      decoration: BoxDecoration(
        color: bgColor ?? AppThemes.getFillColor(),
        borderRadius: Dimensions.kBorderRadius,
      ),
      child: Row(
        children: [
          HSpace(isSearchIcon == true ? 15.w : 0),
          isSearchIcon == true
              ? Image.asset(
                  "$rootImageDir/search.png",
                  height: 14.h,
                  width: 14.h,
                  color: AppThemes.getGreyColor(),
                )
              : const SizedBox(),
          Expanded(
            child: AppTextField(
              controller: controller,
              obscureText: obsCureText!,
              minLines: minLines ?? 1,
              maxLines: maxLines ?? 1,
              hinText: hintext,
              onChanged: onChanged,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              focusNode: focusNode, // Added focusNode to AppTextField
              contentPadding:
                  contentPadding ?? EdgeInsets.only(left: 10.w, bottom: 0.h),
            ),
          ),
          HSpace(isSubmitIcon == true ? 10.w : 0),
          isSubmitIcon == true
              ? InkWell(
                  onTap: onSubmitPressed,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                    decoration: BoxDecoration(
                      color: AppThemes.getDarkBgColor(),
                      borderRadius: Dimensions.kBorderRadius,
                    ),
                    child: Image.asset(
                      "$rootImageDir/submit.png",
                      height: 14.h,
                      width: 14.h,
                      color: Get.isDarkMode
                          ? AppColors.whiteColor
                          : AppColors.blackColor,
                    ),
                  ),
                )
              : const SizedBox(),
          HSpace(isSubmitIcon == true ? 5.w : 0),
        ],
      ),
    );
  }
}