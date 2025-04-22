import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yellowpages/config/dimensions.dart';
import 'package:yellowpages/routes/routes_name.dart';
import 'package:yellowpages/themes/themes.dart';
import 'package:yellowpages/utils/app_constants.dart';
import 'package:yellowpages/views/widgets/custom_appbar.dart';
import 'package:yellowpages/views/widgets/spacing.dart';

import '../../../config/app_colors.dart';

class ProductEnquiryScreen extends StatefulWidget {
  const ProductEnquiryScreen({super.key});

  @override
  State<ProductEnquiryScreen> createState() => _ProductEnquiryScreenState();
}

class _ProductEnquiryScreenState extends State<ProductEnquiryScreen> {
  late PageController _pageController;
  int _selectedIndex = 0;
  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Product Enquiry",
        actions: [],
      ),
      body: Padding(
        padding: Dimensions.kDefaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ButtonBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    _pageController.animateToPage(
                      0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                  child: Ink(
                    child: Column(
                      children: [
                        Text("Customer Enquiry", style: t.bodyMedium),
                        VSpace(5.h),
                        Container(
                          width: 140.w,
                          height: 1.h,
                          color: _selectedIndex == 0
                              ? AppColors.mainColor
                              : Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _pageController.animateToPage(
                      1,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                  child: Ink(
                    child: Column(
                      children: [
                        Text("My Enquiry", style: t.bodyMedium),
                        VSpace(5.h),
                        Container(
                          width: 140.w,
                          height: 1.h,
                          color: _selectedIndex == 1
                              ? AppColors.mainColor
                              : Colors.transparent,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            VSpace(30.h),
            Expanded(
              child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (i) {
                    _selectedIndex = i;
                    setState(() {});
                  },
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return ListView.builder(
                        // controller: _pageController,
                        itemCount: 20,
                        itemBuilder: (context, i) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: InkWell(
                              onTap: () {
                                Get.toNamed(
                                    RoutesName.productEnquiryDetailsScreen);
                              },
                              child: Ink(
                                height: 138.h,
                                width: double.maxFinite,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.w, vertical: 13.h),
                                decoration: BoxDecoration(
                                  color: AppThemes.getFillColor(),
                                  borderRadius: Dimensions.kBorderRadius,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        ClipOval(
                                          child: Container(
                                            height: 40.h,
                                            width: 40.h,
                                            decoration: const BoxDecoration(
                                              color: AppColors.greyColor,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Image.network(
                                              "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        HSpace(12.w),
                                        Expanded(
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Test User",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: t.displayMedium),
                                                Text("Testuser@gmail.Com",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        t.bodySmall?.copyWith(
                                                      color: Get.isDarkMode
                                                          ? AppColors.whiteColor
                                                          : AppColors.black50,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    )),
                                              ]),
                                        ),
                                        Expanded(
                                          child: Column(children: [
                                            Text("Fitness Consultation",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: t.bodySmall?.copyWith(
                                                    color:
                                                        AppColors.mainColor)),
                                            Text("20 Jul, 2023 06:52 PM",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: t.bodySmall?.copyWith(
                                                  fontSize: 12.sp,
                                                  color: Get.isDarkMode
                                                      ? AppColors.whiteColor
                                                      : AppColors.black50,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                          ]),
                                        ),
                                      ],
                                    ),
                                    VSpace(12.h),
                                    const Divider(color: AppColors.black10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Message", style: t.displayMedium),
                                        InkResponse(
                                          onTap: () {
                                            Get.toNamed(RoutesName
                                                .productEnquiryInboxScreen);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(8.h),
                                            decoration: BoxDecoration(
                                              color: AppColors.mainColor,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Image.asset(
                                              "$rootImageDir/message.png",
                                              height: 15.h,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  }),
            )
          ],
        ),
      ),
    );
  }
}
