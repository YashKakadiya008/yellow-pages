import 'package:get/get.dart';
import 'package:yellowpages/controllers/app_controller.dart';
import 'package:yellowpages/controllers/auth_controller.dart';

import '../../notification_service/notification_controller.dart';
import '../profile_controller.dart';

class InitBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(AppController());
    Get.put(PushNotificationController());
    Get.lazyPut<AuthController>(() => AuthController(),fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(),fenix: true);
  }
}
