import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yellowpages/config/dimensions.dart';
import 'package:yellowpages/themes/themes.dart';
import 'package:yellowpages/views/widgets/custom_appbar.dart';
import 'package:yellowpages/views/widgets/spacing.dart';
import '../../../config/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../widgets/custom_painter.dart';

class ProductEnquiryDetailsScreen extends StatelessWidget {
  const ProductEnquiryDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Producat Enquiry",
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: Dimensions.kDefaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 18.w),
                decoration: BoxDecoration(
                  color: AppThemes.getFillColor(),
                  borderRadius: Dimensions.kBorderRadius,
                ),
                child: Column(
                  children: [
                    Container(
                      height: 200.h,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        borderRadius: Dimensions.kBorderRadius,
                        image: const DecorationImage(
                            image: NetworkImage(
                                "https://static.mirchi.in/thumb/imgsize-14594,msid-96536603,width-400,height-225,resizemode-1,webp-1/96536603.jpg"),
                            fit: BoxFit.cover),
                      ),
                    ),
                    VSpace(20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Listing:", style: t.bodyMedium),
                        Expanded(
                            child: Align(
                          alignment: Alignment.centerRight,
                          child: Text("Fito Fitness & Gym nnnnn",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: t.bodySmall
                                  ?.copyWith(color: AppColors.mainColor)),
                        )),
                      ],
                    ),
                    VSpace(10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Product:", style: t.bodyMedium),
                        Expanded(
                            child: Align(
                          alignment: Alignment.centerRight,
                          child: Text("ONE-ON-ONE TRAINING",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: t.bodySmall
                                  ?.copyWith(color: AppColors.black50)),
                        )),
                      ],
                    ),
                    VSpace(10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Price:", style: t.bodyMedium),
                        Expanded(
                            child: Align(
                          alignment: Alignment.centerRight,
                          child: Text("\$5000",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: t.bodySmall
                                  ?.copyWith(color: AppColors.black50)),
                        )),
                      ],
                    ),
                  ],
                ),
              ),
              VSpace(24.h),
              Container(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 18.w),
                decoration: BoxDecoration(
                  color: AppThemes.getFillColor(),
                  borderRadius: Dimensions.kBorderRadius,
                ),
                child: Column(
                  children: [
                    Text("Customer Information", style: t.bodyMedium),
                    VSpace(20.h),
                    SizedBox(
                      width: 120.h,
                      height: 120.h,
                      child: CustomPaint(
                        painter: HalfTransparentBorderPainter(
                            transparentColor: AppThemes.getFillColor()),
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppThemes.getFillColor(),
                                width: 7.h,
                              )),
                          child: ClipOval(
                            child: Image.asset(
                              "$rootImageDir/profile_pic.webp",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    VSpace(20.h),
                    Text("Test User",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: t.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    VSpace(20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Email:", style: t.bodyMedium),
                        Expanded(
                            child: Align(
                          alignment: Alignment.centerRight,
                          child: Text("testuser@gmail.com",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: t.bodySmall
                                  ?.copyWith(color: AppColors.black50)),
                        )),
                      ],
                    ),
                    VSpace(10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Website:", style: t.bodyMedium),
                        Expanded(
                            child: Align(
                          alignment: Alignment.centerRight,
                          child: Text("www.testuser.com",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: t.bodySmall
                                  ?.copyWith(color: AppColors.mainColor)),
                        )),
                      ],
                    ),
                    VSpace(10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Address:", style: t.bodyMedium),
                        Expanded(
                            child: Align(
                          alignment: Alignment.centerRight,
                          child: Text("1024 Hissison, Canada",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: t.bodySmall
                                  ?.copyWith(color: AppColors.black50)),
                        )),
                      ],
                    ),
                  ],
                ),
              ),
              VSpace(50.h),
            ],
          ),
        ),
      ),
    );
  }
}
