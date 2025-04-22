import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:yellowpages/config/dimensions.dart';
import 'package:yellowpages/controllers/businessController.dart';
import 'package:yellowpages/data/models/myBusiness.dart';
import 'package:yellowpages/data/services/ImageUpload.dart';
import 'package:yellowpages/data/services/SharedPreferencesService.dart';
import 'package:yellowpages/themes/themes.dart';
import 'package:yellowpages/utils/app_constants.dart';
import 'package:yellowpages/views/widgets/custom_appbar.dart';
import 'package:yellowpages/views/widgets/google_map_screen.dart';
import 'package:yellowpages/views/widgets/searchabledropdown.dart';
import 'package:yellowpages/views/widgets/spacing.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../config/app_colors.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_custom_dropdown.dart';
import '../../widgets/custom_textfield.dart';

class EditListingScreen extends StatefulWidget {
  @override
  State<EditListingScreen> createState() => _EditListingScreenState();
}

class _EditListingScreenState extends State<EditListingScreen> {
  late Business business;
  late TextEditingController nameController;
  late TextEditingController tagsController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController whatsappController;
  late TextEditingController websiteController;
  late TextEditingController languageController;
  late TextEditingController fbController;
  late TextEditingController instaController;
  late TextEditingController latController;
  late TextEditingController logoImgController;
  late TextEditingController lngController;
  late TextEditingController descriptionController;
  late TextEditingController locationNameController;
  late Map<String, TextEditingController> businessHoursControllers;

  GoogleMapController? _mapController;

  List<String> cities = []; // Store fetched cities here
  String? selectedCity; // Store selected city
  List<String> filteredCities = []; // For search filtering

  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> subcategories = [];
  List<Map<String, dynamic>> subToSubcategories = [];

  String? selectedCategoryId;
  String? selectedSubCategoryId;
  String? selectedSubToSubCategoryId;

  late LatLng selectedLatLng;

  @override
  void initState() {
    super.initState();
    fetchCities();

    business = Get.arguments ??
        ''; // Fetch businessID from arguments, default to empty string if null

    // Initialize controllers with business details
    nameController = TextEditingController(text: business.name);
    tagsController = TextEditingController(text: business.tags.join(', '));
    emailController = TextEditingController(text: business.userId.email);
    phoneController = TextEditingController(text: business.mobilenumber);
    whatsappController = TextEditingController(text: business.whatsappnumber);
    websiteController = TextEditingController(text: business.website);
    languageController = TextEditingController(text: business.language);
    fbController = TextEditingController(text: business.socialMedia.facebook);
    instaController =
        TextEditingController(text: business.socialMedia.instagram);
    latController = TextEditingController(text: business.latitude.toString());
    lngController = TextEditingController(text: business.longitude.toString());
    descriptionController = TextEditingController(text: business.description);
    locationNameController = TextEditingController(text: business.locationName);
    logoImgController = TextEditingController(text: business.logo);
    selectedCity = business.city;
    selectedLatLng = LatLng(business.latitude, business.longitude);

    selectedCategoryId = business.categoryType.id;
    fetchSubCategories(selectedCategoryId!);
    selectedSubCategoryId = business.subcategoryType.id;
    fetchCategories();

    businessHoursControllers = {};
    business.businessHours.forEach((day, hours) {
      businessHoursControllers[day] = TextEditingController(
        text: '${hours['open']} - ${hours['close']}',
      );
    });
  }

  // Function to fetch cities from API
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

  @override
  void dispose() {
    nameController.dispose();
    tagsController.dispose();
    emailController.dispose();
    phoneController.dispose();
    whatsappController.dispose();
    websiteController.dispose();
    languageController.dispose();
    fbController.dispose();
    instaController.dispose();
    latController.dispose();
    lngController.dispose();
    descriptionController.dispose();
    locationNameController.dispose();
    logoImgController.dispose();
    super.dispose();
  }

  final ImagePicker _picker = ImagePicker();
  bool isImgUploading = false;

  Future<void> _pickAndUploadImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    File imageFile = File(pickedFile.path);
    setState(() => isImgUploading = true);

    try {
      String? imageUrl = await ImageUploadService.uploadImage(imageFile);
      if (imageUrl != null) {
        setState(() {
          logoImgController.text = imageUrl;
        });
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    } finally {
      setState(() => isImgUploading = false);
    }
  }

  Future<void> fetchCategories() async {
    try {
      final response =
          await http.get(Uri.parse('${AppConstants.baseUri}/category'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          categories = List<Map<String, dynamic>>.from(data['categories']);
          subcategories.clear();
          subToSubcategories.clear();
        });
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load categories");
    }
  }

