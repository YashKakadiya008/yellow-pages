import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yellowpages/config/app_colors.dart';
import 'package:yellowpages/config/dimensions.dart';
import 'package:yellowpages/routes/routes_name.dart';
import 'package:yellowpages/views/screens/onbording/onbording_data.dart';
import 'package:yellowpages/views/widgets/app_button.dart';
import 'package:yellowpages/views/widgets/spacing.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnbordingScreen extends StatefulWidget {
  const OnbordingScreen({super.key});

  @override
  State<OnbordingScreen> createState() => _OnbordingScreenState();
}

class _OnbordingScreenState extends State<OnbordingScreen> {
  final PageController controller = PageController();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return Scaffold(
      body: Padding(
        padding: Dimensions.kDefaultPadding,
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                  controller: controller,
                  scrollDirection: Axis.horizontal,
                  itemCount: onBordingDataList.length,
                  onPageChanged: (i) {
                    setState(() {
                      currentIndex = i;
                    });
                  },
                  itemBuilder: (context, i) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          onBordingDataList[i].imagePath,
                          height: 385.h,
                          width: 341.w,
                          fit: BoxFit.fitHeight,
                        ),
                        VSpace(59.h),
                        Center(
                          child: Text(
                            onBordingDataList[i].title,
                            style: t.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        VSpace(12.h),
                        Center(
                          child: Text(
                            onBordingDataList[i].description,
                            textAlign: TextAlign.center,
                            style: t.displayMedium?.copyWith(height: 1.5),
                          ),
                        ),
                        VSpace(44.h),
                        SmoothPageIndicator(
                          controller: controller,
                          count: onBordingDataList.length,
                          axisDirection: Axis.horizontal,
                          effect: ExpandingDotsEffect(
                              dotColor: AppColors.black10,
                              dotHeight: 10.h,
                              dotWidth: 10.h,
                              activeDotColor: AppColors.mainColor),
                        )
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
          margin: EdgeInsets.only(bottom: 20.h),
          padding: Dimensions.kDefaultPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              currentIndex == onBordingDataList.length - 1
                  ? const SizedBox(
                      height: 1,
                      width: 1,
                    )
                  : InkWell(
                      onTap: () {
                        controller.animateToPage(onBordingDataList.length,
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.easeInOutQuint);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: Text(
                          "Skip",
                          style: t.displayMedium
                              ?.copyWith(color: AppColors.greyColor),
                        ),
                      ),
                    ),
              AppButton(
                text: (currentIndex == onBordingDataList.length - 1)
                    ? "Go"
                    : "Next",
                onTap: () {
                  (currentIndex == (onBordingDataList.length - 1))
                      ? Get.offAllNamed(RoutesName.loginScreen)
                      : controller.nextPage(
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeInOutQuint);
                },
                buttonWidth: 100.h,
                buttonHeight: 36.h,
                style: t.displayMedium?.copyWith(color: AppColors.whiteColor),
              ),
            ],
          )),
    );
  }
}
