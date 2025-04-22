import 'dart:convert';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yellowpages/config/dimensions.dart';
import 'package:yellowpages/controllers/auth_controller.dart';
import 'package:yellowpages/controllers/businessController.dart';
import 'package:yellowpages/data/models/Category.dart';
import 'package:yellowpages/data/models/myBusiness.dart';
import 'package:yellowpages/data/services/SharedPreferencesService.dart';
import 'package:yellowpages/routes/routes_name.dart';
import 'package:yellowpages/utils/app_constants.dart';
import 'package:yellowpages/views/screens/home/SearchResults.dart';
import 'package:yellowpages/views/widgets/app_button.dart';
import 'package:yellowpages/views/widgets/custom_textfield.dart';
import 'package:yellowpages/views/widgets/searchabledropdown.dart';
import 'package:yellowpages/views/widgets/spacing.dart';
import '../../../config/app_colors.dart';
import '../../../themes/themes.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_painter.dart';
import '../../widgets/my_listing_tile.dart';
import 'package:http/http.dart' as http;
import 'package:yellowpages/controllers/profile_controller.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  AuthController authController = Get.find<AuthController>();
  late final ProfileController _profileController;
  final TextEditingController searchController = TextEditingController();
  final TextEditingController searchLocationController =
      TextEditingController();
  List<dynamic> searchResults = []; // Hold search results
  bool isLoadingSearch = false; // Loading state for API call
  late BusinessController bannerController;
  List<String> cities = []; // Store fetched cities here
  String? selectedCity; // Store selected city
  List<String> filteredCities = []; // For search filtering

  // Replace with your actual API call
  Future<void> hitSearchAPI(String query, String city) async {
    setState(() {
      isLoadingSearch = true; // Show loading indicator
    });
    print('API hit with query: $query');

    // Retrieve the access token from SharedPreferences
    final String? token = await SharedPreferencesService.getAccessToken();

    if (token == null) {
      print('No access token found.');
      setState(() {
        isLoadingSearch = false;
      });
      return;
    }

    final url = "${AppConstants.baseUri}/business/search";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Pass the token here
        },
        body: json.encode({
          'searchQuery': query, // Add the query as part of the request body
          'city': city
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          searchResults = data['businesses']; // Store the results
          isLoadingSearch = false;

        });

        // Navigate to the new screen and pass the search results
        if (searchResults.isNotEmpty) {
          Get.toNamed(
            RoutesName.searchResultscreen,
            arguments: {
              'query': searchResults, // Pass the search query
            },
          );
        }else{
          Get.snackbar("Sorry", "No Search Result Found");
        }
      } else {
        setState(() {
          isLoadingSearch = false;

          searchController.clear();
          selectedCity = null;
        });
        Get.snackbar("Error", "No Search Result Found");
        throw Exception('Failed to load businesses');
      }
    } catch (error) {
      setState(() {
        isLoadingSearch = false;
      });
      print(error);
    }
  }

  List<Category> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchCities();
    bannerController = Get.find<BusinessController>();

    _profileController = Get.find<ProfileController>();
  }

  Future<void> fetchCities() async {
    try {
      final response =
          await http.get(Uri.parse('${AppConstants.baseUri}/cities'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          cities = List<String>.from(data['cities']);
        });
      } else {
        Get.snackbar("Error", "Failed to load cities");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load cities: $e");
    }
  }

  void _filterCities(String query) {
    setState(() {
      filteredCities = cities
          .where((city) => city.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> fetchCategories() async {
    final url = "${AppConstants.baseUrl}${AppConstants.categoryUri}";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        final List<Category> fetchedCategories = (data['categories'] as List)
            .map((e) => Category.fromJson(e))
            .toList();
        setState(() {
          categories = fetchedCategories;
          isLoading = false;
        });
      } else {
        // Handle API error
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to load categories');
      }
    } catch (error) {
      // Handle network error
      setState(() {
        isLoading = false;
      });
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _profileController.user.value;

    TextTheme t = Theme.of(context).textTheme;
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(
        toolberHeight: 100.h,
        prefferSized: 100.h,
        isTitleMarginTop: true,
        leading: Center(),
        title: "Home",
        actions: [
          authController.isLogginIn.value == false
              ? _buildLoginButton()
              : Center(),
          HSpace(20.w),
        ],
      ),
      // drawer: Drawer(
      //   child: SingleChildScrollView(
      //     child: Column(
      //       children: [
      //         Container(
      //             width: double.maxFinite,
      //             height: 300.h,
      //             decoration: BoxDecoration(
      //               color: AppColors.mainColor.withOpacity(.1),
      //             ),
      //             child: Column(
      //               children: [
      //                 VSpace(53.h),
      //                 SizedBox(
      //                   width: 120.h,
      //                   height: 120.h,
      //                   child: CustomPaint(
      //                     painter: HalfTransparentBorderPainter(
      //                         transparentColor: Get.isDarkMode
      //                             ? const Color(0xff271F23)
      //                             : const Color(0xffFBE6E2)),
      //                     child: Container(
      //                       decoration: BoxDecoration(
      //                           shape: BoxShape.circle,
      //                           border: Border.all(
      //                             color: Get.isDarkMode
      //                                 ? const Color(0xff271F23)
      //                                 : AppColors.mainColor.withOpacity(.005),
      //                             width: 7.h,
      //                           )),
      //                       child: ClipOval(
      //                         child: user.profile != null &&
      //                                 user.profile!.isNotEmpty
      //                             ? Image.network(
      //                                 user.profile!,
      //                                 fit: BoxFit.cover,
      //                               )
      //                             : CircleAvatar(
      //                                 radius: 60
      //                                     .h, // Set the radius as per your design
      //                                 backgroundColor: AppColors
      //                                     .mainColor, // Background color for the avatar
      //                                 child: Text(
      //                                   user.username.isNotEmpty
      //                                       ? user.username[0].toUpperCase()
      //                                       : '', // First character in uppercase
      //                                   style: TextStyle(
      //                                     fontSize: 40
      //                                         .h, // Adjust font size as needed
      //                                     color: Colors
      //                                         .white, // Text color (white for visibility)
      //                                   ),
      //                                 ),
      //                               ),
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //                 VSpace(20.h),
      //                 Text(
      //                   user.username,
      //                   maxLines: 1,
      //                   overflow: TextOverflow.ellipsis,
      //                   style: t.titleSmall,
      //                 ),
      //                 VSpace(10.h),
      //                 Text(
      //                   user.email,
      //                   maxLines: 1,
      //                   overflow: TextOverflow.ellipsis,
      //                   style: t.displayMedium?.copyWith(
      //                       fontWeight: FontWeight.w600,
      //                       color: Get.isDarkMode
      //                           ? AppColors.whiteColor
      //                           : AppColors.greyColor),
      //                 )
      //               ],
      //             )),
      //         VSpace(20.h),
      //         ListView.builder(
      //             shrinkWrap: true,
      //             physics: const NeverScrollableScrollPhysics(),
      //             itemCount: drawerList.length,
      //             itemBuilder: (context, i) {
      //               return ListTile(
      //                 onTap: () {
      //                   if (i == 0) {
      //                     Navigator.pop(context);
      //                     Get.toNamed(RoutesName.myPackageScreen);
      //                   } else if (i == 1) {
      //                     Navigator.pop(context);
      //                     Get.toNamed(RoutesName.transactionScreen);
      //                   } else if (i == 2) {
      //                     Get.toNamed(RoutesName.paymentHistoryScreen);
      //                   } else if (i == 3) {
      //                     Navigator.pop(context);
      //                     Get.toNamed(RoutesName.productEnquiryScreen);
      //                   } else if (i == 4) {
      //                     Navigator.pop(context);
      //                     Get.toNamed(RoutesName.myListingScreen);
      //                   } else if (i == 5) {
      //                     Navigator.pop(context);
      //                     Get.toNamed(RoutesName.supportTicketListScreen);
      //                   }
      //                 },
      //                 leading: SvgPicture.asset(
      //                   drawerList[i].img,
      //                   color: Get.isDarkMode
      //                       ? AppColors.whiteColor
      //                       : AppColors.blackColor,
      //                   height: i == 1
      //                       ? 23.h
      //                       : i == 2
      //                           ? 22.h
      //                           : 20.h,
      //                   width: i == 1
      //                       ? 23.h
      //                       : i == 2
      //                           ? 22.h
      //                           : 20.h,
      //                 ),
      //                 title: Text(
      //                   drawerList[i].text,
      //                   style: t.bodyMedium,
      //                 ),
      //               );
      //             })
      //       ],
      //     ),
      //   ),
      // ),

      body: SingleChildScrollView(
        child: Padding(
          padding: Dimensions.kDefaultPadding,
          child: Column(
            children: [
              VSpace(20.h),
              // search

              Stack(
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              hintext: "What? (E.g. plumber)",
                              controller: searchController,
                            ),
                          ),
                        ],
                      ),
                      VSpace(8.h),
                      Row(
                        children: [
                          Expanded(
                            child: CustomSearchableDropdown(
                              height: 46.h,
                              width: double.infinity,
                              items: cities, // Your full list of cities
                              selectedValue: selectedCity,
                              onChanged: (value) {
                                setState(() {
                                  selectedCity = value;
                                });
                              },
                              hint: "Where? (E.g. Punjab)",
                              fontSize: 16.sp,
                              hintStyle: TextStyle(fontSize: 16.sp),
                            ),
                          ),
                          HSpace(16.w),
                          GestureDetector(
                            onTap: () {
                              String query = searchController.text;
                              print(selectedCity);
                              if (query.isNotEmpty && selectedCity != null) {
                                print('Search Query: $query');
                                hitSearchAPI(
                                    query, selectedCity!); // Call the API
                              } else {
                                print('Search Query is empty');
                              }
                            },
                            child: isLoadingSearch == false
                                ? Container(
                                    height: 46.h,
                                    width: 46.h,
                                    padding: EdgeInsets.all(10.h),
                                    decoration: BoxDecoration(
                                      color: AppColors.mainColor,
                                      borderRadius: Dimensions.kBorderRadius,
                                    ),
                                    child:
                                        Image.asset("$rootImageDir/search.png"),
                                  )
                                : CircularProgressIndicator(
                                    color: AppColors.mainColor,
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              VSpace(25.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Top Categories",
                    style: t.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.toNamed(RoutesName.topCategoryScreen);
                    },
                    child: Text(
                      "See All",
                      style: t.displayMedium?.copyWith(
                          color: Get.isDarkMode
                              ? AppColors.whiteColor
                              : AppColors.greyColor),
                    ),
                  ),
                ],
              ),
              VSpace(20.h),

              isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                      color: AppColors.mainColor,
                    ))
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: categories.map((category) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: InkWell(
                              onTap: () {
                                Get.toNamed(
                                  RoutesName.myListingScreen,
                                  arguments: {
                                    'categoryName': category.name,
                                    'categoryId': category.id,
                                  },
                                );
                              },
                              child: Column(
                                children: [
                                  Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.grey[800]
                                          : AppColors.mainColor
                                              .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Center(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          category.name[0],
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: 60),
                                    child: Text(
                                      category.name,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
              VSpace(32.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hurry! Don’t Miss Out!",
                    style: t.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              VSpace(20.h),

              Obx(() => bannerController.imageUrls.isNotEmpty
                  ? CarouselSlider(
                      options: CarouselOptions(
                        height: 180.0,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 0.9,
                      ),
                      items: bannerController.imageUrls.map((imageUrl) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        );
                      }).toList(),
                    )
                  : SizedBox.shrink()),

              VSpace(25.h),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Recently viewed",
                        style: t.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.toNamed(RoutesName.myListingScreen);
                        },
                        child: Text(
                          "See All",
                          style: t.displayMedium?.copyWith(
                            color: Get.isDarkMode
                                ? AppColors.whiteColor
                                : AppColors.greyColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  VSpace(12.h),
                  GetX<BusinessController>(
                    builder: (businessController) {
                      // Check if loading is true
                      if (businessController.isLoading.value) {
                        return Center(child: CircularProgressIndicator());
                      }

                      // Check if there are no businesses
                      if (businessController.recentBusinesses.isEmpty) {
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
                                'No recent businesses available!',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        );
                      }

                      // Show list of businesses
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 3 / 4,
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 10.h,
                        ),
                        itemCount: businessController.recentBusinesses.length,
                        itemBuilder: (context, i) {
                          Business business =
                              businessController.recentBusinesses[i];
                          return InkWell(
                            onTap: () {
                              Get.toNamed(RoutesName.listingDetailsScreen,
                                  arguments: business.id);
                            },
                            child: MyListTile(
                              bgColor: AppThemes.getFillColor(),
                              image: business.logo.isNotEmpty
                                  ? business.logo
                                  : "https://images.unsplash.com/photo-1460472178825-e5240623afd5?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8YnVpbGRpbmdzfGVufDB8fDB8fHww",
                              title: business.name,
                              description:
                                  "Category: ${business.categoryType.name}",
                              location: business.locationName,
                              rating:
                                  "4.5", // Update if you have a rating field
                              save: Container(
                                height: 29.h,
                                width: 29.h,
                                decoration: BoxDecoration(
                                  color: AppColors.mainColor,
                                  borderRadius: BorderRadius.circular(14.5.r),
                                ),
                                child: Icon(
                                  Icons.favorite_border_outlined,
                                  size: 16.h,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              VSpace(30.h),
            ],
          ),
        ),
      ),
    );
  }

  // 🟠 Login Button
  Widget _buildLoginButton() {
    return GestureDetector(
      onTap: () {
        Get.toNamed("/loginScreen"); // Replace with actual route name
      },
      child: Container(
        margin: EdgeInsets.only(top: 20), // Add margin from above
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: Colors.grey[300]!), // Add border with light grey color
        ),
        child: Text(
          "Login",
          style: TextStyle(
            color: Colors.black, // Black text
            fontSize: 14,
            fontWeight: FontWeight.w500, // Optional: Adjust font weight
          ),
        ),
      ),
    );
  }

  final List<DrawerData> drawerList = [
    DrawerData(img: "$rootSvgDir/my_packages.svg", text: "My Packages"),
    DrawerData(img: "$rootSvgDir/transaction_history.svg", text: "Transaction"),
    DrawerData(img: "$rootSvgDir/payment_history.svg", text: "Payment History"),
    DrawerData(img: "$rootSvgDir/product_inquiry.svg", text: "Product Inquiry"),
    DrawerData(img: "$rootSvgDir/my_listings.svg", text: "My Listings"),
    DrawerData(img: "$rootSvgDir/support_ticket.svg", text: "Support Ticket"),
  ];

  final List<DemoCategories> demoCategoryList = [
    DemoCategories(image: "$rootImageDir/hotel.png", name: "Hotel"),
    DemoCategories(image: "$rootImageDir/shop.png", name: "Shopping"),
    DemoCategories(image: "$rootImageDir/furniture.png", name: "Furniture"),
    DemoCategories(image: "$rootImageDir/book.png", name: "Education"),
  ];
}

class DemoCategories {
  final String image;
  final String name;
  DemoCategories({required this.image, required this.name});
}

class DrawerData {
  String img;
  String text;
  DrawerData({required this.img, required this.text});
}
