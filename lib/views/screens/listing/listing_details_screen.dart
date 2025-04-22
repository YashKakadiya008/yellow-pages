import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yellowpages/config/dimensions.dart';
import 'package:yellowpages/controllers/app_controller.dart';
import 'package:yellowpages/controllers/businessController.dart';
import 'package:yellowpages/controllers/review_controller.dart';
import 'package:yellowpages/data/models/myBusiness.dart';
import 'package:yellowpages/data/services/ImageUpload.dart';
import 'package:yellowpages/utils/app_constants.dart';
import 'package:yellowpages/utils/services/helpers.dart';
import 'package:http/http.dart' as http;
import 'package:yellowpages/views/widgets/app_button.dart';
import 'package:yellowpages/views/widgets/spacing.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/app_colors.dart';
import '../../../data/services/SharedPreferencesService.dart';
import '../../../routes/routes_name.dart';
import '../../../themes/themes.dart';
import '../../widgets/google_map_screen.dart';

class ListingDetailsScreen extends StatefulWidget {
  ListingDetailsScreen({super.key});

  @override
  State<ListingDetailsScreen> createState() => _ListingDetailsScreenState();
}

class _ListingDetailsScreenState extends State<ListingDetailsScreen> {
  int selectedIndex = 0;
  int carouselIndex = 0;
  bool isFilled = false;
  late String businessID; // Declare a variable to store the business ID
  Map<String, dynamic> businessDetails = {}; // To store business details
  bool isLoading = true; // To track the loading state
  late String userId; // Declare a variable to store the user ID
  BusinessController businessController = Get.find<BusinessController>();

  @override
  void initState() {
    super.initState();
    loadUserId();

    // Retrieve the business ID passed from the previous screen
    businessID = Get.arguments; // This will contain the business ID

    // Call the function to fetch the business details
    fetchBusinessDetails(businessID);
  }

  // Function to load the user ID from SharedPreferences
  void loadUserId() async {
    userId = await SharedPreferencesService.getUserID() ?? '';
  }

  // Function to fetch the business details from the API
  Future<void> fetchBusinessDetails(String businessID) async {
    setState(() {
      isLoading = true; // Set loading to true when API call starts
    });
    print("BusiensID :$businessID");
    try {
      // Replace {{url}} with your API base URL
      final url = '${AppConstants.baseUri}/business/$businessID';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          businessDetails =
              json.decode(response.body)['business']; // Parse the JSON response
          fetchReview(businessID);
        });

