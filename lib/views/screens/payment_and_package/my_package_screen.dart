import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../widgets/appDialog.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/spacing.dart';

class MyPackageScreen extends StatelessWidget {
  const MyPackageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return Scaffold(
      appBar: CustomAppBar(
        title: "My Packages",
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
                            color: AppThemes.getIconBlackColor(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextField(
                        hintext: "Search Package",
                        controller: TextEditingController(),
                      ),
                      VSpace(24.h),
                      IgnorePointer(
                        ignoring: true,
                        child: CustomTextField(
                          hintext: "Purchased Date",
                          controller: TextEditingController(),
                        ),
                      ),
                      VSpace(24.h),
                      IgnorePointer(
                        ignoring: true,
                        child: CustomTextField(
                          hintext: "Expired Date",
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
                color: Get.isDarkMode
                    ? AppColors.whiteColor
                    : AppColors.blackColor,
              ),
            ),
          ),
          HSpace(20.w),
        ],
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: Dimensions.kDefaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 20,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 20.h),
                      child: Row(
                        children: [
                          Container(
                            height: 146.h,
                            width: 110.w,
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            decoration: BoxDecoration(
                                color: AppColors.mainColor.withOpacity(.1),
                                borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(4.r))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Premium",
                                  style: t.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                Container(
                                  height: 50.h,
                                  width: 50.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.mainColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "20",
                                      style: t.titleMedium?.copyWith(
                                          color: AppColors.whiteColor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 146.h,
                              decoration: BoxDecoration(
                                color: AppThemes.getFillColor(),
                                borderRadius: BorderRadius.horizontal(
                                    right: Radius.circular(4.r)),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 15.h,
                                    left: 16.w,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text("Validity:",
                                                style: t.displayMedium),
                                            HSpace(8.w),
                                            Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 1.h,
                                                    horizontal: 12.w),
                                                decoration: BoxDecoration(
                                                  color: AppColors.activeColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          24.r),
                                                ),
                                                child: Text("Active",
                                                    style: t.bodyMedium
                                                        ?.copyWith(
                                                            color: AppColors
                                                                .whiteColor))),
                                          ],
                                        ),
                                        VSpace(10.h),
                                        Row(
                                          children: [
                                            Text("Status:",
                                                style: t.displayMedium),
                                            HSpace(16.w),
                                            Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 1.h,
                                                    horizontal: 12.w),
                                                decoration: BoxDecoration(
                                                  color:
                                                      AppColors.approvedColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          24.r),
                                                ),
                                                child: Text("Approved",
                                                    style: t.bodyMedium
                                                        ?.copyWith(
                                                            color: AppColors
                                                                .whiteColor))),
                                          ],
                                        ),
                                        VSpace(12.h),
                                        Text(
                                          "Purchased Date: 18 Dec, 2023",
                                          style: t.bodyMedium?.copyWith(
                                              fontSize: 15.sp,
                                              color: Get.isDarkMode
                                                  ? AppColors.whiteColor
                                                  : AppColors.black50),
                                        ),
                                        VSpace(5.h),
                                        Text(
                                          "Expired Date: 18 Jan, 2024",
                                          style: t.bodyMedium?.copyWith(
                                              fontSize: 15.sp,
                                              color: Get.isDarkMode
                                                  ? AppColors.whiteColor
                                                  : AppColors.black50),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: -32.h,
                                    right: -32.w,
                                    child: buildPopupMenu(t),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuButton<String> buildPopupMenu(TextTheme t) {
    return PopupMenuButton<String>(
      color: AppThemes.getDarkBgColor(),
      onSelected: (value) {},
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'option1',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "$rootImageDir/bag.png",
                color: AppThemes.getIconBlackColor(),
              ),
              HSpace(10.w),
              Text('Payment History', style: t.bodyMedium),
            ],
          ),
        ),

        PopupMenuItem<String>(
          value: 'Renew Package',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "$rootImageDir/renew.png",
                color: AppThemes.getIconBlackColor(),
              ),
              HSpace(10.w),
              Text('Payment History', style: t.bodyMedium),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'Add Listing',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "$rootImageDir/add_listing.png",
                color: AppThemes.getIconBlackColor(),
              ),
              HSpace(10.w),
              Text('Payment History', style: t.bodyMedium),
            ],
          ),
        ),

        // Add more menu items as needed
      ],
      child: Container(
        height: 90.h,
        width: 90.h,
        decoration: BoxDecoration(
          color: AppColors.mainColor.withOpacity(.1),
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: EdgeInsets.only(right: 15.w, top: 15.h),
          child: Icon(
            Icons.more_vert,
            size: 20.h,
            color: AppColors.blackColor,
          ),
        ),
      ),
    );
  }
}
