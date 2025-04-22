import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yellowpages/config/dimensions.dart';
import 'package:yellowpages/themes/themes.dart';
import 'package:yellowpages/views/widgets/custom_appbar.dart';
import 'package:yellowpages/views/widgets/text_theme_extension.dart';
import '../../../config/app_colors.dart';
import '../../../notification_service/notification_controller.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PushNotificationController>(builder: (_) {
      return Scaffold(
        appBar: CustomAppBar(
          title: "Notifications",
          actions: [
            GestureDetector(
              onTap: () {
                _.clearList();
              },
              child: Padding(
                padding: EdgeInsets.only(
                  right: 20.w,
                ),
                child: Container(
                  height: 25.h,
                  width: 80.w,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text("Clear All", style: context.t.bodySmall),
                  ),
                ),
              ),
            )
          ],
        ),
        body: Padding(
          padding: Dimensions.kDefaultPadding,
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Expanded(
                child:
                    //  notificationList.isEmpty
                    //     ? Center(
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.center,
                    //           children: [
                    //             Image.asset(
                    //               "assets/images/no_notification.png",
                    //               height: 258,
                    //               width: 226.w,
                    //             ),
                    //             SizedBox(
                    //               height: 40.h,
                    //             ),
                    //             Text(
                    //                 storedLanguage['No Notifications Yet'] ??
                    //                     "No Notifications Yet",
                    //                 style: TextStyle(
                    //                   color: AppColors.appBlackColor,
                    //                   fontSize: 20.sp,
                    //                   fontFamily: "Dubai",
                    //                   fontWeight: FontWeight.w500,
                    //                 )),
                    //             SizedBox(
                    //               height: 12.h,
                    //             ),
                    //             Padding(
                    //               padding: const EdgeInsets.symmetric(horizontal: 50),
                    //               child: Text(
                    //                   storedLanguage[
                    //                           'You have no notification right now. Come back later'] ??
                    //                       "You have no notification right now.\nCome back later",
                    //                   textAlign: TextAlign.center,
                    //                   style: TextStyle(
                    //                     color: AppColors.appBlackColor,
                    //                     fontSize: 15.sp,
                    //                     fontFamily: "Dubai",
                    //                     fontWeight: FontWeight.w400,
                    //                   )),
                    //             ),
                    //           ],
                    //         ),
                    //       )
                    //     :
                    ListView.builder(
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          _.update();
                        },
                        background: Container(
                          alignment: Alignment.centerRight,
                          color: AppColors.redColor,
                          padding: EdgeInsets.only(right: 20.w),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppThemes.getFillColor(),
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          child: ListTile(
                            onTap: () {},
                            leading: Container(
                              padding: EdgeInsets.all(6.h),
                              height: 35.h,
                              width: 35.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.mainColor,
                              ),
                              child: Image.asset(
                                "assets/images/notification_icon_new.png",
                              ),
                            ),
                            title: Text(
                              "Message",
                              style: context.t.bodySmall,
                            ),
                            subtitle: Text(
                              "Admin Replied: Ticket(#98394839434)",
                              style: context.t.bodySmall?.copyWith(
                                fontSize: 12.sp,
                                color: AppThemes.getGreyColor(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // notificationList.isEmpty
              //     ? Center(
              //         child: Text("Not found!"),
              //       )
              //     : Expanded(
              //         child: ListView.builder(
              //           itemCount: notificationList.length,
              //           itemBuilder: (context, index) {
              //             return ListTile(
              //               leading: Image.asset(
              //                                     "assets/images/notification_icon_new.png",
              //                                     height: 25.h,
              //                                     width: 25.w,
              //                                   ),
              //               title: Text(notificationList[index]['text']),
              //               subtitle: Text(notificationList[index]['date']),
              //             );
              //           },
              //         ),
              //       ),
            ],
          ),
        ),
      );
    });
  }
}