  Future<void> fetchSubCategories(String categoryId) async {
    try {
      final response = await http.get(Uri.parse(
          '${AppConstants.baseUri}/subcategory/category/$categoryId'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          subcategories =
              List<Map<String, dynamic>>.from(data['subcategories']);
          subToSubcategories.clear();
        });
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load subcategories");
    }
  }

  Future<void> fetchSubToSubCategories(String subCategoryId) async {
    try {
      final response = await http.get(Uri.parse(
          '${AppConstants.baseUri}/subtosubcategory/subcategory/$subCategoryId'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          subToSubcategories =
              List<Map<String, dynamic>>.from(data['subtosubcategories']);
        });
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load sub-to-subcategories");
    }
  }

  Future<void> submitForm() async {
    setState(() => isLoading = true);

    final body = json.encode({
      "name": nameController.text,
      "categoryType": selectedCategoryId,
      "subcategoryType": selectedSubCategoryId,
      "mobilenumber": phoneController.text,
      "whatsappnumber": whatsappController.text,
      "latitude": double.tryParse(latController.text) ?? 0.0,
      "longitude": double.tryParse(lngController.text) ?? 0.0,
      "description": descriptionController.text,
      "locationName": locationNameController.text,
      "tags": tagsController.text.split(","),
      "logo": logoImgController.text,
      "website": websiteController.text,
      "language": languageController.text,
      "methodOfPayment": "online",
      "businessHours": business.businessHours,
      "socialMedia": {
        "instagram": instaController.text,
        "facebook": fbController.text
      }
    });

    try {
      final token = await SharedPreferencesService.getAccessToken();
      final response = await http.put(
        Uri.parse('${AppConstants.baseUri}/business/user/${business.id}'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + token!
        },
        body: body,
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        final businessController = Get.find<BusinessController>();
        businessController.fetchMyBusiness();

        Get.snackbar("Success",
            responseData['message'] ?? "Business Updated successfully");
      } else {
        Get.snackbar(
            "Error", responseData['message'] ?? "Failed to add business");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to add business");
    } finally {
      setState(() => isLoading = false);
    }
  }

// Time picker for opening and closing times
  Future<void> _selectTime(
      BuildContext context, String day, String type) async {
    // Fetch the current time for the selected day and type (open/close)
    String currentTime = business.businessHours[day]?[type] ?? '09:00';

    // Parse the current time string
    final TimeOfDay initialTime = TimeOfDay.fromDateTime(
      DateFormat('HH:mm').parse(currentTime),
    );

    // Show time picker
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      // Format the picked time into HH:mm format
      String formattedTime = picked.format(context);

      // Update the businessHours map with the selected time
      setState(() {
        // Update the text controller with the formatted time
        String currentText =
            businessHoursControllers[day]?.text ?? 'Select Time';
        List<String> timeParts = currentText.split(' - ');

        // Update either open or close time based on the type
        if (type == 'open') {
          timeParts[0] = formattedTime;
        } else {
          timeParts[1] = formattedTime;
        }

        // Update the businessHoursControllers and business object
        businessHoursControllers[day]?.text =
            '${timeParts[0]} - ${timeParts[1]}';
        business.businessHours[day]?[type] = formattedTime;
      });
    }
  }

