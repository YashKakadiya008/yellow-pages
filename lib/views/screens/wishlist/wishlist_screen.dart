import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yellowpages/config/dimensions.dart';
import 'package:yellowpages/controllers/businessController.dart';
import 'package:yellowpages/data/models/myBusiness.dart';
import 'package:yellowpages/data/services/SharedPreferencesService.dart';
import 'package:yellowpages/routes/routes_name.dart';
import 'package:yellowpages/themes/themes.dart';
import 'package:yellowpages/utils/app_constants.dart';
import 'package:yellowpages/views/screens/listing/edit_listing_screen.dart';
import 'package:yellowpages/views/widgets/appDialog.dart';
import 'package:yellowpages/views/widgets/app_button.dart';
import 'package:yellowpages/views/widgets/custom_appbar.dart';
import 'package:yellowpages/views/widgets/custom_textfield.dart';
import 'package:yellowpages/views/widgets/spacing.dart';
import 'package:http/http.dart' as http;

import '../../../config/app_colors.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({super.key});

  @override
  _WishListScreenState createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = false;
  List<Business> businesses = [];
  String currentUserId = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2, vsync: this); // Initialize TabController with 2 tabs
    fetchUserId();
  }

  void fetchUserId() async {
    final userId = await SharedPreferencesService.getUserID();
    setState(() {
      currentUserId = userId!;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return Scaffold(
      appBar: CustomAppBar(
        isTitleMarginTop: true,
        toolberHeight: 150.h,
        prefferSized: 160.h,
        title: "My Business",
        leading: const SizedBox(),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "My Business"),
            Tab(text: "My Chats"),
          ],
          labelColor: AppColors.mainColor,
          unselectedLabelColor: Colors.black,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // My Business Tab
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.mainColor,
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: Dimensions.kDefaultPadding,
                    child: Column(
                      children: [
                        VSpace(30.h),
                        GetX<BusinessController>(builder: (businessController) {
                          if (businessController.isLoading.value) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (businessController.businesses.isEmpty) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                VSpace(30.h),
                                Image.asset(
                                  'assets/images/onbording_1.png',
                                  height: 200.h,
                                  width: 200.h,
                                ),
                                VSpace(20.h),
                                Center(
                                  child: Text(
                                    'You have not added any business yet!',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            );
                          }

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: businessController.businesses.length,
                            itemBuilder: (context, i) {
                              Business business =
                                  businessController.businesses[i];
                              return InkWell(
                                onTap: () {
                                  final businessID = business.id;

                                  Get.toNamed(
                                    RoutesName.listingDetailsScreen,
                                    arguments: businessID,
                                  );
                                },
                                child: Container(
                                  height: 90.h,
                                  width: double.maxFinite,
                                  margin: EdgeInsets.only(bottom: 40.h),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            width: 90.h,
                                            height: 90.h,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  Dimensions.kBorderRadius,
                                              color: business.logo.isNotEmpty
                                                  ? Colors.transparent
                                                  : AppColors.mainColor
                                                      .withOpacity(0.3),
                                              image: business.logo.isNotEmpty
                                                  ? DecorationImage(
                                                      image: NetworkImage(
                                                          business.logo),
                                                      fit: BoxFit.cover,
                                                    )
                                                  : null,
                                            ),
                                            child: business.logo.isEmpty
                                                ? Center(
                                                    child: Text(
                                                      business.name.isNotEmpty
                                                          ? business.name[0]
                                                              .toUpperCase()
                                                          : '',
                                                      style: TextStyle(
                                                        fontSize: 40.h,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  )
                                                : null,
                                          ),
                                          Positioned(
                                            top: 5.h,
                                            right: 5.h,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.w,
                                                  vertical: 4.h),
                                              decoration: BoxDecoration(
                                                color: business.status
                                                    ? Colors.green
                                                    : Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                business.status
                                                    ? 'Approved'
                                                    : 'Not Approved',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      HSpace(16.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              business.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: t.bodyLarge,
                                            ),
                                            VSpace(3.h),
                                            Text(
                                              business.categoryType.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: t.displayMedium?.copyWith(
                                                color: Get.isDarkMode
                                                    ? AppColors.whiteColor
                                                    : AppColors.blackColor
                                                        .withOpacity(.8),
                                              ),
                                            ),
                                            VSpace(3.h),
                                            Text(
                                              business.description,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: t.bodyMedium?.copyWith(
                                                color: AppThemes.getGreyColor(),
                                              ),
                                            ),
                                            VSpace(3.h),
                                          ],
                                        ),
                                      ),
                                      HSpace(10.w),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          PopupMenuButton<String>(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            onSelected: (value) {
                                              if (value == 'option1') {
                                                Get.toNamed(
                                                  RoutesName
                                                      .businessEditingScreen,
                                                  arguments: business,
                                                );
                                              } else {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          'Delete Business'),
                                                      content: Text(
                                                          'Are you sure you want to delete this business?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text('Cancel'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            final url =
                                                                "${AppConstants.baseUri}/business/${business.id}";
                                                            final token =
                                                                await SharedPreferencesService
                                                                    .getAccessToken();
                                                            try {
                                                              final response =
                                                                  await http
                                                                      .delete(
                                                                Uri.parse(url),
                                                                headers: {
                                                                  'Content-Type':
                                                                      'application/json',
                                                                  'Authorization':
                                                                      'Bearer $token',
                                                                },
                                                              );
                                                              if (response
                                                                      .statusCode ==
                                                                  200) {
                                                                setState(() {
                                                                  businesses
                                                                      .removeAt(
                                                                          i);
                                                                });

                                                                Get.snackbar(
                                                                  'Success',
                                                                  'Business deleted successfully!',
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .BOTTOM,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .green,
                                                                  colorText:
                                                                      Colors
                                                                          .white,
                                                                );
                                                              } else {
                                                                throw Exception(
                                                                    'Failed to delete business');
                                                              }
                                                            } catch (error) {
                                                              print(error);
                                                              Get.snackbar(
                                                                'Error',
                                                                'Failed to delete the business.',
                                                                snackPosition:
                                                                    SnackPosition
                                                                        .BOTTOM,
                                                                backgroundColor:
                                                                    Colors.red,
                                                                colorText:
                                                                    Colors
                                                                        .white,
                                                              );
                                                            } finally {
                                                              Navigator.pop(
                                                                  context);
                                                            }
                                                          },
                                                          child: Text('Delete'),
                                                        )
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                            itemBuilder:
                                                (BuildContext context) =>
                                                    <PopupMenuEntry<String>>[
                                              PopupMenuItem<String>(
                                                padding: EdgeInsets.zero,
                                                value: 'option1',
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    HSpace(20.w),
                                                    Icon(
                                                      Icons.edit,
                                                      size: 20.h,
                                                    ),
                                                    HSpace(10.w),
                                                    Text('Edit',
                                                        style: t.bodyMedium),
                                                  ],
                                                ),
                                              ),
                                              PopupMenuItem<String>(
                                                padding: EdgeInsets.zero,
                                                value: 'option2',
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    HSpace(20.w),
                                                    Icon(
                                                      Icons.delete,
                                                      size: 20.h,
                                                    ),
                                                    HSpace(10.w),
                                                    Text('Delete',
                                                        style: t.bodyMedium),
                                                  ],
                                                ),
                                              ),
                                            ],
                                            child: Image.asset(
                                              "$rootImageDir/option.png",
                                              height: 24.h,
                                              width: 24.h,
                                              color: Get.isDarkMode
                                                  ? AppColors.whiteColor
                                                  : AppColors.blackColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ),
          // My Chats Tab (Placeholder for now)
          SingleChildScrollView(
            child: Padding(
              padding: Dimensions.kDefaultPadding,
              child: Column(
                children: [
                  VSpace(30.h),
                  GetX<BusinessController>(builder: (businessController) {
                    // Show loading indicator when data is being fetched
                    if (businessController.isLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    }

                    // Show a message if there are no chats
                    if (businessController.chats.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          VSpace(30.h),
                          Image.asset(
                            'assets/images/onbording_1.png',
                            height: 200.h,
                            width: 200.h,
                          ),
                          VSpace(20.h),
                          Center(
                            child: Text(
                              'You have no chats yet!',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      );
                    }

                    // Display the list of chats
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: businessController.chats.length,
                      itemBuilder: (context, index) {
                        final chat = businessController.chats[index];

                        // Check if the businessOwnerId matches the current user
                        final isBusinessOwner =
                            chat.businessOwnerId == currentUserId;

                        return InkWell(
                          onTap: () {
                            // Navigate to chat details screen or wherever you want to go
                            final chatId = chat.id;

                            Get.toNamed(
                              RoutesName.productEnquiryInboxScreen,
                              arguments: {
                                'chatId': chatId
                              }, // Pass '_id' as chatId
                            );
                          },
                          child: Container(
                            height: 90.h,
                            width: double.maxFinite,
                            margin: EdgeInsets.only(bottom: 20.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    if (!isBusinessOwner)
                                      Container(
                                        width: 90.h,
                                        height: 90.h,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              Dimensions.kBorderRadius,
                                          color: chat.businessOwnerProfile
                                                  .isNotEmpty
                                              ? Colors.transparent
                                              : AppColors.mainColor
                                                  .withOpacity(0.3),
                                          image: chat.businessOwnerProfile
                                                  .isNotEmpty
                                              ? DecorationImage(
                                                  image: NetworkImage(chat
                                                      .businessOwnerProfile),
                                                  fit: BoxFit.cover,
                                                  onError: (error, stackTrace) {
                                                    // Handle error case (show a default image or color)
                                                    print(
                                                        'Error loading image: $error');
                                                  },
                                                )
                                              : null,
                                        ),
                                        child: chat.businessOwnerProfile.isEmpty
                                            ? Center(
                                                child: Text(
                                                  chat.businessName.isNotEmpty
                                                      ? chat.businessName[0]
                                                          .toUpperCase()
                                                      : '',
                                                  style: TextStyle(
                                                    fontSize: 40.h,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              )
                                            : null,
                                      ),
                                    if (isBusinessOwner)
                                      Container(
                                        width: 90.h,
                                        height: 90.h,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              Dimensions.kBorderRadius,
                                          color: chat.visitorProfile.isNotEmpty
                                              ? Colors.transparent
                                              : AppColors.mainColor
                                                  .withOpacity(0.3),
                                          image: chat.visitorProfile.isNotEmpty
                                              ? DecorationImage(
                                                  image: NetworkImage(
                                                      chat.visitorProfile),
                                                  fit: BoxFit.cover,
                                                  onError: (error, stackTrace) {
                                                    // Handle error case (show a default image or color)
                                                    print(
                                                        'Error loading image: $error');
                                                  },
                                                )
                                              : null,
                                        ),
                                        child: chat.visitorProfile.isEmpty
                                            ? Center(
                                                child: Text(
                                                  chat.businessName.isNotEmpty
                                                      ? chat.businessName[0]
                                                          .toUpperCase()
                                                      : '',
                                                  style: TextStyle(
                                                    fontSize: 40.h,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              )
                                            : null,
                                      ),
                                    Positioned(
                                      top: 5.h,
                                      right: 5.h,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.w, vertical: 4.h),
                                        decoration: BoxDecoration(
                                          color: !isBusinessOwner
                                              ? Colors.green
                                              : Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          !isBusinessOwner
                                              ? 'Owner'
                                              : 'Visitor',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                HSpace(16.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        chat.businessName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: t.bodyLarge,
                                      ),
                                      VSpace(3.h),
                                      if (isBusinessOwner)
                                        Text(
                                          chat.visitorUsername,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: t.displayMedium?.copyWith(
                                            color: Get.isDarkMode
                                                ? AppColors.whiteColor
                                                : AppColors.blackColor
                                                    .withOpacity(.8),
                                          ),
                                        ),
                                      if (!isBusinessOwner)
                                        Text(
                                          chat.businessOwnerUsername,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: t.displayMedium?.copyWith(
                                            color: Get.isDarkMode
                                                ? AppColors.whiteColor
                                                : AppColors.blackColor
                                                    .withOpacity(.8),
                                          ),
                                        ),
                                      VSpace(3.h),
                                      if (chat.lastMessage != '')
                                        Text(
                                          "Last message: ${chat.lastMessage}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: t.bodyMedium?.copyWith(
                                            color: AppThemes.getGreyColor(),
                                          ),
                                        ),
                                      VSpace(3.h),
                                    ],
                                  ),
                                ),
                                HSpace(10.w),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
