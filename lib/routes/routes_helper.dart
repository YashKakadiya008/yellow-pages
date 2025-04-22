// ignore_for_file: prefer_const_constructors
import 'package:get/get.dart';
import 'package:yellowpages/routes/page_index.dart';
import 'package:yellowpages/views/screens/home/SearchResults.dart';
import 'package:yellowpages/views/screens/listing/edit_listing_screen.dart';
import 'package:yellowpages/views/screens/listing/sub_categories_screen.dart';

import '../views/screens/listing/top_categories_screen.dart';
import '../views/screens/productEnquiry/product_enquiry_inbox_screen.dart';

class RouteHelper {
  static List<GetPage> routes() => [
        GetPage(
            name: RoutesName.initial,
            page: () => const SplashScreen(),
            transition: Transition.zoom),
        GetPage(
            name: RoutesName.onbordingScreen,
            page: () => const OnbordingScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.bottomNavBar,
            page: () => const BottomNavBar(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.homeScreen,
            page: () => HomeScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.searchResultscreen,
            page: () => SearchResultsScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.loginScreen,
            page: () => LoginScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.signUpScreen,
            page: () => SignUpScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.myListingScreen,
            page: () => MyListingScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.listingDetailsScreen,
            page: () => ListingDetailsScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.businessEditingScreen,
            page: () => EditListingScreen(),
            transition: Transition.fade,
        ),
        GetPage(
            name: RoutesName.profileSettingScreen,
            page: () => ProfileSettingScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.editProfileScreen,
            page: () => EditProfileScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.changePasswordScreen,
            page: () => ChangePasswordScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.addListingScreen,
            page: () => AddListingScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.wishListScreen,
            page: () => WishListScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.transactionScreen,
            page: () => TransactionScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.paymentHistoryScreen,
            page: () => PaymentHistoryScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.myAnalyticsScreen,
            page: () => MyAnalyticsScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.myPackageScreen,
            page: () => MyPackageScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.productEnquiryScreen,
            page: () => ProductEnquiryScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.productEnquiryDetailsScreen,
            page: () => ProductEnquiryDetailsScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.productEnquiryInboxScreen,
            page: () => ProductEnquiryInboxScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.createSupportTicketScreen,
            page: () => CreateSupportTicketScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.supportTicketListScreen,
            page: () => SupportTicketListScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.supportTicketViewScreen,
            page: () => SupportTicketViewScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.twoFaVerificationScreen,
            page: () => TwoFaVerificationScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.notificationScreen,
            page: () => NotificationScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.topCategoryScreen,
            page: () => TopCategoryScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.subCategoryScreen,
            page: () => TopSubCategoryScreen(),
            transition: Transition.fade),
      ];
}