        businessController.addBusinessToRecent(businessDetails);
      } else {
        // Handle API errors or non-200 status codes
        setState(() {
          isLoading = false;
        });
        // Show error to the user
        Get.snackbar('Error', 'Failed to load business details');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Show error to the user in case of network error
      Get.snackbar('Error', 'Network error: $e');
    }
  }

  Future<void> fetchReview(String businessID) async {
    try {
      setState(() {
        isLoading = true; // Set loading to false once data is fetched
      });
      // Replace {{url}} with your API base URL
      final url = '${AppConstants.baseUri}/reviews/business/$businessID';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          businessDetails['reviews'] =
              json.decode(response.body)['reviews']; // Parse the JSON response
          if (businessDetails['logo'] != null &&
              businessDetails['logo'].toString().isNotEmpty) {
            imagelist.add(businessDetails['logo']);
          }

          if (businessDetails['reviews'] != null) {
            for (var i = 0; i < businessDetails['reviews'].length; i++) {
              if (businessDetails['reviews'][i]['pictures'] != null) {
                imagelist = [];
                imagelist.add(businessDetails['logo']);
                for (var j = 0;
                    j < businessDetails['reviews'][i]['pictures'].length;
                    j++) {
                  imagelist.add(businessDetails['reviews'][i]['pictures'][j]);
                }
              }
            }
          }
        });
      } else {
        // Handle API errors or non-200 status codes
        // Show error to the user
        Get.snackbar('Error', 'Failed to load business reviews');
      }
      setState(() {
        isLoading = false; // Set loading to false once data is fetched
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Set loading to false once data is fetched
      });
      // Show error to the user in case of network error
      Get.snackbar('Error', 'Network error: $e');
    }
  }

  Future<void> startChat() async {
    // Replace {{url}} with your API base URL
    final token = await SharedPreferencesService.getAccessToken();

    final url = '${AppConstants.baseNgrokUrl}/api/v1/chats/start';
    final body = json.encode({
      "businessId": businessID,
    });
    final response = await http.post(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: body);

    final jsonResponse = jsonDecode(response.body);
    print("Response : $jsonResponse");
    if (response.statusCode == 200) {
      // Assuming jsonResponse is the response object that contains '_id'
      Get.toNamed(
        RoutesName.productEnquiryInboxScreen,
        arguments: {'chatId': jsonResponse['_id']}, // Pass '_id' as chatId
      );
    } else {
      // Handle API errors or non-200 status codes
      // Show error to the user
      Get.snackbar('Error', jsonResponse['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    CarouselController controller = CarouselController();
    return isLoading
        ? Scaffold(
            body: Center(
                child: CircularProgressIndicator(
            color: AppColors.mainColor,
          )))
        : GetBuilder<AppController>(builder: (_) {
            final businessUserId = businessDetails['userId']['_id'].toString();

            final isUserMatch = userId.toString() == businessUserId;

            return DefaultTabController(
                length: categoryList.length,
                child: Scaffold(
                  body: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            caroselSection(controller, t),
                            VSpace(20.h),
                            Padding(
                              padding: Dimensions.kDefaultPadding,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    businessDetails['name'] != null
                                        ? capitalizeFirstLetter(
                                            businessDetails['name'])
                                        : 'No Name',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: t.bodyLarge?.copyWith(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  VSpace(17.h),
                                  Row(
                                    children: [
                                      Expanded(
                                          flex: 4,
                                          child: Text(
                                            businessDetails['categoryType']
                                                        ['name'] !=
                                                    null
                                                ? capitalizeFirstLetter(
                                                    businessDetails[
                                                        'categoryType']['name'])
                                                : 'No Name',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: t.bodyMedium?.copyWith(
                                                color: AppColors.mainColor),
                                          )),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5.h, horizontal: 8.w),
                                        decoration: BoxDecoration(
                                          color: AppColors.mainColor
                                              .withOpacity(.1),
                                          borderRadius:
                                              Dimensions.kBorderRadius,
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              calculateAverageRating(
                                                      businessDetails[
                                                              'reviews'] ??
                                                          [])
                                                  .toStringAsFixed(
                                                      1), // Display the rating with one decimal point
                                              style: t.bodySmall?.copyWith(
                                                  color: AppColors.mainColor),
                                            ),
                                            HSpace(5.w),
                                            Icon(
                                              Icons.star,
                                              size: 14.h,
                                              color: AppColors.mainColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        width: Dimensions.screenWidth * .27,
                                        child: Text(
                                            '( ${businessDetails['reviews']?.length} Reviews )',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: t.bodySmall),
                                      ),
                                    ],
                                  ),
                                  VSpace(28.h),
                                  Row(
                                    children: [
                                      Container(
                                        height: 34.h,
                                        width: 34.h,
                                        decoration: BoxDecoration(
                                          color: AppColors.mainColor,
                                          border: Border.all(
                                              color: AppColors.mainColor,
                                              width: 2.h),
                                          shape: BoxShape.circle,
                                        ),
                                        child: ClipOval(
                                          child: Image.network(
                                            (businessDetails['userId']
                                                            ?['profile']
                                                        ?.toString()
                                                        .isNotEmpty ??
                                                    false)
                                                ? businessDetails['userId']![
                                                        'profile']
                                                    .toString()
                                                : "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D",
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  value: loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                      : null,
                                                ),
                                              );
                                            },
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.network(
                                                "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D",
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      HSpace(15.w),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            businessDetails['userId']
                                                    ['username'] ??
                                                'N/A',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: t.bodyMedium?.copyWith(
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      if (!isUserMatch)
                                        InkResponse(
                                          onTap: () async {
                                            await startChat();
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(6.h),
                                            decoration: BoxDecoration(
                                              color: AppColors.mainColor,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Image.asset(
                                              "$rootImageDir/message.png",
                                              width: 18.w,
                                              height: 18.h,
                                            ),
                                          ),
                                        ),
                                      HSpace(8.w),
                                      InkResponse(
                                        onTap: () async {
                                          // Replace 'mobilenumber' with the actual number you want to dial
                                          String mobileNumber =
                                              businessDetails['mobilenumber'];

                                          // Check if the number is valid and can be dialed
                                          final Uri phoneUri = Uri(
                                              scheme: 'tel',
                                              path: mobileNumber);
                                          if (await canLaunch(
                                              phoneUri.toString())) {
                                            await launch(phoneUri.toString());
                                          } else {
                                            // Handle error or show a message if the dialer can't be launched
                                            print('Could not launch dialer');
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(6.h),
                                          decoration: BoxDecoration(
                                            color: AppColors.mainColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Image.asset(
                                            "$rootImageDir/call_2.png",
                                            width: 18.w,
                                            height: 18.h,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  VSpace(32.h),
                                  TabBar(
                                    onTap: (index) {
                                      setState(() {
                                        selectedIndex = index;
                                      });
                                    },
                                    overlayColor:
                                        const MaterialStatePropertyAll(
                                            Colors.transparent),
                                    labelPadding:
                                        EdgeInsets.only(right: 12.w, left: 4.w),
                                    indicatorColor: Colors.transparent,
                                    dividerColor: Colors.transparent,
                                    isScrollable: true,
                                    tabAlignment: TabAlignment.start,
                                    tabs: List.generate(
                                        categoryList.length,
                                        (i) => Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20.w,
                                                  vertical: 6.h),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    Dimensions.kBorderRadius,
                                                color: selectedIndex == i
                                                    ? AppColors.mainColor
                                                    : AppThemes.getFillColor(),
                                              ),
                                              child: Text(categoryList[i],
                                                  style: t.bodyMedium?.copyWith(
                                                      color: selectedIndex == i
                                                          ? AppColors.whiteColor
                                                          : Get.isDarkMode
                                                              ? AppColors
                                                                  .whiteColor
                                                              : AppColors
                                                                  .black50)),
                                            )),
                                  ),
                                  Column(children: [
                                    VSpace(35.h),
                                    if (selectedIndex == 0)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(
                                                "$rootImageDir/location.png",
                                                height: 14.h,
                                                color: Get.isDarkMode
                                                    ? AppColors.whiteColor
                                                    : AppColors.blackColor,
                                              ),
                                              HSpace(12.w),
                                              Text(
                                                businessDetails[
                                                        'locationName'] ??
                                                    'N/A',
                                                style: t.bodyMedium?.copyWith(
                                                    color: Get.isDarkMode
                                                        ? AppColors.whiteColor
                                                        : AppColors.black50),
                                              )
                                            ],
                                          ),
                                          VSpace(12.h),
                                          Row(
                                            children: [
                                              Image.asset(
                                                "$rootImageDir/location.png",
                                                height: 14.h,
                                                color: Get.isDarkMode
                                                    ? AppColors.whiteColor
                                                    : AppColors.blackColor,
                                              ),
                                              HSpace(12.w),
                                              Text(
                                                businessDetails['city'] ??
                                                    'No city',
                                                style: t.bodySmall?.copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    color: Get.isDarkMode
                                                        ? AppColors.whiteColor
                                                        : AppColors.black50),
                                              ),
                                            ],
                                          ),
                                          VSpace(12.h),
                                          Row(
                                            children: [
                                              Image.asset(
                                                "$rootImageDir/world.png",
                                                height: 14.h,
                                                color: Get.isDarkMode
                                                    ? AppColors.whiteColor
                                                    : AppColors.black50,
                                              ),
                                              HSpace(12.w),
                                              Text(
                                                businessDetails['website'] ??
                                                    'N/A',
                                                style: t.bodyMedium?.copyWith(
                                                    color: Get.isDarkMode
                                                        ? AppColors.whiteColor
                                                        : AppColors.black50),
                                              )
                                            ],
                                          ),
                                          VSpace(24.h),
                                          Text(
                                            businessDetails['description'] ??
                                                'No description',
                                            style: t.bodySmall?.copyWith(
                                                fontWeight: FontWeight.w400,
                                                color: Get.isDarkMode
                                                    ? AppColors.whiteColor
                                                    : AppColors.black50),
                                          ),
                                          VSpace(24.h),

                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 20.h,
                                                horizontal: 20.w),
                                            decoration: BoxDecoration(
                                              color: AppThemes.getFillColor(),
                                              borderRadius:
                                                  Dimensions.kBorderRadius,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Opening Hours",
                                                  style: t.bodyLarge?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                VSpace(16.h),
                                                // Ensure businessHours is not null before iterating
                                                if (businessDetails[
                                                            'businessHours'] !=
                                                        null &&
                                                    businessDetails[
                                                        'businessHours'] is Map)
                                                  ...businessDetails[
                                                          'businessHours']
                                                      .keys
                                                      .map((day) {
                                                    // Ensure the day entry exists and is a Map
                                                    final hours =
                                                        businessDetails[
                                                                'businessHours']
                                                            [day];
                                                    if (hours is! Map) {
                                                      return SizedBox
                                                          .shrink(); // Return an empty widget if data is invalid
                                                    }

                                                    // Extract open and close times safely
                                                    String openTime =
                                                        hours['open']
                                                                ?.toString() ??
                                                            'Not Set';
                                                    String closeTime =
                                                        hours['close']
                                                                ?.toString() ??
                                                            'Not Set';

                                                    return Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 12.h),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          // Day Name
                                                          Text(
                                                            day.toString(),
                                                            style: t.displayMedium?.copyWith(
                                                                color: Get
                                                                        .isDarkMode
                                                                    ? AppColors
                                                                        .whiteColor
                                                                    : AppColors
                                                                        .black80),
                                                          ),
                                                          // Open and Close Times
                                                          Text(
                                                            "$openTime - $closeTime",
                                                            style: t.bodySmall?.copyWith(
                                                                color: Get
                                                                        .isDarkMode
                                                                    ? AppColors
                                                                        .whiteColor
                                                                    : AppColors
                                                                        .black80),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }).toList()
                                                else ...[
                                                  // Display a fallback message if businessHours is null or not a Map
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 12.h),
                                                    child: Text(
                                                      "Business hours not available",
                                                      style: t.bodySmall
                                                          ?.copyWith(
                                                              color: Get
                                                                      .isDarkMode
                                                                  ? AppColors
                                                                      .whiteColor
                                                                  : AppColors
                                                                      .black80),
                                                    ),
                                                  ),
                                                ]
                                              ],
                                            ),
                                          ),
                                          // Container(
                                          //     width: double.maxFinite,
                                          //     height: 226.h,
                                          //     decoration: BoxDecoration(
                                          //       color: AppColors.greyColor,
                                          //       border: Border.all(
                                          //           color: AppThemes
                                          //               .getFillColor(),
                                          //           width: 5.h),
                                          //     ),
                                          //     child: GoogleMapScreen(
                                          //         latLng: LatLng(
                                          //             businessDetails[
                                          //                 'latitude'],
                                          //             businessDetails[
                                          //                 'longitude']))),
                                          VSpace(50.h),
                                        ],
                                      ),
                                    if (selectedIndex == 1)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (businessDetails['reviews']
                                                  ?.length ==
                                              0)
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20.w),
                                              child: Text(
                                                "No reviews yet",
                                                style: t.bodyMedium?.copyWith(
                                                    color: Get.isDarkMode
                                                        ? AppColors.whiteColor
                                                        : AppColors.black50),
                                              ),
                                            ),
                                          if (businessDetails['reviews']
                                                  ?.length !=
                                              0)
                                            ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount:
                                                    businessDetails['reviews']
                                                            ?.length ??
                                                        0,
                                                itemBuilder: (context, i) {
                                                  // Get the business owner's userId (from the review's user)
                                                  final businessUserId =
                                                      businessDetails['reviews']
                                                                  [i]['userId']
                                                              ['_id'] ??
                                                          '';

                                                  // Check if the logged-in user's ID matches the business owner's ID
                                                  final isUserMatch =
                                                      userId == businessUserId;
                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 33.h),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            // Profile Picture
                                                            Container(
                                                              height:
                                                                  40.0, // Profile size
                                                              width: 40.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .blue,
                                                                    width: 2.0),
                                                              ),
                                                              child: ClipOval(
                                                                child: Image
                                                                    .network(
                                                                  (businessDetails['reviews'][i]['userId']['profile']
                                                                              ?.toString()
                                                                              .isNotEmpty ??
                                                                          false)
                                                                      ? businessDetails['reviews'][i]['userId']
                                                                              [
                                                                              'profile']
                                                                          .toString()
                                                                      : "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500&auto=format&fit=crop&q=60",
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  errorBuilder: (context,
                                                                          error,
                                                                          stackTrace) =>
                                                                      Image
                                                                          .network(
                                                                    "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500&auto=format&fit=crop&q=60",
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                width: 12.0),

                                                            // User Info, Stars & Time
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  // Username
                                                                  Text(
                                                                    (businessDetails['reviews'][i]['userId']?['username']?.toString().isNotEmpty ??
                                                                            false)
                                                                        ? businessDetails['reviews'][i]['userId']['username']
                                                                            .toString()
                                                                        : 'N/A',
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),

                                                                  SizedBox(
                                                                      height:
                                                                          2),

                                                                  // Star Rating & Date
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      // Star Rating
                                                                      Row(
                                                                        children:
                                                                            List.generate(
                                                                          5,
                                                                          (index) {
                                                                            return Icon(
                                                                              index < (businessDetails['reviews'][i]['review'] as num).toInt() ? Icons.star : Icons.star_border,
                                                                              color: Colors.amber,
                                                                              size: 18.0,
                                                                            );
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),

                                                            // Edit/Delete Buttons (Only if user is owner)
                                                            if (isUserMatch) ...[
                                                              Wrap(
                                                                spacing: 4,
                                                                children: [
                                                                  // Edit Button
                                                                  IconButton(
                                                                    icon: Icon(
                                                                        Icons
                                                                            .edit,
                                                                        color: Colors
                                                                            .blue,
                                                                        size:
                                                                            20),
                                                                    onPressed:
                                                                        () {
                                                                      showEditReviewDialog(
                                                                        context,
                                                                        businessID,
                                                                        businessDetails['reviews'][i]
                                                                            [
                                                                            '_id'],
                                                                      );
                                                                    },
                                                                  ),

                                                                  // Delete Button with Dialog
                                                                  IconButton(
                                                                    icon: Icon(
                                                                        Icons
                                                                            .delete,
                                                                        color: Colors
                                                                            .red,
                                                                        size:
                                                                            20),
                                                                    onPressed:
                                                                        () {
                                                                      Get.defaultDialog(
                                                                        title:
                                                                            "Delete Review",
                                                                        middleText:
                                                                            "Are you sure you want to delete this review?",
                                                                        textConfirm:
                                                                            "Delete",
                                                                        textCancel:
                                                                            "Cancel",
                                                                        confirmTextColor:
                                                                            Colors.white,
                                                                        onConfirm:
                                                                            () async {
                                                                          Get.back(); // Close dialog
                                                                          await deleteReview(businessDetails['reviews'][i]
                                                                              [
                                                                              '_id']);
                                                                        },
                                                                      );
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ],
                                                        ),

                                                        SizedBox(height: 6.h),

                                                        // Review Text
                                                        Text(
                                                          businessDetails[
                                                                      'reviews'][i]
                                                                  [
                                                                  'feedback'] ??
                                                              '',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Get
                                                                    .isDarkMode
                                                                ? AppColors
                                                                    .whiteColor
                                                                : AppColors
                                                                    .black50,
                                                          ),
                                                        ),
                                                        SizedBox(height: 10.h),

                                                        Text(
                                                          formatMemberSince(businessDetails[
                                                                          'userId']
                                                                      [
                                                                      'createdAt'] !=
                                                                  null
                                                              ? DateTime.parse(
                                                                  businessDetails[
                                                                          'userId']
                                                                      [
                                                                      'createdAt'])
                                                              : DateTime.now()),
                                                          style: t.bodySmall
                                                              ?.copyWith(
                                                                  color: AppColors
                                                                      .black50),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                          VSpace(20.h),
                                        ],
                                      ),
                                  ]),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  floatingActionButton: FloatingActionButton.extended(
                    onPressed: () {
                      showReviewDialog(context, businessID);
                    },
                    label: Text("Review"),
                    icon: Icon(Icons.edit),
                    backgroundColor: AppColors.mainColor,
                  ),
                ));
          });
  }

  Future<void> deleteReview(String reviewId) async {
    final token = await SharedPreferencesService.getAccessToken();
    try {
      // Show loading dialog

      // Replace with your API endpoint
      String url = "${AppConstants.baseUri}/reviews/$reviewId";

      var response = await http.delete(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token}",
        },
      );

      if (response.statusCode == 200) {
        fetchBusinessDetails(businessID);
        Get.snackbar("Success", "Review deleted successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);

        Get.back(); // Close loading dialog
      } else {
        Get.snackbar("Error", "Failed to delete review",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        Get.back(); // Close loading dialog
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  void showEditReviewDialog(
      BuildContext context, String businessID, String reviewId) {
    final ReviewController controller = Get.put(ReviewController());
    final ImagePicker picker = ImagePicker();

    // Prefill review information
    var selectedReview = businessDetails['reviews']
        .firstWhere((review) => review['_id'] == reviewId, orElse: () => null);

    if (selectedReview != null) {
      controller.rating.value = (selectedReview['review'] as num).toDouble();
      controller.feedback.value = selectedReview['feedback'];
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                "Edit Review",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Rate your experience"),
                    RatingBar.builder(
                      initialRating: controller.rating.value,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) =>
                          Icon(Icons.star, color: Colors.amber),
                      onRatingUpdate: (rating) =>
                          controller.rating.value = rating,
                    ),
                    SizedBox(height: 10),
                    TextField(
                      maxLines: 3,
                      controller: TextEditingController(
                          text: controller.feedback.value),
                      decoration: InputDecoration(
                          hintText: "Write your feedback here..."),
                      onChanged: (value) => controller.feedback.value = value,
                    ),
                    SizedBox(height: 10),
                    Obx(() => Wrap(
                          children: controller.images.map((image) {
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Image.file(image, width: 50, height: 50),
                            );
                          }).toList(),
                        )),
                    TextButton(
                      onPressed: () async {
                        final pickedFile =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          controller.images.add(File(pickedFile.path));
                        }
                      },
                      child: Text("Add Image"),
                    ),
                    SizedBox(height: 10),
                    Obx(() {
                      return AppButton(
                        isLoading: controller.isLoading.value,
                        onTap: () async {
                          controller.onLoading(true); // Start loading
                          await updateReview(context, reviewId, controller);
                          controller.onLoading(false); // Stop loading
                        },
                        text: "Submit",
                      );
                    }),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> updateReview(BuildContext context, String reviewId,
      ReviewController controller) async {
    try {
      final url =
          '${AppConstants.baseUri}/reviews/$reviewId'; // Replace with actual URL
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${await SharedPreferencesService.getAccessToken()}',
        },
        body: json.encode({
          'review': controller.rating.value,
          'feedback': controller.feedback.value,
          // "pictures": controller.images.map((image) => image.path).toList(),
          // 'businessId': controller.businessId,
          // 'likeCount': controller.likeCount,
        }),
      );
      print("Response: ${response.body}");
      if (response.statusCode == 200) {
        // Handle success

        Get.back();
        fetchBusinessDetails(businessID);
        Get.snackbar(
          "Success",
          "Review updated successfully!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        // Handle failure
        print("Failed to update review");
      }
    } catch (e) {
      print("Error updating review: $e");
    }
  }

  void showReviewDialog(BuildContext context, String businessID) {
    final ReviewController controller = Get.put(ReviewController());
    final ImagePicker picker = ImagePicker();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                "Submit Review",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Rate your experience"),
                    RatingBar.builder(
                      initialRating: controller.rating.value,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) =>
                          Icon(Icons.star, color: Colors.amber),
                      onRatingUpdate: (rating) =>
                          controller.rating.value = rating,
                    ),
                    SizedBox(height: 10),
                    TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                          hintText: "Write your feedback here..."),
                      onChanged: (value) => controller.feedback.value = value,
                    ),
                    SizedBox(height: 10),
                    Obx(() => Wrap(
                          children: controller.images.map((image) {
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Image.file(image, width: 50, height: 50),
                            );
                          }).toList(),
                        )),
                    TextButton(
                      onPressed: () async {
                        final pickedFile =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          controller.images.add(File(pickedFile.path));
                        }
                      },
                      child: Text("Add Image"),
                    ),
                    SizedBox(height: 10),
                    Obx(() {
                      return AppButton(
                        isLoading: controller.isLoading.value,
                        onTap: () async {
                          controller.onLoading(true); // Start loading
                          await submitReview(context, businessID, controller);
                          controller.onLoading(false); // Stop loading
                        },
                        text: "Submit",
                      );
                    }),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Submit Review Function
  Future<void> submitReview(BuildContext context, String businessID,
      ReviewController controller) async {
    if (controller.rating.value == 0 || controller.feedback.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please provide a rating and feedback.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      final token = await SharedPreferencesService.getAccessToken();
      if (token == null) {
        Get.snackbar(
          "Error",
          "User authentication failed. Please login again.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      List<String> imageUrls = [];
      for (var image in controller.images) {
        String? imageUrl = await ImageUploadService.uploadImage(image);
        if (imageUrl != null) {
          imageUrls.add(imageUrl);
        }
      }
      print("Image URLs: $imageUrls");
      final body = json.encode({
        "review": controller.rating.value.toInt().toString(),
        "feedback": controller.feedback.value,
        "businessId": businessID,
        "pictures": imageUrls,
      });

      final response = await http.post(
        Uri.parse("${AppConstants.baseUri}/reviews"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: body,
      );

      final jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      if (response.statusCode == 200 || jsonResponse['success'] == true) {
        Get.snackbar(
          "Success",
          "Review submitted successfully!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        fetchBusinessDetails(businessID);
        Navigator.of(context).pop(); // Close dialog
      } else {
        Get.snackbar(
          "Error",
          jsonResponse['message'] ?? "Something went wrong!",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to submit review. Try again!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      controller.onLoading(false);
    }
  }

  // Function to capitalize the first letter of a string
  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) return input; // Return empty string if input is empty
    return input[0].toUpperCase() + input.substring(1);
  }

  double calculateAverageRating(List reviews) {
    if (reviews.isEmpty) return 0.0; // If there are no reviews, return 0.0

    double totalRating = 0.0;
    for (var review in reviews) {
      totalRating += review['review']; // Summing up the ratings
    }

    return totalRating / reviews.length; // Return the average
  }

  String formatMemberSince(DateTime createdAt) {
    final DateFormat formatter = DateFormat('MMMM yyyy'); // "May 2023" format
    return 'Member since ${formatter.format(createdAt)}';
  }

  String formatDate(String dateString) {
    // Parse the date string into a DateTime object
    DateTime parsedDate = DateTime.parse(dateString);

    // Format the DateTime object to the desired format
    return DateFormat('MMM dd, yyyy hh:mm a').format(parsedDate);
  }

  CarouselSlider caroselSection(CarouselController controller, TextTheme t) {
    return CarouselSlider(
        carouselController: controller,
        items: imagelist
            .map(
              (e) => Container(
                height: Dimensions.screenHeight * .3,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: e != null && e.isNotEmpty
                        ? NetworkImage(e)
                        : AssetImage("assets/images/placeholder.jpg")
                            as ImageProvider, // Fallback image
                    fit: BoxFit.cover,
                  ),
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(18.r)),
                ),
                child: Padding(
                  padding: Dimensions.kDefaultPadding,
                  child: Column(
                    children: [
                      VSpace(60.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkResponse(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              padding: EdgeInsets.all(7.h),
                              decoration: BoxDecoration(
                                color: AppColors.mainColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.arrow_back,
                                color: AppColors.whiteColor,
                                size: 20.h,
                              ),
                            ),
                          ),
                          // InkResponse(
                          //   onTap: () {
                          //     setState(() {
                          //       isFilled = !isFilled;
                          //       if (isFilled == true) {
                          //         Helpers.showSnackBar(
                          //             msg: 'Added to the wishlist',
                          //             bgColor: AppColors.greenColor);
                          //       } else {
                          //         Helpers.showSnackBar(
                          //             msg: 'Removed to the wishlist',
                          //             bgColor: AppColors.greenColor);
                          //       }
                          //     });
                          //   },
                          //   child: Container(
                          //     padding: EdgeInsets.all(7.h),
                          //     decoration: BoxDecoration(
                          //       color: AppColors.mainColor,
                          //       shape: BoxShape.circle,
                          //     ),
                          //     child: Icon(
                          //       isFilled
                          //           ? Icons.favorite
                          //           : Icons.favorite_border_outlined,
                          //       size: 20.h,
                          //       color: AppColors.whiteColor,
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                      const Spacer(),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Container(
                      //       padding: EdgeInsets.symmetric(
                      //           vertical: 7.h, horizontal: 11.w),
                      //       decoration: BoxDecoration(
                      //         color: AppColors.mainColor,
                      //         borderRadius: Dimensions.kBorderRadius,
                      //       ),
                      //       child: Row(
                      //         children: [
                      //           Icon(
                      //             Icons.visibility_outlined,
                      //             size: 14.h,
                      //             color: AppColors.whiteColor,
                      //           ),
                      //           HSpace(5.w),
                      //           Text(
                      //             '1105',
                      //             style: t.bodySmall
                      //                 ?.copyWith(color: AppColors.whiteColor),
                      //           )
                      //         ],
                      //       ),
                      //     ),
                      //     DotsIndicator(
                      //       dotsCount: imagelist.length,
                      //       position: carouselIndex,
                      //       decorator: DotsDecorator(
                      //         color: AppColors.whiteColor, // Inactive color
                      //         activeColor: AppColors.mainColor,
                      //       ),
                      //     ),
                      //     InkResponse(
                      //       onTap: () {},
                      //       child: Container(
                      //         padding: EdgeInsets.all(7.h),
                      //         decoration: BoxDecoration(
                      //           color: AppColors.mainColor,
                      //           shape: BoxShape.circle,
                      //         ),
                      //         child: Icon(
                      //           Icons.share,
                      //           color: AppColors.whiteColor,
                      //           size: 20.h,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // VSpace(20.h),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
        options: CarouselOptions(
          height: Dimensions.screenHeight * .4,
          viewportFraction: 1,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          enlargeFactor: 0.3,
          onPageChanged: (index, _) {
            setState(() {
              carouselIndex = index;
            });
          },
          scrollDirection: Axis.horizontal,
        ));
  }

  List<String> imagelist = [
    "https://img.freepik.com/premium-photo/modern-corporate-architecture-can-be-seen-cityscape-office-buildings_410516-276.jpg?size=626&ext=jpg&ga=GA1.1.1412446893.1704672000&semt=sph",
    "https://img.freepik.com/premium-photo/modern-corporate-architecture-can-be-seen-cityscape-office-buildings_410516-276.jpg?size=626&ext=jpg&ga=GA1.1.1412446893.1704672000&semt=sph",
    "https://img.freepik.com/premium-photo/modern-corporate-architecture-can-be-seen-cityscape-office-buildings_410516-276.jpg?size=626&ext=jpg&ga=GA1.1.1412446893.1704672000&semt=sph",
  ];
  List<String> categoryList = ["Details", "Reviews"];
}
