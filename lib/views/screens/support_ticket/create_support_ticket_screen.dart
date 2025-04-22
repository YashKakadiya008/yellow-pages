import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yellowpages/config/dimensions.dart';
import 'package:yellowpages/views/widgets/custom_appbar.dart';
import 'package:yellowpages/views/widgets/text_theme_extension.dart';
import '../../../config/app_colors.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/spacing.dart';

class CreateSupportTicketScreen extends StatelessWidget {
  const CreateSupportTicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Create Ticket",
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: Dimensions.kDefaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Subject", style: context.t.displayMedium),
              VSpace(12.h),
              CustomTextField(
                bgColor: AppThemes.getFillColor(),
                controller: TextEditingController(),
                hintext: "Enter Subject",
                isSearchIcon: false,
              ),
              VSpace(25.h),
              Text("Message", style: context.t.displayMedium),
              VSpace(12.h),
              CustomTextField(
                height: 132.h,
                contentPadding:
                    EdgeInsets.only(left: 10.w, bottom: 0.h, top: 10.h),
                alignment: Alignment.topLeft,
                minLines: 3,
                maxLines: 5,
                bgColor: AppThemes.getFillColor(),
                controller: TextEditingController(),
                hintext: "Enter Message",
                isSearchIcon: false,
              ),
              VSpace(32.h),
              DottedBorder(
                color: AppColors.mainColor,
                dashPattern: const <double>[6, 4],
                child: Container(
                  width: double.maxFinite,
                  height: 238.h,
                  decoration: BoxDecoration(
                    color: AppThemes.getFillColor(),
                    borderRadius: Dimensions.kBorderRadius,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "$rootImageDir/drop.png",
                        color: AppColors.mainColor,
                        height: 57.h,
                      ),
                      VSpace(24.h),
                      Text("Drop files here", style: context.t.bodyMedium),
                      VSpace(10.h),
                      Text("Or", style: context.t.bodyMedium),
                      VSpace(12.h),
                      InkWell(
                        onTap: () {},
                        borderRadius: Dimensions.kBorderRadius,
                        child: Container(
                          width: 165.w,
                          height: 38.h,
                          decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius: Dimensions.kBorderRadius,
                          ),
                          child: Center(
                            child: Text(
                              "Browse Files",
                              style: context.t.bodyLarge
                                  ?.copyWith(color: AppColors.whiteColor),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              VSpace(40.h),
              AppButton(
                text: "Submit",
                isLoading: false,
                onTap: () {},
              ),
              VSpace(40.h),
            ],
          ),
        ),
      ),
    );
  }
}
