import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yellowpages/controllers/app_controller.dart';
import 'package:yellowpages/controllers/auth_controller.dart';
import 'package:yellowpages/controllers/profile_controller.dart';
import 'package:yellowpages/data/services/SharedPreferencesService.dart';
import 'package:yellowpages/routes/routes_name.dart';
import 'package:yellowpages/themes/themes.dart';
import 'package:yellowpages/utils/services/localstorage/hive.dart';
import 'package:yellowpages/views/widgets/spacing.dart';
import '../../../config/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_painter.dart';

class ProfileSettingScreen extends StatefulWidget {
  const ProfileSettingScreen({super.key});

  @override
  _ProfileSettingScreenState createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  late final ProfileController _profileController;

  @override
  void initState() {
    super.initState();
    // Fetching the ProfileController instance
    _profileController = Get.find<ProfileController>();
    // You can now access the user data after initialization.
  }

  @override
  Widget build(BuildContext context) {
    final user = _profileController.user.value;
    if (user == null || user.username.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.dialog(
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            title: Text("Login Required",
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
            content: Text("You need to log in to access your profile settings.",
                style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade600)),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                onPressed: () {
                  Get.back();
                  Get.toNamed("/loginScreen");
                },
                child: Text("Login",
                    style: TextStyle(fontSize: 16.sp, color: Colors.white)),
              ),
            ],
          ),
          barrierDismissible: false,
        );
      });
    }
    TextTheme t = Theme.of(context).textTheme;
    return GetBuilder<AppController>(builder: (_) {
      return Scaffold(
        backgroundColor: Get.isDarkMode
            ? AppColors.darkCardColor
            : AppColors.mainColorWithOpacity,
        appBar: CustomAppBar(
          isTitleMarginTop: true,
          bgColor: AppColors.mainColor.withOpacity(.01),
          title: "Profile Settings",
          toolberHeight: 120.h,
          prefferSized: 120.h,
          leading: const SizedBox(),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // HEADER PORTION
              Container(
                padding: EdgeInsets.symmetric(vertical: 45.h, horizontal: 20.w),
                decoration: BoxDecoration(
                  color: AppThemes.getDarkBgColor(),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 120.h,
                          height: 120.h,
                          child: CustomPaint(
                            painter: HalfTransparentBorderPainter(
                                transparentColor: Get.isDarkMode
                                    ? AppColors.darkBgColor
                                    : AppColors.whiteColor),
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color:
                                        AppColors.mainColor.withOpacity(.005),
                                    width: 7.h,
                                  )),
                              child: ClipOval(
                                child: user.profile != null &&
                                        user.profile!.isNotEmpty
                                    ? Image.network(
                                        user.profile!,
                                        fit: BoxFit.cover,
                                      )
                                    : CircleAvatar(
                                        radius: 60
                                            .h, // Set the radius as per your design
                                        backgroundColor: AppColors
                                            .mainColor, // Background color for the avatar
                                        child: Text(
                                          user.username.isNotEmpty
                                              ? user.username[0].toUpperCase()
                                              : '', // First character in uppercase
                                          style: TextStyle(
                                            fontSize: 40
                                                .h, // Adjust font size as needed
                                            color: Colors
                                                .white, // Text color (white for visibility)
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 120.h,
                          width: 1,
                          color: AppThemes.getBlack10Color(),
                        ),
                        SizedBox(
                          width: 220.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user.username,
                                  style: t.displayMedium
                                      ?.copyWith(fontWeight: FontWeight.w600)),
                              VSpace(12.h),
                              Text(
                                '${user.firstname ?? ""} ${user.lastname ?? ""}'
                                    .trim(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: t.displayMedium
                                    ?.copyWith(color: AppThemes.getGreyColor()),
                              ),
                              VSpace(12.h),
                              Text(user.email,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: t.displayMedium?.copyWith(
                                      color: AppThemes.getGreyColor())),
                              VSpace(12.h),
                              if (user.postalcode != null) ...[
                                Text(user.postalcode!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: t.displayMedium?.copyWith(
                                        color: AppThemes.getGreyColor())),
                                VSpace(12.h),
                              ],
                              if (user.zender != null) ...[
                                Text(user.zender!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: t.displayMedium?.copyWith(
                                        color: AppThemes.getGreyColor())),
                                VSpace(12.h),
                              ],
                              Text(
                                user.birthdate != null &&
                                        user.birthdate!.isNotEmpty
                                    ? DateFormat('dd MMM yyyy').format(
                                        DateTime.parse(user
                                            .birthdate!)) // Format date to "dd MMM yyyy"
                                    : '', // If birthdate is null, show empty
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: t.displayMedium?.copyWith(
                                  color: AppThemes.getGreyColor(),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              VSpace(35.h),

              // FOOTER PORTION
              Container(
                padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 20.w),
                decoration: BoxDecoration(
                  color: AppThemes.getDarkBgColor(),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Theme",
                      style: t.bodyLarge?.copyWith(
                          color: AppColors.mainColor,
                          fontWeight: FontWeight.w400),
                    ),
                    VSpace(14.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 36.h,
                              width: 36.h,
                              padding: EdgeInsets.all(10.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18.r),
                                color: AppColors.mainColor.withOpacity(.1),
                              ),
                              child: Image.asset("$rootImageDir/moon.png"),
                            ),
                            HSpace(10.w),
                            Text(
                              "Dark Mode",
                              style: t.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        Transform.scale(
                            scale: .8,
                            child: Switch(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              thumbColor: MaterialStatePropertyAll(
                                  AppThemes.getGreyColor()),
                              trackColor: MaterialStatePropertyAll(
                                  !Get.isDarkMode
                                      ? Colors.grey.shade300
                                      : AppColors.mainColor),
                              value: HiveHelp.read(Keys.isDark) ?? false,
                              onChanged: _.onChanged,
                            )),
                      ],
                    ),
                    VSpace(32.h),
                    Text(
                      "Profile Settings",
                      style: t.bodyLarge?.copyWith(
                          color: AppColors.mainColor,
                          fontWeight: FontWeight.w400),
                    ),
                    VSpace(25.h),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 3,
                        itemBuilder: (context, i) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            onTap: () {
                              if (i == 0) {
                                Get.toNamed(RoutesName.editProfileScreen);
                              } else if (i == 1) {
                                Get.toNamed(RoutesName.changePasswordScreen);
                              } else {
                                buildLogoutDialog(context, t);
                              }
                            },
                            leading: Container(
                              height: 36.h,
                              width: 36.h,
                              padding: EdgeInsets.all(10.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18.r),
                                color: AppColors.mainColor.withOpacity(.1),
                              ),
                              child: i == 0
                                  ? Image.asset("$rootImageDir/edit.png")
                                  : i == 1
                                      ? Image.asset(
                                          "$rootImageDir/lock_main.png")
                                      : Image.asset(
                                          "$rootImageDir/log_out.png"),
                            ),
                            title: Text(
                                i == 0
                                    ? "Edit Profile"
                                    : i == 1
                                        ? "Change Password"
                                        : "Log Out",
                                style: t.displayMedium),
                            trailing: i == 2
                                ? const SizedBox.shrink()
                                : Container(
                                    height: 36.h,
                                    width: 36.h,
                                    padding: EdgeInsets.all(10.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6.r),
                                      color: Get.isDarkMode
                                          ? AppColors.darkCardColor
                                          : AppColors.mainColor.withOpacity(.1),
                                    ),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16.h,
                                      color: AppThemes.getGreyColor(),
                                    ),
                                  ),
                          );
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<dynamic> buildLogoutDialog(BuildContext context, TextTheme t) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            "Log out",
            style: t.bodyLarge?.copyWith(fontSize: 20.sp),
          ),
          content: Text(
            "Do you want to Log Out?",
            style: t.bodyMedium,
          ),
          actions: [
            MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "No",
                  style: t.bodyLarge,
                )),
            MaterialButton(
                onPressed: () async {
                  Get.put(AuthController()).updateLoginStatus(false);
                  await SharedPreferencesService.clearAll();
                  Get.toNamed(RoutesName.loginScreen);
                },
                child: Text(
                  "Yes",
                  style: t.bodyLarge,
                )),
          ],
        );
      },
    );
  }
}
