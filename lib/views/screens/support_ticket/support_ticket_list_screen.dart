import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yellowpages/config/dimensions.dart';
import 'package:yellowpages/routes/routes_name.dart';
import 'package:yellowpages/utils/app_constants.dart';
import 'package:yellowpages/views/widgets/spacing.dart';
import '../../../config/app_colors.dart';
import '../../widgets/custom_appbar.dart';

class SupportTicketListScreen extends StatelessWidget {
  const SupportTicketListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Support Ticket",
        actions: [],
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
                      padding: EdgeInsets.only(bottom: 24.h),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8.r),
                        onTap: () {
                          Get.toNamed(RoutesName.supportTicketViewScreen);
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Ink(
                              height: 108.h,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                color: Get.isDarkMode
                                    ? AppColors.darkCardColor
                                    : AppColors.mainColor.withOpacity(.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 58.h,
                                    height: 58.h,
                                    margin: EdgeInsets.only(left: 15.w),
                                    padding: EdgeInsets.all(15.h),
                                    decoration: const BoxDecoration(
                                      color: AppColors.whiteColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.asset(
                                      "$rootImageDir/open.png",
                                      width: 28.w,
                                      height: 26.h,
                                    ),
                                  ),
                                  HSpace(Dimensions.screenWidth * .1),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "[Ticket#824326 ] Tell me about",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: t.displayMedium,
                                        ),
                                        VSpace(16.h),
                                        RichText(
                                            text: TextSpan(children: [
                                          TextSpan(
                                            text: "Last reply: ",
                                            style: t.displayMedium?.copyWith(
                                                color: AppColors.black50),
                                          ),
                                          TextSpan(
                                              text: " 3 days ago",
                                              style: t.displayMedium),
                                        ]))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              left: Dimensions.screenWidth * .17,
                              top: -13.h,
                              child: Container(
                                height: 33.h,
                                width: 33.h,
                                decoration: BoxDecoration(
                                  color: Get.isDarkMode
                                      ? AppColors.darkBgColor
                                      : AppColors.whiteColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Positioned(
                                left: Dimensions.screenWidth * .205,
                                bottom: -13.h,
                                child: SizedBox(
                                  height: 102.h,
                                  child: const DottedLine(
                                    dashColor: AppColors.black20,
                                    direction: Axis.vertical,
                                  ),
                                )),
                            Positioned(
                              left: Dimensions.screenWidth * .17,
                              bottom: -13.h,
                              child: Container(
                                height: 33.h,
                                width: 33.h,
                                decoration: BoxDecoration(
                                  color: Get.isDarkMode
                                      ? AppColors.darkBgColor
                                      : AppColors.whiteColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:
            Get.isDarkMode ? AppColors.blackColor : AppColors.mainColor,
        onPressed: () {
          Get.toNamed(RoutesName.createSupportTicketScreen);
        },
        child: const Icon(
          Icons.add,
          color: AppColors.whiteColor,
        ),
      ),
    );
  }
}