  void updateLatLng(LatLng position) {
    setState(() {
      selectedLatLng = position;
      latController.text = position.latitude.toString();
      lngController.text = position.longitude.toString();
    });
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return Scaffold(
      appBar: CustomAppBar(
        title: "Edit Listing", // Directly use categoryName as it is always set
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: Dimensions.kDefaultPadding,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                decoration: BoxDecoration(
                  borderRadius: Dimensions.kBorderRadius,
                  color: AppThemes.getFillColor(),
                ),
                child: Column(
                  children: [
                    Text("Basic Info", style: t.bodyLarge),
                    VSpace(12.h),
                    CustomTextField(
                      bgColor: AppThemes.getDarkBgColor(),
                      controller: nameController,
                      hintext: "Business Name",
                      isSearchIcon: false,
                    ),
                    VSpace(20.h),
                    Text("Logo", style: t.bodyLarge),
                    VSpace(6.h),
                    if (isImgUploading)
                      Center(
                          child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.mainColor),
                      )),
                    if (!isImgUploading) ...[
                      if (logoImgController.text.isNotEmpty)
                        Image.network(logoImgController.text, height: 100.h),
                      if (!logoImgController.text.isEmpty)
                        DottedBorder(
                          color: AppColors.mainColor,
                          dashPattern: const <double>[6, 4],
                          child: GestureDetector(
                            onTap: _pickAndUploadImage,
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
                                  Text("Drop files here", style: t.bodyMedium),
                                  VSpace(10.h),
                                  Text("Or", style: t.bodyMedium),
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
                                          style: t.bodyLarge?.copyWith(
                                              color: AppColors.whiteColor),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                    VSpace(20.h),
                    CustomTextField(
                      bgColor: AppThemes.getDarkBgColor(),
                      controller: tagsController,
                      hintext: "Tags",
                      isSearchIcon: false,
                    ),
                    VSpace(20.h),
                    Container(
                      height: 46.h,
                      decoration: BoxDecoration(
                        color: AppThemes.getDarkBgColor(),
                        borderRadius: Dimensions.kBorderRadius,
                      ),
                      child: AppCustomDropDown(
                        height: 46.h,
                        width: double.infinity,
                        items: categories
                            .map((e) => e["name"])
                            .toSet()
                            .toList(), // Ensure unique values
                        selectedValue: categories
                                .any((e) => e["_id"] == selectedCategoryId)
                            ? categories.firstWhere(
                                (e) => e["_id"] == selectedCategoryId)["name"]
                            : null, // Ensure the selected value exists in items
                        onChanged: (value) {
                          setState(() {
                            selectedCategoryId = categories
                                .firstWhere((e) => e["name"] == value)["_id"];
                            fetchSubCategories(selectedCategoryId!);
                            selectedSubToSubCategoryId = null;
                          });
                        },
                        hint: "Select Category",
                        fontSize: 14.sp,
                        hintStyle: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                    VSpace(20.h),
                    Container(
                      height: 46.h,
                      decoration: BoxDecoration(
                        color: AppThemes.getDarkBgColor(),
                        borderRadius: Dimensions.kBorderRadius,
                      ),
                      child: AppCustomDropDown(
                        height: 46.h,
                        width: double.infinity,
                        items: subcategories
                            .map((e) => e["name"])
                            .toSet()
                            .toList(), // Ensure unique names
                        selectedValue: subcategories
                                .any((e) => e["_id"] == selectedSubCategoryId)
                            ? subcategories.firstWhere((e) =>
                                e["_id"] == selectedSubCategoryId)["name"]
                            : null, // Ensure selectedValue is from the list
                        onChanged: (value) {
                          setState(() {
                            selectedSubCategoryId = subcategories
                                .firstWhere((e) => e["name"] == value)["_id"];
                            fetchSubToSubCategories(selectedSubCategoryId!);
                          });
                        },
                        hint: "Select SubCategory",
                        fontSize: 14.sp,
                        hintStyle: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                    VSpace(20.h),
                    Container(
                      height: 46.h,
                      decoration: BoxDecoration(
                        color: AppThemes.getDarkBgColor(),
                        borderRadius: Dimensions.kBorderRadius,
                      ),
                      child: AppCustomDropDown(
                        height: 46.h,
                        width: double.infinity,
                        items: subToSubcategories
                            .map((e) => e["name"])
                            .toSet()
                            .toList(),
                        selectedValue: subToSubcategories.any(
                                (e) => e["_id"] == selectedSubToSubCategoryId)
                            ? subToSubcategories.firstWhere((e) =>
                                e["_id"] == selectedSubToSubCategoryId)["name"]
                            : null, // Ensure selectedValue is from the list
                        onChanged: (value) {
                          setState(() {
                            selectedSubToSubCategoryId = subToSubcategories
                                .firstWhere((e) => e["name"] == value)["_id"];
                          });
                        },
                        hint: "Select SubToSubCategory",
                        fontSize: 14.sp,
                        hintStyle: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                  ],
                ),
              ),
              VSpace(32.h),
              Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  decoration: BoxDecoration(
                    borderRadius: Dimensions.kBorderRadius,
                    color: AppThemes.getFillColor(),
                  ),
                  child: Column(
                    children: [
                      Text("Contact Info", style: t.bodyLarge),
                      VSpace(12.h),
                      CustomTextField(
                        bgColor: AppThemes.getDarkBgColor(),
                        controller: emailController,
                        hintext: "Email",
                        isSearchIcon: false,
                      ),
                      VSpace(20.h),
                      CustomTextField(
                        bgColor: AppThemes.getDarkBgColor(),
                        controller: phoneController,
                        hintext: "Phone No.",
                        isSearchIcon: false,
                      ),
                      VSpace(20.h),
                      CustomTextField(
                        bgColor: AppThemes.getDarkBgColor(),
                        controller: whatsappController,
                        hintext: "Whatsapp No.",
                        isSearchIcon: false,
                      ),
                      VSpace(20.h),
                      CustomTextField(
                        height: 132.h,
                        contentPadding:
                            EdgeInsets.only(left: 10.w, bottom: 0.h, top: 10.h),
                        alignment: Alignment.topLeft,
                        minLines: 3,
                        maxLines: 3,
                        bgColor: AppThemes.getDarkBgColor(),
                        controller: descriptionController,
                        hintext: "Details",
                        isSearchIcon: false,
                      ),
                    ],
                  )),
              VSpace(32.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                decoration: BoxDecoration(
                  borderRadius: Dimensions.kBorderRadius,
                  color: AppThemes.getFillColor(),
                ),
                child: Column(
                  children: [
                    Text("Social Details", style: t.bodyLarge),
                    VSpace(12.h),
                    CustomTextField(
                      bgColor: AppThemes.getDarkBgColor(),
                      controller: websiteController,
                      hintext: "website",
                      isSearchIcon: false,
                    ),
                    VSpace(20.h),
                    CustomTextField(
                      bgColor: AppThemes.getDarkBgColor(),
                      controller: languageController,
                      hintext: "language",
                      isSearchIcon: false,
                    ),
                    VSpace(20.h),
                    // Here put social media links like facebook instagram
                    CustomTextField(
                      bgColor: AppThemes.getDarkBgColor(),
                      controller: fbController,
                      hintext: "Facebook",
                      isSearchIcon: false,
                    ),
                    VSpace(20.h),
                    CustomTextField(
                      bgColor: AppThemes.getDarkBgColor(),
                      controller: instaController,
                      hintext: "Instagram",
                      isSearchIcon: false,
                    ),
                  ],
                ),
              ),
              VSpace(32.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                decoration: BoxDecoration(
                  borderRadius: Dimensions.kBorderRadius,
                  color: AppThemes.getFillColor(),
                ),
                child: Column(
                  children: [
                    Text("Business Hours",
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.bold)),
                    VSpace(12.h),
                    Column(
                      children: businessHoursControllers.keys.map((day) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(day,
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600)),
                              // Column for open and close times separately
                              Row(
                                children: [
                                  // Open time button
                                  GestureDetector(
                                    onTap: () =>
                                        _selectTime(context, day, 'open'),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.w, vertical: 12.h),
                                      decoration: BoxDecoration(
                                        color: AppColors.mainColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        businessHoursControllers[day]
                                                ?.text
                                                .split(' - ')[0] ??
                                            'Select Open Time',
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            color: AppColors.whiteColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      width: 16
                                          .w), // Space between open and close time buttons
                                  // Close time button
                                  GestureDetector(
                                    onTap: () =>
                                        _selectTime(context, day, 'close'),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.w, vertical: 12.h),
                                      decoration: BoxDecoration(
                                        color: AppColors.mainColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        businessHoursControllers[day]
                                                ?.text
                                                .split(' - ')[1] ??
                                            'Select Close Time',
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            color: AppColors.whiteColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              VSpace(32.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                decoration: BoxDecoration(
                  borderRadius: Dimensions.kBorderRadius,
                  color: AppThemes.getFillColor(),
                ),
                child: Column(
                  children: [
                    Text("Location", style: t.bodyLarge),
                    VSpace(12.h),
                    // Container(
                    //   height: 46.h,
                    //   decoration: BoxDecoration(
                    //     color: AppThemes.getDarkBgColor(),
                    //     borderRadius: Dimensions.kBorderRadius,
                    //   ),
                    //   child: AppCustomDropDown(
                    //     height: 46.h,
                    //     width: double.infinity,
                    //     items: category.map((e) => e).toList(),
                    //     selectedValue: selectedVal,
                    //     onChanged: (value) {
                    //       setState(() {
                    //         selectedVal = value;
                    //       });
                    //     },
                    //     hint: "Select Place",
                    //     fontSize: 14.sp,
                    //     hintStyle: TextStyle(fontSize: 14.sp),
                    //   ),
                    // ),
                    // VSpace(20.h),
                    CustomSearchableDropdown(
                      height: 46.h,
                      width: double.infinity,
                      items: cities, // Your full list of cities
                      selectedValue: selectedCity,
                      onChanged: (value) {
                        setState(() {
                          selectedCity = value;
                        });
                      },
                      hint: "Search & Select City",
                      fontSize: 14.sp,
                      hintStyle: TextStyle(fontSize: 14.sp),
                    ),
                    VSpace(20.h),
                    CustomTextField(
                      bgColor: AppThemes.getDarkBgColor(),
                      controller: locationNameController,
                      hintext: "Address",
                      isSearchIcon: false,
                    ),
                    VSpace(20.h),
                  ],
                ),
              ),
              VSpace(20.h),
              AppButton(
                text: "Submit",
                isLoading: isLoading,
                onTap: () {
                  submitForm();
                },
              ),
              VSpace(40.h),
            ],
          ),
        ),
      ),
    );
  }
}
