import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yellowpages/themes/themes.dart';

import '../../config/app_colors.dart';
import '../../config/dimensions.dart';
import '../../utils/app_constants.dart';
import 'spacing.dart';

class MyListTile extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final String location;
  final String rating;
  final Widget? save;
  final Color? bgColor;
  const MyListTile({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.location,
    required this.rating,
    this.save,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: bgColor ?? AppColors.mainColor.withOpacity(.1),
        borderRadius: Dimensions.kBorderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          Container(
            height: 130.h,
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              borderRadius: Dimensions.kBorderRadius,
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22.r),
                      color: Get.isDarkMode
                          ? AppColors.darkBgColor
                          : AppColors.whiteColor,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: AppColors.starColor,
                          size: 17.h,
                        ),
                        Text(
                          rating,
                          style: t.bodySmall,
                        )
                      ],
                    ),
                  ),
                  save ?? const SizedBox(),
                ],
              ),
            ),
          ),
          VSpace(12.h),

          // Title Section
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: t.displayMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          VSpace(5.h),

          // Description Section
          Text(
            description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: t.bodySmall,
          ),
          VSpace(5.h),

          // Location Section
          Row(
            children: [
              Image.asset(
                "$rootImageDir/location.png",
                height: 14.h,
                color: AppThemes.getGreyColor(),
              ),
              HSpace(5.w),
              Text(
                location,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: t.bodySmall?.copyWith(color: AppThemes.getGreyColor()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}