import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yellowpages/config/app_colors.dart';
import 'package:yellowpages/config/dimensions.dart';
import 'package:yellowpages/themes/themes.dart';
import 'package:yellowpages/views/widgets/custom_appbar.dart';
import 'package:yellowpages/views/widgets/text_theme_extension.dart';

import '../../../routes/page_index.dart';
import '../../../utils/app_constants.dart';
import '../../widgets/spacing.dart';

class TopSubCategoryScreen extends StatefulWidget {
  TopSubCategoryScreen({super.key});

  @override
  _TopSubCategoryScreenState createState() => _TopSubCategoryScreenState();
}

class _TopSubCategoryScreenState extends State<TopSubCategoryScreen> {
  late final category; // Declare the category variable

  @override
  void initState() {
    super.initState();
    setState(() {
      category = Get.arguments; // Access the passed category
    });
    print(category.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: category.name,
      ),
      body: Padding(
        padding: Dimensions.kDefaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VSpace(20.h),
            Expanded(
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 4 / 2,
                        crossAxisCount: 2,
                        crossAxisSpacing: 20.w,
                        mainAxisSpacing: 20.h),
                    itemCount: demoCategoryList.length,
                    itemBuilder: (context, i) {
                      return InkWell(
                        onTap: () {
                          Get.toNamed(RoutesName.myListingScreen);
                        },
                        child: Container(
                          height: 95.h,
                          padding: EdgeInsets.only(left: 16.w),
                          decoration: BoxDecoration(
                            color: AppThemes.getFillColor(),
                            borderRadius: Dimensions.kBorderRadius,
                          ),
                          child: Stack(
                            children: [
                              Align(
                                  alignment: Alignment.topRight,
                                  child: Stack(
                                    children: [
                                      Image.asset(
                                        "$rootImageDir/intersect.png",
                                        width: 49.w,
                                        height: 51.h,
                                        fit: BoxFit.fill,
                                        color:
                                            AppColors.mainColor.withOpacity(.1),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 16.w, top: 13.h),
                                        child: Image.asset(
                                          demoCategoryList[i].image,
                                          width: 21.5.h,
                                          height: 21.5.h,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ],
                                  )),
                              Positioned(
                                left: 0,
                                bottom: 0,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${demoCategoryList[i].listing} Listings",
                                      style: context.t.bodySmall?.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: Get.isDarkMode
                                              ? AppColors.whiteColor
                                              : AppColors.black80),
                                    ),
                                    VSpace(5.h),
                                    Text(demoCategoryList[i].name,
                                        style: context.t.bodyLarge),
                                    VSpace(12.h),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }))
          ],
        ),
      ),
    );
  }

  final List<DemoCategories> demoCategoryList = [
    DemoCategories(
        image: "$rootImageDir/hotel.png", name: "Hotel", listing: '1'),
    DemoCategories(
        image: "$rootImageDir/shop.png", name: "Shopping", listing: '0'),
    DemoCategories(
        image: "$rootImageDir/furniture.png", name: "Furniture", listing: '4'),
    DemoCategories(
        image: "$rootImageDir/book.png", name: "Education", listing: '5'),
    DemoCategories(
        image: "$rootImageDir/hotel.png", name: "Hotel", listing: '1'),
    DemoCategories(
        image: "$rootImageDir/shop.png", name: "Shopping", listing: '0'),
    DemoCategories(
        image: "$rootImageDir/furniture.png", name: "Furniture", listing: '4'),
    DemoCategories(
        image: "$rootImageDir/book.png", name: "Education", listing: '5'),
    DemoCategories(
        image: "$rootImageDir/hotel.png", name: "Hotel", listing: '1'),
    DemoCategories(
        image: "$rootImageDir/shop.png", name: "Shopping", listing: '0'),
    DemoCategories(
        image: "$rootImageDir/furniture.png", name: "Furniture", listing: '4'),
    DemoCategories(
        image: "$rootImageDir/book.png", name: "Education", listing: '5'),
    DemoCategories(
        image: "$rootImageDir/hotel.png", name: "Hotel", listing: '1'),
    DemoCategories(
        image: "$rootImageDir/shop.png", name: "Shopping", listing: '0'),
    DemoCategories(
        image: "$rootImageDir/furniture.png", name: "Furniture", listing: '4'),
    DemoCategories(
        image: "$rootImageDir/book.png", name: "Education", listing: '5'),
    DemoCategories(
        image: "$rootImageDir/hotel.png", name: "Hotel", listing: '1'),
    DemoCategories(
        image: "$rootImageDir/shop.png", name: "Shopping", listing: '0'),
    DemoCategories(
        image: "$rootImageDir/furniture.png", name: "Furniture", listing: '4'),
    DemoCategories(
        image: "$rootImageDir/book.png", name: "Education", listing: '5'),
    DemoCategories(
        image: "$rootImageDir/hotel.png", name: "Hotel", listing: '1'),
    DemoCategories(
        image: "$rootImageDir/shop.png", name: "Shopping", listing: '0'),
    DemoCategories(
        image: "$rootImageDir/furniture.png", name: "Furniture", listing: '4'),
    DemoCategories(
        image: "$rootImageDir/book.png", name: "Education", listing: '5'),
  ];
}

class DemoCategories {
  final String image;
  final String name;
  final String listing;
  DemoCategories(
      {required this.image, required this.name, required this.listing});
}
