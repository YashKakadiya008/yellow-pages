import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yellowpages/config/dimensions.dart';
import 'package:yellowpages/controllers/businessController.dart';
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
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // For formatting time

import '../../../config/app_colors.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_custom_dropdown.dart';
import '../../widgets/custom_textfield.dart';

class AddListingScreen extends StatefulWidget {
  const AddListingScreen({super.key});

  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  int selectedIndex = 0;
  dynamic selectedVal;

  // Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController tagsController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController whatsappController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController languageController = TextEditingController();
  TextEditingController fbController = TextEditingController();
  TextEditingController instaController = TextEditingController();
  TextEditingController latController = TextEditingController();
  TextEditingController lngController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationNameController = TextEditingController();
  TextEditingController logoImgController = TextEditingController();
  GoogleMapController? _mapController;
  List<String> cities = []; // Store fetched cities here
  String? selectedCity; // Store selected city
  List<String> filteredCities = []; // For search filtering

  final ImagePicker _picker = ImagePicker();
  // Loading
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

  Map<String, Map<String, String?>> businessHours = {
    'Sunday': {'open': '09:00', 'close': '17:00'},
    'Monday': {'open': '09:00', 'close': '18:00'},
    'Tuesday': {'open': '09:00', 'close': '18:00'},
    'Wednesday': {'open': '09:00', 'close': '18:00'},
    'Thursday': {'open': '09:00', 'close': '18:00'},
    'Friday': {'open': '09:00', 'close': '18:00'},
    'Saturday': {'open': '09:00', 'close': '18:00'},
  };

  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> subcategories = [];
  List<Map<String, dynamic>> subToSubcategories = [];

  String? selectedCategoryId;
  String? selectedSubCategoryId;
  String? selectedSubToSubCategoryId;

  final FocusNode cityFocusNode = FocusNode();
  final FocusNode addressFocusNode = FocusNode();
  bool isKeyboardVisible = false;
  final ScrollController _scrollController = ScrollController();

