import 'package:dio/dio.dart' as dioo;
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:yellowpages/utils/app_constants.dart';

class ApiHelper {
  static const String _baseUrl = AppConstants.baseUrl;

  // Timeout duration
  static const int _timeoutDuration = 60;

  // Create an instance of Dio
  dioo.Dio dio = dioo.Dio();

  // Function to send POST request for registration
  Future<Map<String, dynamic>?> registerUser({
    required String email,
    required String password,
  }) async {
    try {
      // Prepare the data to send in the body
      Map<String, dynamic> data = {
        'email': email,
        'password': password,
      };

      // Send POST request to the register endpoint
      dioo.Response response = await dio
          .post(
            _baseUrl + AppConstants.registerUri,
            data: data,
            options: dioo.Options(
              headers: {
                'Content-Type': 'application/json', // Set Content-Type to JSON
              },
            ),
          )
          .timeout(Duration(seconds: _timeoutDuration));
      print("Response: ${response.data}");

      // Check if the response is successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Return the response data as a Map
        return response.data; // This is the JSON response
      } else {
        // Handle error: Show error message in Snackbar
        String errorMessage = "Something went wrong. Please try again.";
        if (response.data != null && response.data['message'] != null) {
          errorMessage = response.data['message'];
        }
        // Show the error in snackbar
        Get.snackbar('Sign Up Failed', errorMessage,
            snackPosition: SnackPosition.BOTTOM);
        return null;
      }
    } on dioo.DioError catch (e) {
      // Handle Dio errors
      String errorMessage = "An error occurred. Please try again.";
      if (e.response != null) {
        print("DioError Response: ${e.response?.data}");
        if (e.response?.data['message'] != null) {
          errorMessage = e
              .response?.data['message']; // Extract error message from response
        }
      } else {
        print("DioError: ${e.message}");
        errorMessage = e.message;
      }

      // Show the error in snackbar
      Get.snackbar('Sign Up Failed', errorMessage,
          snackPosition: SnackPosition.BOTTOM);

      return null;
    } catch (e) {
      // Catch any other errors
      print("Error: $e");

      // Show a generic error message
      Get.snackbar(
          'Sign Up Failed', "An unexpected error occurred. Please try again.",
          snackPosition: SnackPosition.BOTTOM);

      return null;
    }
  }


  // Function to send POST request for login
  Future<Map<String, dynamic>?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      // Prepare the data to send in the body
      Map<String, dynamic> data = {
        'email': email,
        'password': password,
      };

      // Send POST request to the login endpoint
      dioo.Response response = await dio
          .post(
            _baseUrl + AppConstants.loginUri,
            data: data,
            options: dioo.Options(
              headers: {
                'Content-Type': 'application/json', // Set Content-Type to JSON
              },
            ),
          )
          .timeout(Duration(seconds: _timeoutDuration));
      print("Response: ${response.data}");

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Return the response data as a Map
        return response.data; // This is the JSON response
      } else {
        // Handle error: Show error message in Snackbar
        String errorMessage = "Something went wrong. Please try again.";
        if (response.data != null && response.data['message'] != null) {
          errorMessage = response.data['message'];
        }
        // Show the error in snackbar
        Get.snackbar('Sign In Failed', errorMessage,
            snackPosition: SnackPosition.BOTTOM);
        return null;
      }
    } on dioo.DioError catch (e) {
      // Handle Dio errors
      String errorMessage = "An error occurred. Please try again.";
      if (e.response != null) {
        print("DioError Response: ${e.response?.data}");
        if (e.response?.data['message'] != null) {
          errorMessage = e
              .response?.data['message']; // Extract error message from response
        }
      } else {
        print("DioError: ${e.message}");
        errorMessage = e.message;
      }

      // Show the error in snackbar
      Get.snackbar('Sign In Failed', errorMessage,
          snackPosition: SnackPosition.BOTTOM);

      return null;
    } catch (e) {
      // Catch any other errors
      print("Error: $e");

      // Show a generic error message
      Get.snackbar(
          'Sign In Failed', "An unexpected error occurred. Please try again.",
          snackPosition: SnackPosition.BOTTOM);

      return null;
    }
  }
}
