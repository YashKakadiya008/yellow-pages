import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yellowpages/config/dimensions.dart';
import 'package:yellowpages/themes/themes.dart';
import 'package:yellowpages/utils/app_constants.dart';
import 'package:yellowpages/views/widgets/custom_appbar.dart';
import 'package:yellowpages/views/widgets/spacing.dart';
import '../../../config/app_colors.dart';
import '../../widgets/appDialog.dart';
import '../../widgets/custom_textfield.dart';
import 'package:yellowpages/views/widgets/app_button.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return Scaffold(
      appBar: CustomAppBar(
        title: "Transaction",
        actions: [
          InkResponse(
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
                        hintext: "Search Transaction ID",
                        controller: TextEditingController(),
                      ),
                      VSpace(24.h),
                      CustomTextField(
                        hintext: "Remark",
                        controller: TextEditingController(),
                      ),
                      VSpace(24.h),
                      IgnorePointer(
                        ignoring: true,
                        child: CustomTextField(
                          hintext: "Choose Date",
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
            child: Image.asset(
              "$rootImageDir/filter_2.png",
              height: 24.h,
              color:
                  Get.isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
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
                  itemCount: 23,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: InkWell(
                        onTap: () {
                          appDialog(
                              context: context,
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
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
                                  Image.asset(
                                    "$rootImageDir/done.png",
                                    height: 48.h,
                                    width: 48.h,
                                  ),
                                  VSpace(12.h),
                                  Text(
                                    "Stripe",
                                    style:
                                        t.bodyLarge?.copyWith(fontSize: 22.sp),
                                  ),
                                  VSpace(22.h),
                                  Text(
                                    "Transaction ID",
                                    style: t.bodyMedium?.copyWith(
                                        color: Get.isDarkMode
                                            ? AppColors.whiteColor
                                            : AppColors.blackColor
                                                .withOpacity(.5)),
                                  ),
                                  Text(
                                    "T274Y6DW284E",
                                    style: t.bodySmall,
                                  ),
                                  VSpace(12.h),
                                  Text(
                                    "Amount",
                                    style: t.bodyMedium?.copyWith(
                                        color: Get.isDarkMode
                                            ? AppColors.whiteColor
                                            : AppColors.blackColor
                                                .withOpacity(.5)),
                                  ),
                                  Text(
                                    "36 USD",
                                    style: t.bodySmall,
                                  ),
                                  VSpace(12.h),
                                  Text(
                                    "Remark",
                                    style: t.bodyMedium?.copyWith(
                                        color: Get.isDarkMode
                                            ? AppColors.whiteColor
                                            : AppColors.blackColor
                                                .withOpacity(.5)),
                                  ),
                                  Text(
                                    "Buy Standard",
                                    style: t.bodySmall,
                                  ),
                                  VSpace(12.h),
                                  Text(
                                    "Date and Time",
                                    style: t.bodyMedium?.copyWith(
                                        color: Get.isDarkMode
                                            ? AppColors.whiteColor
                                            : AppColors.blackColor
                                                .withOpacity(.5)),
                                  ),
                                  Text(
                                    "14 Oct 2023 12:40 AM",
                                    style: t.bodySmall,
                                  ),
                                  VSpace(12.h),
                                ],
                              ));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 18.h),
                          decoration: BoxDecoration(
                            color: AppThemes.getFillColor(),
                            borderRadius: Dimensions.kBorderRadius,
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                "$rootImageDir/slip.png",
                                height: 50.h,
                                width: 50.h,
                              ),
                              HSpace(12.w),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Buy Standard",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: t.bodyLarge),
                                      Text("12 Dec, 2023 05:38 AM",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: t.bodySmall?.copyWith(
                                            color: AppColors.black50)),
                                  ],
                                ),
                              ),
                              HSpace(10.w),
                              Expanded(
                                flex: 3,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("\$36",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: t.titleSmall?.copyWith(
                                              color: AppColors.mainColor)),
                                      Text("Stripe",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: t.bodyMedium?.copyWith(
                                              color: Get.isDarkMode
                                                  ? AppColors.whiteColor
                                                  : AppColors.blackColor
                                                      .withOpacity(.5))),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