  LatLng selectedLatLng = LatLng(23.872413317988265, 90.40044151202481);

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchCities();
    cityFocusNode.addListener(_onFocusChange);
    addressFocusNode.addListener(_onFocusChange);
  }

  // Time picker for opening and closing times
  Future<void> _selectTime(
      BuildContext context, String day, String type) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        DateFormat('HH:mm').parse(businessHours[day]?[type] ?? '09:00'),
      ),
    );

    if (picked != null) {
      String formattedTime = picked.format(context);
      setState(() {
        businessHours[day]?[type] = formattedTime;
      });
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
      "userId": "6796202a61e0bfd87cb22f34",
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
      "socialMedia": {
        "instagram": instaController.text,
        "facebook": fbController.text
      },
      "city": selectedCity,
      "businessHours": businessHours,
    });

    try {
      final token = await SharedPreferencesService.getAccessToken();
      final response = await http.post(
        Uri.parse('${AppConstants.baseUri}/business'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + token!
        },
        body: body,
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 201) {
        Get.snackbar("Success",
            responseData['message'] ?? "Business added successfully");

        Get.find<BusinessController>().fetchMyBusiness();
        // Clear all the controllers
        nameController.clear();
        tagsController.clear();
        emailController.clear();
        phoneController.clear();
        whatsappController.clear();
        websiteController.clear();
        languageController.clear();

        fbController.clear();
        instaController.clear();
        latController.clear();
        lngController.clear();
        descriptionController.clear();
        locationNameController.clear();
      } else {
        Get.snackbar(
            "Error", responseData['message'] ?? "Failed to add business");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _onFocusChange() {
    setState(() {
      isKeyboardVisible = cityFocusNode.hasFocus || addressFocusNode.hasFocus;
    });
    if (addressFocusNode.hasFocus) {
      Future.delayed(Duration(milliseconds: 300), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  void dispose() {
    cityFocusNode.removeListener(_onFocusChange);
    addressFocusNode.removeListener(_onFocusChange);
    cityFocusNode.dispose();
    addressFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
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
    return WillPopScope(
      onWillPop: () async {
        if (isKeyboardVisible) {
          FocusScope.of(context).unfocus();
          setState(() {
            isKeyboardVisible = false;
          });
          return false; // Prevent default back button behavior
        }
        return true; // Allow normal back button behavior
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true, // Make sure this is true
        appBar: CustomAppBar(
          isTitleMarginTop: true,
          toolberHeight: 100.h,
          prefferSized: 100.h,
          title: "Add Listing",
          leading: const SizedBox(),
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: Dimensions.kDefaultPadding,
            child: Column(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
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
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.mainColor),
                        )),
                      if (!(isImgUploading)) ...[
                        if (logoImgController.text.isNotEmpty)
                          Image.network(logoImgController.text, height: 100.h),
                        if (!(logoImgController.text.isNotEmpty))
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
                                    Text("Drop files here",
                                        style: t.bodyMedium),
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
                                          borderRadius:
                                              Dimensions.kBorderRadius,
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
                          items:
                              categories.map((e) => e["name"]).toSet().toList(),
                          selectedValue: categories
                                  .any((e) => e["_id"] == selectedCategoryId)
                              ? categories.firstWhere(
                                  (e) => e["_id"] == selectedCategoryId)["name"]
                              : null,
                          onChanged: (value) {
                            setState(() {
                              selectedCategoryId = categories
                                  .firstWhere((e) => e["name"] == value)["_id"];
                              fetchSubCategories(selectedCategoryId!);
                              selectedSubCategoryId = null;
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
                              .toList(),
                          selectedValue: subcategories
                                  .any((e) => e["_id"] == selectedSubCategoryId)
                              ? subcategories.firstWhere((e) =>
                                  e["_id"] == selectedSubCategoryId)["name"]
                              : null,
                          onChanged: (value) {
                            setState(() {
                              selectedSubCategoryId = subcategories
                                  .firstWhere((e) => e["name"] == value)["_id"];
                              fetchSubToSubCategories(selectedSubCategoryId!);
                              selectedSubToSubCategoryId = null;
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
                                  e["_id"] ==
                                  selectedSubToSubCategoryId)["name"]
                              : null,
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
                          contentPadding: EdgeInsets.only(
                              left: 10.w, bottom: 0.h, top: 10.h),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  decoration: BoxDecoration(
                    borderRadius: Dimensions.kBorderRadius,
                    color: AppThemes.getFillColor(),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Business Hours",
                      ),
                      VSpace(12.h),
                      Column(
                        children: [
                          ...businessHours.keys.map((day) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 16.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    day,
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () =>
                                            _selectTime(context, day, 'open'),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.w, vertical: 12.h),
                                          decoration: BoxDecoration(
                                            color: AppColors.mainColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            businessHours[day]?['open'] ??
                                                'Select Open Time',
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                color: AppColors.whiteColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 16.w),
                                      GestureDetector(
                                        onTap: () =>
                                            _selectTime(context, day, 'close'),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.w, vertical: 12.h),
                                          decoration: BoxDecoration(
                                            color: AppColors.mainColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            businessHours[day]?['close'] ??
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
                        ],
                      ),
                      VSpace(12.h),
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
                      Text("Location", style: t.bodyLarge),
                      VSpace(12.h),
                      CustomTextField(
                        focusNode: addressFocusNode,
                        bgColor: AppThemes.getDarkBgColor(),
                        controller: locationNameController,
                        hintext: "Address",
                        isSearchIcon: false,
                      ),
                      VSpace(20.h),

                      Focus(
                        focusNode: cityFocusNode,
                        child: CustomSearchableDropdown(
                          height: 46.h,
                          width: double.infinity,
                          items: cities,
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
                VSpace(isKeyboardVisible ? 300.h : 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final List<String> category = [
    "Basic Info",
    "Video",
    "Photos",
    "Amenities",
    "Products",
  ];
}
