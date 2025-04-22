import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../routes/routes_name.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/spacing.dart';

class SearchResultsScreen extends StatefulWidget {
  final String? query; // The search query

  // Constructor to pass the search query
  const SearchResultsScreen({super.key, this.query});

  @override
  _SearchResultsScreenState createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  bool isLoading = true;
  List<dynamic> searchResults = [];

  @override
  void initState() {
    super.initState();
    final arguments = Get.arguments ?? {};
    setState(() {
      searchResults = arguments['query'] ?? []; // Default empty categoryId
    });
  }

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: CustomAppBar(
        title: "Search Results", // Directly use categoryName as it is always set
      ),
      body: SingleChildScrollView( // Wrap the body with SingleChildScrollView for scrolling
        child: Padding(
          padding: Dimensions.kDefaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VSpace(10.h),
              searchResults.isEmpty
                  ? Center(child: Text('No results found'))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: searchResults.length,
                      itemBuilder: (context, i) {
                        final business = searchResults[i];

                        return InkWell(
                          borderRadius: Dimensions.kBorderRadius,
                          onTap: () {
                            // Get the business ID
                            final businessID = business['_id'];

                            // Navigate to the listing details screen and pass the business ID
                            Get.toNamed(
                              RoutesName.listingDetailsScreen,
                              arguments: businessID, // Pass businessID as argument
                            );
                          },
                          child: Container(
                            width: double.maxFinite,
                            margin: EdgeInsets.only(bottom: 12.h),
                            padding: EdgeInsets.symmetric(
                                vertical: 15.h, horizontal: 12.w),
                            decoration: BoxDecoration(
                              color: AppThemes.getFillColor(),
                              borderRadius: Dimensions.kBorderRadius,
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.grey[800]
                                          : AppColors.mainColor.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Center(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          business['name'][0],
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                HSpace(12.w),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        business['name'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: t.displayMedium?.copyWith(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      VSpace(11.h),
                                      Text(business['categoryType']['name'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: t.bodySmall),
                                    ],
                                  ),
                                ),
                                HSpace(7.w),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 64.w,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 4.h, horizontal: 8.w),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(22.r),
                                            color: Get.isDarkMode
                                                ? AppColors.darkBgColor
                                                : AppColors.whiteColor,
                                          ),
                                          child: Center(
                                            child: Text(
                                              business['tags']
                                                  [0], // Display the first tag
                                              style: t.bodySmall,
                                            ),
                                          )),
                                      VSpace(11.h),
                                      Row(
                                        children: [
                                          Image.asset(
                                            "$rootImageDir/location.png",
                                            height: 14.h,
                                            color: AppThemes.getGreyColor(),
                                          ),
                                          HSpace(5.w),
                                          Expanded(
                                            child: Text(
                                                business['locationName'] ?? 'N/A',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: t.bodySmall?.copyWith(
                                                    color: AppThemes
                                                        .getGreyColor())),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                VSpace(5.h),
                              ],
                            ),
                          ),
                        );
                      }),
            ],
          ),
        ),
      ),
    );
  }
}
