import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yellowpages/utils/app_constants.dart';
import 'package:yellowpages/views/screens/home/home_screen.dart';
import 'package:yellowpages/views/screens/profile/profile_setting_screen.dart';
import 'package:yellowpages/views/screens/wishlist/wishlist_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/app_controller.dart';
import '../../../utils/services/pop_app.dart';
import '../listing/add_listing_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final Connectivity _connectivity = Connectivity();
  PersistentTabController controller = PersistentTabController();
  int selectedIndex = 0;
  @override
  void initState() {
    _connectivity.onConnectivityChanged
        .listen(Get.find<AppController>().updateConnectionStatus);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (_) {
      return WillPopScope(
        onWillPop: () {
          return PopApp.onWillPop();
        },
        child: Scaffold(
          bottomNavigationBar: PersistentTabView(
            context,
            controller: controller,
            onItemSelected: (i) {
              setState(() {
                selectedIndex = i;
              });
            },
            screens: [
              HomeScreen(),
              const AddListingScreen(),
              const WishListScreen(),
              const ProfileSettingScreen(),
            ],
            items: List.generate(
              4,
              (i) => PersistentBottomNavBarItem(
                icon: i == 0
                    ? Image.asset(
                        '$rootImageDir/home.png',
                        height: 20.h,
                        width: 20.h,
                        fit: BoxFit.cover,
                        color: selectedIndex == i
                            ? AppColors.mainColor
                            : AppColors.greyColor,
                      )
                    : i == 1
                        ? Image.asset(
                            '$rootImageDir/add_listing1.png',
                            height: 22.h,
                            width: 22.h,
                            fit: BoxFit.cover,
                            color: selectedIndex == i
                                ? AppColors.mainColor
                                : AppColors.greyColor,
                          )
                        : i == 2
                            ? Image.asset(
                                '$rootImageDir/wishlist.png',
                                height: 20.h,
                                width: 20.h,
                                fit: BoxFit.cover,
                                color: selectedIndex == i
                                    ? AppColors.mainColor
                                    : AppColors.greyColor,
                              )
                            : Image.asset(
                                '$rootImageDir/person1.png',
                                height: 20.h,
                                width: 20.h,
                                fit: BoxFit.cover,
                                color: selectedIndex == i
                                    ? AppColors.mainColor
                                    : AppColors.greyColor,
                              ),
                title: i == 0
                    ? "Home"
                    : i == 1
                        ? "Add List"
                        : i == 2
                            ? "My Business"
                            : "Profile",
                activeColorPrimary: AppColors.mainColor,
                inactiveColorPrimary: _.isDarkMode() == true
                    ? AppColors.whiteColor
                    : AppColors.blackColor,
              ),
            ),

            confineInSafeArea: true,
            backgroundColor: _.isDarkMode() == true
                ? AppColors.darkCardColor
                : AppColors.whiteColor, // Default is Colors.white.
            handleAndroidBackButtonPress: true, // Default is true.
            resizeToAvoidBottomInset:
                true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
            stateManagement: true, // Default is true.
            hideNavigationBarWhenKeyboardShows:
                true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
            decoration: NavBarDecoration(
              borderRadius: BorderRadius.circular(10.0),
              colorBehindNavBar: _.isDarkMode() == true
                  ? AppColors.darkCardColor
                  : AppColors.whiteColor,
            ),
            popAllScreensOnTapOfSelectedTab: true,
            popActionScreens: PopActionScreensType.all,
            itemAnimationProperties: const ItemAnimationProperties(
              // Navigation Bar's items animation properties.
              duration: Duration(milliseconds: 200),
              curve: Curves.ease,
            ),
            screenTransitionAnimation: const ScreenTransitionAnimation(
              // Screen transition animation on change of selected tab.
              animateTabTransition: true,
              curve: Curves.ease,
              duration: Duration(milliseconds: 200),
            ),
            navBarStyle: NavBarStyle
                .style9, // Choose the nav bar style with this property.
          ),
        ),
      );
    });
  }
}
