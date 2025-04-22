import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yellowpages/views/widgets/custom_appbar.dart';

import '../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../widgets/appDialog.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/spacing.dart';

class MyAnalyticsScreen extends StatelessWidget {
  const MyAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return Scaffold(
      appBar: CustomAppBar(
        title: "My Analytics",
        actions: [
          InkWell(
            onTap: () {
              appDialog(
                  context: context,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Filter Now", style: t.bodyMedium),
                      InkResponse(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          padding: EdgeInsets.all(7.h),
                          decoration: BoxDecoration(
                            color: AppThemes.getFillColor(),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            size: 14.h,
                            color: Get.isDarkMode
                                ? AppColors.whiteColor
                                : AppColors.blackColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextField(
                        hintext: "Search Listing",
                        controller: TextEditingController(),
                      ),
                      VSpace(24.h),
                      IgnorePointer(
                        ignoring: true,
                        child: CustomTextField(
                          hintext: "Last Visited Date",
                          controller: TextEditingController(),
                        ),
                      ),
                      VSpace(28.h),
                      AppButton(
                        text: "Search Now",
                        onTap: () {},
                      ),
                    ],
                  ));
            },
            child: Container(
              width: 34.h,
              height: 34.h,
              padding: EdgeInsets.all(7.h),
              decoration: BoxDecoration(
                color: AppThemes.getFillColor(),
                borderRadius: Dimensions.kBorderRadius,
              ),
              child: Image.asset(
                "$rootImageDir/filter_3.png",
                color:  AppThemes.getIconBlackColor(),
              ),
            ),
          ),
          HSpace(20.w),
        ],
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: Dimensions.kDefaultPadding,
        child: Column(
          children: [
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 25,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: Row(
                      children: [
                        Container(
                          width: 12.w,
                          height: 180.h,
                          decoration: BoxDecoration(
                            color: AppColors.mainColor.withOpacity(.2),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4.r),
                              bottomLeft: Radius.circular(4.r),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 180.h,
                            padding: EdgeInsets.symmetric(
                                horizontal: 11.w, vertical: 16.h),
                            decoration: BoxDecoration(
                              color: AppThemes.getFillColor(),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(4.r),
                                bottomRight: Radius.circular(4.r),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Moderno Furniture",
                                      style: t.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    InkResponse(
                                      onTap: () {},
                                      child: Container(
                                          padding: EdgeInsets.all(7.h),
                                          decoration: BoxDecoration(
                                            color: Get.isDarkMode
                                                ? AppColors.darkBgColor
                                                : AppColors.black10,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.remove_red_eye_outlined,
                                            size: 18.h,
                                          )),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: AppColors.greyColor,
                                ),
                                VSpace(5.h),
                                Row(
                                  children: [
                                    Text(
                                      "Country",
                                      style: t.bodyMedium,
                                    ),
                                    HSpace(20.w),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "United States",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: t.bodyMedium?.copyWith(
                                              color: Get.isDarkMode
                                                  ? AppColors.whiteColor
                                                  : AppColors.blackColor
                                                      .withOpacity(.5)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                VSpace(10.h),
                                Row(
                                  children: [
                                    Text(
                                      "Total Visit",
                                      style: t.bodyMedium,
                                    ),
                                    HSpace(20.w),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "88",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: t.bodyMedium?.copyWith(
                                              color: Get.isDarkMode
                                                  ? AppColors.whiteColor
                                                  : AppColors.blackColor
                                                      .withOpacity(.5)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                VSpace(10.h),
                                Row(
                                  children: [
                                    Text(
                                      "Last Visited At",
                                      style: t.bodyMedium,
                                    ),
                                    HSpace(20.w),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "16 Dec, 2023 10:34 AM",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: t.bodyMedium?.copyWith(
                                              color: Get.isDarkMode
                                                  ? AppColors.whiteColor
                                                  : AppColors.blackColor
                                                      .withOpacity(.5)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                })
          ],
        ),
      )),
    );
  }
}
