// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get_connect/http/src/exceptions/exceptions.dart';
import 'package:yellowpages/utils/services/localstorage/hive.dart';

import '../../utils/app_constants.dart';
import '../../utils/services/helpers.dart';
import '../../utils/services/localstorage/keys.dart';

class ApiClient {
  static const String _BASE_URL = AppConstants.baseUrl;
  static const int _TIME_OUT_DURATION = 60;
  static final String _token = HiveHelp.read(Keys.token);

  static Future<Response?> get({required String ENDPOINT_URL}) async {
    Dio dio = Dio();
    Response? response;
    try {
      response = await dio
          .get(
            _BASE_URL + ENDPOINT_URL,
            options: Options(
              headers: {
                'Authorization': 'Bearer $_token',
                'Content-Type': 'application/json',
              },
            ),
          )
          .timeout(const Duration(seconds: _TIME_OUT_DURATION));
      return response;
    } on DioError catch (e) {
      if (e.response!.statusCode == 500) {
        Helpers.showSnackBar(msg: e.response!.data);
      } else if (e.response!.statusCode == 404) {
        Helpers.showSnackBar(msg: e.response!.data);
      } else if (e.response!.statusCode == 422) {
        Helpers.showSnackBar(msg: e.response!.data);
      } else {
        Helpers.showSnackBar(msg: e.response!.data);
      }
    } on TimeoutException {
      Helpers.showSnackBar(msg: "Time out");
    } on UnauthorizedException {
      Helpers.showSnackBar(msg: "Unauthorized request");
    } on SocketException {
      Helpers.showSnackBar(msg: "No Internet connection");
    }
    return response;
  }

  static Future<Response?> post({
    required String ENDPOINT_URL,
    required Object? data,
    Function(int, int)? onSendProgress,
    Function(int, int)? onReceiveProgress,
  }) async {
    Dio dio = Dio();
    Response? response;
    try {
      Response response = await dio
          .post(
            _BASE_URL + ENDPOINT_URL,
            data: data,
            options: Options(
              headers: {
                'Authorization': 'Bearer $_token',
                'Content-Type': 'application/json',
              },
            ),
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
          )
          .timeout(const Duration(seconds: _TIME_OUT_DURATION));

      return response;
    } on DioError catch (e) {
      if (e.response!.statusCode == 500) {
        Helpers.showSnackBar(msg: e.response!.data);
      }
      if (e.response!.statusCode == 404) {
        Helpers.showSnackBar(msg: e.response!.data);
      } else if (e.response!.statusCode == 422) {
        Helpers.showSnackBar(msg: e.response!.data);
      } else {
        Helpers.showSnackBar(msg: e.response!.data);
      }
    } on TimeoutException {
      Helpers.showSnackBar(msg: "Time out");
    } on UnauthorizedException {
      Helpers.showSnackBar(msg: "Unauthorized request");
    } on SocketException {
      Helpers.showSnackBar(msg: "No internet connection");
    }
    return response;
  }

  Future update() async {
    Dio dio = Dio();
    try {
      Response response = await dio.put(
        'https://your-api-url.com/your-endpoint',
        data: {},
        options: Options(
          headers: {
            'Authorization': 'Bearer your_token_here',
            'Content-Type': 'application/json'
          },
        ),
      );

      // handle the response data
    } on DioError catch (e) {
      // handle the DioException
      print(e.response?.statusCode);
      print(e.message);
    }
  }

  Future delete() async {
    Dio dio = Dio();
    try {
      var response = await dio.delete(
        'https://your-api-url.com/your-endpoint',
        options: Options(
          headers: {
            'Authorization': 'Bearer your_token_here',
            'Content-Type': 'application/json'
          },
          responseType: ResponseType.stream,
        ),
      );

      // handle the response data
      // String data = await response.stream.transform(utf8.decoder).join();
      // print(data);
      return response;
    } on DioError catch (e) {
      Helpers.showSnackBar(msg: e.response!.data);
    }
  }
}
