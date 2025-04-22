import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:yellowpages/config/dimensions.dart';
import 'package:yellowpages/controllers/profile_controller.dart';
import 'package:yellowpages/data/models/profile.dart';
import 'package:yellowpages/data/services/ImageUpload.dart';
import 'package:yellowpages/data/services/SharedPreferencesService.dart';
import 'package:yellowpages/themes/themes.dart';
import 'package:yellowpages/utils/services/helpers.dart';
import 'package:yellowpages/views/widgets/app_button.dart';
import 'package:yellowpages/views/widgets/custom_appbar.dart';
import 'package:yellowpages/views/widgets/custom_textfield.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:yellowpages/views/widgets/spacing.dart';
import '../../../config/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../widgets/app_custom_dropdown.dart';
import '../../widgets/custom_painter.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController languageController = TextEditingController();
  final TextEditingController profileController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  bool isLoading = false;

  late final ProfileController _profileController;

  @override
  void initState() {
    super.initState();
    _profileController = Get.find<ProfileController>();

    // Pre-fill values when ProfileController's user data is available
    final user = _profileController.user.value;
    if (user != null) {
      print('User Profile: ${user.profile}');
      firstNameController.text = user.firstname ?? '';
      lastNameController.text = user.lastname ?? '';
      usernameController.text = user.username ?? '';
      postalCodeController.text = user.postalcode ?? '';
      passwordController.text = ''; // Do not pre-fill the password
      profileController.text = user.profile ?? '';
      birthDateController.text = user.birthdate != null
          ? DateFormat('yyyy-MM-dd').format(DateTime.parse(user.birthdate!))
          : '';
      genderController.text = user.zender ?? '';
      languageController.text = user.language ?? '';
    }
  }

  Future<void> _pickAndUploadImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    File imageFile = File(pickedFile.path);
    setState(() => isLoading = true);

    try {
      String? imageUrl = await ImageUploadService.uploadImage(imageFile);
      if (imageUrl != null) {
        setState(() => profileController.text = imageUrl);
        _profileController.user.value?.profile = imageUrl;
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var selectedVal;
    TextTheme t = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? AppColors.darkCardColor
          : AppColors.mainColorWithOpacity,
      appBar: CustomAppBar(
        bgColor: Get.isDarkMode
            ? AppColors.darkCardColor
            : AppColors.mainColorWithOpacity,
        isReverseIconBgColor: true,
        title: "Edit Profile",
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VSpace(10),
            Center(
              child: SizedBox(
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
                          color: AppColors.mainColor.withOpacity(.005),
                          width: 7.h,
                        )),
                    child: GestureDetector(
                      onTap: _pickAndUploadImage,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        clipBehavior: Clip.none,
                        children: [
                          if (isLoading)
                            Positioned.fill(
                              child: Center(
                                child: Helpers.appLoader(
                                    color: AppColors.mainColor),
                              ),
                            ),
                          if (!isLoading)
                            ClipOval(
                              child: profileController.text.isEmpty
                                  ? Image.asset(
                                      "$rootImageDir/profile_pic.webp",
                                      fit: BoxFit.cover,
                                      width: 120.h,
                                      height: 120.h)
                                  : Image.network(profileController.text,
                                      fit: BoxFit.cover,
                                      width: 120.h,
                                      height: 120.h),
                            ),
                          Positioned(
                            bottom: -8.h,
                            right: -8.w,
                            child: Container(
                              padding: EdgeInsets.all(8.h),
                              decoration: BoxDecoration(
                                  color: AppColors.mainColor,
                                  shape: BoxShape.circle),
                              child: Icon(Icons.camera_alt,
                                  color: AppColors.whiteColor, size: 20.h),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            VSpace(24.h),
            Container(
              height: Dimensions.screenHeight + 40,
              width: double.maxFinite,
              padding: Dimensions.kDefaultPadding,
              decoration: BoxDecoration(
                color: AppThemes.getDarkBgColor(),
                borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("First Name", style: t.displayMedium),
                  VSpace(10.h),
                  CustomTextField(
                    height: 50.h,
                    hintext: "Enter First Name",
                    controller: firstNameController,
                    bgColor: Get.isDarkMode
                        ? AppColors.darkCardColor
                        : AppColors.mainColorWithOpacity,
                  ),
                  VSpace(24.h),
                  Text("Last Name", style: t.displayMedium),
                  VSpace(10.h),
                  CustomTextField(
                    height: 50.h,
                    hintext: "Enter Last Name",
                    controller: lastNameController,
                    bgColor: Get.isDarkMode
                        ? AppColors.darkCardColor
                        : AppColors.mainColorWithOpacity,
                  ),
                  VSpace(24.h),
                  Text("User Name", style: t.displayMedium),
                  VSpace(10.h),
                  CustomTextField(
                    height: 50.h,
                    hintext: "Enter User Name",
                    controller: usernameController,
                    bgColor: Get.isDarkMode
                        ? AppColors.darkCardColor
                        : AppColors.mainColorWithOpacity,
                  ),
                  VSpace(24.h),
                  Text("Postal Code", style: t.displayMedium),
                  VSpace(10.h),
                  CustomTextField(
                    height: 50.h,
                    hintext: "Enter Postal Code",
                    controller: postalCodeController,
                    bgColor: Get.isDarkMode
                        ? AppColors.darkCardColor
                        : AppColors.mainColorWithOpacity,
                  ),
                  VSpace(24.h),
                  Text("Birth Date", style: t.displayMedium),
                  VSpace(10.h),
                  GestureDetector(
                    onTap: () async {
                      // Open the date picker when user taps on the text
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900), // Minimum date
                        lastDate: DateTime.now(), // Maximum date (current date)
                      );

                      if (pickedDate != null) {
                        // Format the picked date to display only the date (no time)
                        setState(() {
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          birthDateController.text =
                              formattedDate; // Set the controller text to the formatted date
                        });
                      }
                    },
                    child: Container(
                      height: 50.h,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? AppColors.darkCardColor
                            : AppColors.mainColorWithOpacity,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            birthDateController.text.isEmpty
                                ? "Enter Birth Date"
                                : birthDateController.text,
                          ),
                          Icon(
                            Icons.calendar_today,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  VSpace(24.h),
                  Text("Gender", style: t.displayMedium),
                  VSpace(10.h),
                  CustomTextField(
                    height: 50.h,
                    hintext: "Enter Gender",
                    controller: genderController,
                    bgColor: Get.isDarkMode
                        ? AppColors.darkCardColor
                        : AppColors.mainColorWithOpacity,
                  ),
                  VSpace(24.h),
                  Text("Language", style: t.displayMedium),
                  VSpace(10.h),
                  CustomTextField(
                    height: 50.h,
                    hintext: "Enter Preferred Language",
                    controller: languageController,
                    bgColor: Get.isDarkMode
                        ? AppColors.darkCardColor
                        : AppColors.mainColorWithOpacity,
                  ),
                  VSpace(24.h),
                  InkWell(
                    onTap: isLoading ? null : _updateProfile,
                    borderRadius: Dimensions.kBorderRadius,
                    child: Container(
                      width: double.maxFinite,
                      height: Dimensions.buttonHeight,
                      decoration: BoxDecoration(
                        color: AppColors.mainColor,
                        borderRadius: Dimensions.kBorderRadius,
                      ),
                      child: Center(
                        child: isLoading
                            ? Helpers.appLoader(color: AppColors.whiteColor)
                            : Text(
                                "Update Profile",
                                style: t.bodyLarge
                                    ?.copyWith(color: AppColors.whiteColor),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateProfile() async {
    setState(() => isLoading = true);
    print(profileController.text);
    final updatedUser = User(
      firstname: firstNameController.text,
      lastname: lastNameController.text,
      postalcode: postalCodeController.text,
      birthdate: birthDateController.text,
      zender: genderController.text,
      username: usernameController.text,
      language: languageController.text,
      profile: profileController.text,
    );

    try {
      final token = await SharedPreferencesService.getAccessToken();
      final response = await http.put(
        Uri.parse('${AppConstants.baseUri}/user'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(updatedUser.toJson()),
      );
      final responseJson = json.decode(response.body);
      if (response.statusCode == 200) {
        _profileController.fetchUserData();
        Get.snackbar("Success", "Profile updated successfully");
      } else {
        Get.snackbar("Error", responseJson['message']);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    } finally {
      setState(() => isLoading = false);
    }
  }
}
