import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yellowpages/controllers/businessController.dart';
import 'package:yellowpages/controllers/profile_controller.dart';
import 'package:yellowpages/routes/routes_name.dart';
import 'package:yellowpages/utils/app_constants.dart';
import '../../../config/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Get.put(BusinessController());
    Get.put(ProfileController());
    Future.delayed(const Duration(seconds: 2), () {
      Get.toNamed(RoutesName.bottomNavBar);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                "$rootImageDir/splash_bg_top_main.png",
                height: MediaQuery.sizeOf(context).height * .9,
                color: AppColors.mainColor.withOpacity(.1),
                fit: BoxFit.cover,
              )),
          Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                "$rootImageDir/splash_bg_left_green.png",
                height: MediaQuery.sizeOf(context).height * .9,
                fit: BoxFit.cover,
              )),
          Positioned(
              top: 0,
              right: 0,
              child: Image.asset(
                "$rootImageDir/splash_bg_right_green.png",
                height: MediaQuery.sizeOf(context).height * .4,
                fit: BoxFit.cover,
              )),
          Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                "$rootImageDir/splash_bg_bottom_main.png",
                height: MediaQuery.sizeOf(context).height * .9,
                color: AppColors.mainColor.withOpacity(.1),
                fit: BoxFit.cover,
              )),
          Positioned(
              bottom: 0,
              right: 0,
              top: 0,
              left: 0,
              child: Padding(
                padding: EdgeInsets.only(left: 40.w),
                child: Image.asset(
                  "$rootIconDir/app_icon.png",
                  height: 78.h,
                  width: 141.w,
                ),
              )),
          Positioned(
              bottom: 86.h,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.center,
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text: "Yellow",
                    style: t.titleLarge?.copyWith(fontSize: 46.sp),
                  ),
                  TextSpan(
                    text: "Pa",
                    style: t.titleLarge
                        ?.copyWith(fontSize: 46.sp, color: AppColors.mainColor),
                  ),
                  TextSpan(
                    text: "ges",
                    style: t.titleLarge?.copyWith(fontSize: 46.sp),
                  ),
                ])),
              )),
        ],
      ),
    );
  }
}
