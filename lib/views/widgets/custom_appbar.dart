import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yellowpages/config/app_colors.dart';
import '../../config/dimensions.dart';
import '../../themes/themes.dart';
import '../../utils/app_constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final List<Widget>? actions;
  final String? title;
  final double? toolberHeight;
  final double? prefferSized;
  final Color? bgColor;
  final bool? isReverseIconBgColor;
  final bool? isTitleMarginTop;
  final PreferredSizeWidget? bottom; // Added optional bottom widget

  const CustomAppBar({
    super.key,
    this.leading,
    this.actions,
    this.title,
    this.toolberHeight,
    this.prefferSized,
    this.isReverseIconBgColor = false,
    this.isTitleMarginTop = false,
    this.bgColor,
    this.bottom, // Added bottom to the constructor
  });

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return AppBar(
      toolbarHeight: toolberHeight ?? 100.h,
      backgroundColor: bgColor,
      title: Padding(
        padding: isTitleMarginTop == true
            ? EdgeInsets.only(top: kIsWeb ? 20.h : (Platform.isIOS ? 40.h : 20.h))
            : EdgeInsets.zero,
        child: Text(
          title ?? "",
          style: t.titleMedium,
        ),
      ),
      leading: leading ??
          IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Container(
                width: 34.h,
                height: 34.h,
                padding: EdgeInsets.all(8.h),
                decoration: BoxDecoration(
                  color: isReverseIconBgColor == true
                      ? Get.isDarkMode
                          ? AppColors.darkBgColor
                          : AppColors.fillColorColor
                      : AppThemes.getFillColor(),
                  borderRadius: Dimensions.kBorderRadius,
                ),
                child: Image.asset(
                  "$rootImageDir/back.png",
                  height: 32.h,
                  width: 32.h,
                  color: Get.isDarkMode
                      ? AppColors.whiteColor
                      : AppColors.blackColor,
                  fit: BoxFit.fitHeight,
                ),
              )),
      actions: actions,
      bottom: bottom, // Added bottom here
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(prefferSized ?? (toolberHeight ?? 70.h) + (bottom?.preferredSize.height ?? 0));
}
