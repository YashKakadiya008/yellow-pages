import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yellowpages/utils/services/localstorage/hive.dart';
import 'package:yellowpages/utils/services/localstorage/keys.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'notification_service.dart';

class PushNotificationController extends GetxController {

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  dynamic res;
  RxBool isSeen = true.obs;
  // Future<dynamic> getPushNotificationConfig() async {
  //   _isLoading = true;
  //   update();
  //   ApiResponse apiResponse = await notificationRepo.getNotificationConfig();

  //   if (apiResponse.response != null &&
  //       apiResponse.response!.statusCode == 200) {
  //     _isLoading = false;
  //     res = apiResponse.response!.data;
  //     update();
  //     if (res != null) {
  //       LocalStorage.write(LocalStorage.channelName, res['data']['channel']);
  //       PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  //       try {
  //         await pusher.init(
  //           apiKey: res['data']['apiKey'],
  //           cluster: res['data']['cluster'],
  //           onConnectionStateChange: onConnectionStateChange,
  //           onSubscriptionSucceeded: onSubscriptionSucceeded,
  //           onEvent: onEvent,
  //           onSubscriptionError: onSubscriptionError,
  //           onMemberAdded: onMemberAdded,
  //           onMemberRemoved: onMemberRemoved,
  //         );
  //         await pusher.subscribe(channelName: res['data']['channel']);
  //         await pusher.connect();
  //       } catch (e) {
  //         print("ERROR: $e");
  //       }

  //       update();
  //     }
  //   } else {
  //     _isLoading = false;
  //     update();
  //   }
  // }

  void onEvent(PusherEvent event) async {
    if (kDebugMode) {
      print("onEvent: ${event.data}");
    }
    // Parse the JSON response
    Map<String, dynamic> eventData = json.decode(event.data);
    Map<String, dynamic> message = eventData['message'];
    String text = message['description']['text'];
    String formattedDate = DateFormat.yMMMMd().add_jm().format(DateTime.now());

    // Show the response in the flutter_local_notification
    NotificationService().showNotification(
      id: Random().nextInt(99),
      title: text,
      body: formattedDate,
    );

    var storedData = await HiveHelp.read(res['data']['channel']);
    List<Map<String, dynamic>> notificationList =
        storedData != null ? List<Map<String, dynamic>>.from(storedData) : [];
    notificationList.add({
      'text': text.trim(),
      'date': formattedDate,
    });

    HiveHelp.write(res['data']['channel'], notificationList);
    HiveHelp.write(Keys.isNotificationSeen, false);
    isSeen.value = HiveHelp.read(Keys.isNotificationSeen);

    update();
  }

  void onSubscriptionSucceeded(String channelName, dynamic data) {
    debugPrint("onSubscriptionSucceeded: $channelName data: ${data}");
  }

  void onSubscriptionError(String message, dynamic e) {
    debugPrint("onSubscriptionError: $message Exception: $e");
  }

  void onMemberAdded(String channelName, PusherMember member) {
    debugPrint("onMemberAdded: $channelName member: $member");
  }

  void onMemberRemoved(String channelName, PusherMember member) {
    debugPrint("onMemberRemoved: $channelName member: $member");
  }

  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    debugPrint("Connection: $currentState");
  }

  clearList() {
    var channelName = HiveHelp.read(Keys.channelName);
    HiveHelp.remove(channelName);
    update();
  }

  isNotiSeen() {
    HiveHelp.write(Keys.isNotificationSeen, true);
    isSeen.value = HiveHelp.read(Keys.isNotificationSeen);
    // Get.toNamed(NotificationScreen.routeName);
    update();
  }
}
