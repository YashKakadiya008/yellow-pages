import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yellowpages/config/app_colors.dart';
import 'package:yellowpages/config/dimensions.dart';
import 'package:yellowpages/data/models/Category.dart';
import 'package:yellowpages/themes/themes.dart';
import 'package:yellowpages/views/widgets/custom_appbar.dart';
import 'package:yellowpages/views/widgets/text_theme_extension.dart';
import 'package:http/http.dart' as http;
import '../../../routes/page_index.dart';
import '../../../utils/app_constants.dart';
import '../../widgets/spacing.dart';

class TopCategoryScreen extends StatefulWidget {
  TopCategoryScreen({super.key});

  @override
  _TopCategoryScreenState createState() => _TopCategoryScreenState();
}

class _TopCategoryScreenState extends State<TopCategoryScreen> {
  late Future<List<Category>> categories;

  @override
  void initState() {
    super.initState();
    categories = fetchCategories();
  }

  // Fetch the real categories from the API
  Future<List<Category>> fetchCategories() async {
    final response = await http
        .get(Uri.parse(AppConstants.baseUrl + AppConstants.categoryUri));
    if (response.statusCode == 200) {
      // Parse the response
      final List<dynamic> data = json.decode(response.body)['categories'];
      return data.map((category) => Category.fromJson(category)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Top Categories'),
      body: Padding(
        padding: Dimensions.kDefaultPadding,
        child: FutureBuilder<List<Category>>(
          future: fetchCategories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No categories found.'));
            }

            final categoryList = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: categoryList.length,
                    itemBuilder: (context, i) {
                      final category = categoryList[i];
                      return InkWell(
                        onTap: () {
                          Get.toNamed(
                            RoutesName.myListingScreen,
                            arguments: {
                              'categoryName': category.name,
                              'categoryId': category.id,
                            },
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            leading: CircleAvatar(
                              radius: 28,
                              backgroundColor:
                                  AppColors.mainColor.withOpacity(0.2),
                              child: category.image != null &&
                                      category.image!.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(28),
                                      child: Image.network(
                                        category.image!,
                                        width: 56,
                                        height: 56,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Icon(
                                          Icons.broken_image,
                                          color: AppColors.black80,
                                          size: 28,
                                        ),
                                      ),
                                    )
                                  : Icon(
                                      Icons.category,
                                      color: AppColors.black80,
                                      size: 28,
                                    ),
                            ),
                            title: Text(
                              category.name,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                                fontWeight: FontWeight.w500,
                                color: AppColors.black80,
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.black80,
                              size: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  final List<DemoCategories> demoCategoryList = [
    DemoCategories(
        image: "$rootImageDir/hotel.png", name: "Hotel", listing: '1'),
    DemoCategories(
        image: "$rootImageDir/shop.png", name: "Shopping", listing: '0'),
    DemoCategories(
        image: "$rootImageDir/furniture.png", name: "Furniture", listing: '4'),
    DemoCategories(
        image: "$rootImageDir/book.png", name: "Education", listing: '5'),
    DemoCategories(
        image: "$rootImageDir/hotel.png", name: "Hotel", listing: '1'),
    DemoCategories(
        image: "$rootImageDir/shop.png", name: "Shopping", listing: '0'),
    DemoCategories(
        image: "$rootImageDir/furniture.png", name: "Furniture", listing: '4'),
    DemoCategories(
        image: "$rootImageDir/book.png", name: "Education", listing: '5'),
    DemoCategories(
        image: "$rootImageDir/hotel.png", name: "Hotel", listing: '1'),
    DemoCategories(
        image: "$rootImageDir/shop.png", name: "Shopping", listing: '0'),
    DemoCategories(
        image: "$rootImageDir/furniture.png", name: "Furniture", listing: '4'),
    DemoCategories(
        image: "$rootImageDir/book.png", name: "Education", listing: '5'),
    DemoCategories(
        image: "$rootImageDir/hotel.png", name: "Hotel", listing: '1'),
    DemoCategories(
        image: "$rootImageDir/shop.png", name: "Shopping", listing: '0'),
    DemoCategories(
        image: "$rootImageDir/furniture.png", name: "Furniture", listing: '4'),
    DemoCategories(
        image: "$rootImageDir/book.png", name: "Education", listing: '5'),
    DemoCategories(
        image: "$rootImageDir/hotel.png", name: "Hotel", listing: '1'),
    DemoCategories(
        image: "$rootImageDir/shop.png", name: "Shopping", listing: '0'),
    DemoCategories(
        image: "$rootImageDir/furniture.png", name: "Furniture", listing: '4'),
    DemoCategories(
        image: "$rootImageDir/book.png", name: "Education", listing: '5'),
    DemoCategories(
        image: "$rootImageDir/hotel.png", name: "Hotel", listing: '1'),
    DemoCategories(
        image: "$rootImageDir/shop.png", name: "Shopping", listing: '0'),
    DemoCategories(
        image: "$rootImageDir/furniture.png", name: "Furniture", listing: '4'),
    DemoCategories(
        image: "$rootImageDir/book.png", name: "Education", listing: '5'),
  ];
}

class DemoCategories {
  final String image;
  final String name;
  final String listing;
  DemoCategories(
      {required this.image, required this.name, required this.listing});
}
