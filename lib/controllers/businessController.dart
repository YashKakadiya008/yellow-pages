import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:yellowpages/data/models/myBusiness.dart';
import 'package:yellowpages/data/services/SharedPreferencesService.dart';
import 'package:yellowpages/utils/app_constants.dart';

class BusinessController extends GetxController {
  RxList<Business> businesses = <Business>[].obs;
  List<Business> recentBusinesses = [];
  RxList<Chat> chats = <Chat>[].obs; // Store chats here
  RxBool isLoading = false.obs;
  RxList<String> imageUrls = <String>[].obs;

  @override
  void onInit() {
    fetchMyBusiness(); // Fetch businesses when the controller is initialized
    fetchMyChats(); // Fetch chats when the controller is initialized
    fetchBanners();
    loadRecentBusinesses();
    super.onInit();
  }

  Future<void> addBusinessToRecent(Map<String, dynamic> businessDetails) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Business newBusiness = Business.fromJson(businessDetails);

    // Load the existing list
    List<String> storedBusinesses =
        prefs.getStringList('recent_businesses') ?? [];

    // Decode JSON and create Business objects
    List<Business> businesses = storedBusinesses
        .map((item) => Business.fromJson(jsonDecode(item)))
        .toList();

    // Remove if already exists
    businesses.removeWhere((b) => b.id == newBusiness.id);

    // Ensure only 4 businesses are stored
    if (businesses.length >= 4) {
      businesses.removeAt(0);
    }

    // Add the new business
    businesses.add(newBusiness);

    // Save the updated list
    List<String> jsonBusinesses =
        businesses.map((b) => jsonEncode(b.toJson())).toList();
    await prefs.setStringList('recent_businesses', jsonBusinesses);

    // Update local list
    recentBusinesses = businesses;
  }

  Future<void> loadRecentBusinesses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedBusinesses =
        prefs.getStringList('recent_businesses') ?? [];

    // Decode and store in the list
    recentBusinesses = storedBusinesses
        .map((item) => Business.fromJson(jsonDecode(item)))
        .toList();
  }

  Future<void> fetchBanners() async {
    isLoading.value = true;
    final url = "${AppConstants.baseUri}/banner";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> bannersArray = data['banners'];
        imageUrls.value =
            bannersArray.map((banner) => banner['image'].toString()).toList();
      } else {
        throw Exception('Failed to load banners');
      }
    } catch (error) {
      print('Error fetching banners: $error');
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch businesses from API
  Future<void> fetchMyBusiness() async {
    isLoading.value = true;
    final url = "${AppConstants.baseUri}/business/user";
    final token = await SharedPreferencesService.getAccessToken();
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> businessesArray = data['businesses'];
        businesses.value = businessesArray
            .map((businessJson) => Business.fromJson(businessJson))
            .toList();
      } else {
        throw Exception('Failed to load businesses');
      }
    } catch (error) {
      print('Error fetching businesses: $error');
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch chats from API and map to Chat model
  Future<void> fetchMyChats() async {
    isLoading.value = true;
    final url = "${AppConstants.baseUri}/chats";
    final token = await SharedPreferencesService.getAccessToken();
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Here is my chats");
        print(data['data']['chats']);
        List<dynamic> chatsArray = data['data']['chats'];
        chats.value = chatsArray
            .map((chatJson) => Chat.fromJson(chatJson)) // Using Chat model
            .toList();
      } else {
        throw Exception('Failed to load chats');
      }
    } catch (error) {
      print('Error fetching chats: $error');
    } finally {
      isLoading.value = false;
    }
  }

  // Update business in the list
  Future<void> updateBusiness(
      String businessId, Business updatedBusiness) async {
    isLoading.value = true;

    // Update the business in the local list
    final index =
        businesses.indexWhere((business) => business.id == businessId);
    if (index != -1) {
      businesses[index] = updatedBusiness;
    }

    isLoading.value = false;
  }
}
