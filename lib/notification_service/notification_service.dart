import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:yellowpages/utils/services/localstorage/keys.dart';
import '../utils/services/localstorage/hive.dart';
import 'notification_controller.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('flutter_logo');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
      HiveHelp.write(Keys.isNotificationSeen, true);
      // Get.put(PushNotificationController(notificationRepo: sl())).isSeen.value =
      //     HiveHelp.get(LocalStorage.isNotificationSeen);
      // Get.toNamed(NotificationScreen.routeName);
    }
        // onDidReceiveBackgroundNotificationResponse:
        //         (NotificationResponse notificationResponse) async {
        //   Get.toNamed(AddressVerificationScreen.routeName);
        // }
        );
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetails());
  }
}
