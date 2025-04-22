import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yellowpages/utils/services/localstorage/hive.dart';
import 'package:yellowpages/utils/services/localstorage/keys.dart';
import 'package:lottie/lottie.dart';

class AppController extends GetxController {
  static AppController get to => Get.find<AppController>();

  
  //-------------- check internet connectivity-----------
  void updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      Get.dialog(
        const CustomDialog(),
        barrierDismissible:
            false, // Prevent the user from closing the dialog by tapping outside
      );
    } else {
      // Dismiss the dialog if it's currently displayed
      if (Get.isDialogOpen == true) {
        Get.back();
      }
    }
  }

  //-------------------Handle app theme----------------
  isDarkMode() {
    return HiveHelp.read(Keys.isDark) ?? false;
  }

  onChanged(val) {
    HiveHelp.write(Keys.isDark, val);
    updateTheme();
  }

  ThemeMode themeManager() {
    return HiveHelp.read(Keys.isDark) != null
        ? HiveHelp.read(Keys.isDark) == true
            ? ThemeMode.dark
            : ThemeMode.light
        : ThemeMode.system;
  }

  void updateTheme() {
    Get.changeThemeMode(themeManager());
    isDarkMode();
    update();
  }

//--------------------listen phone sms-----------
  // String _message = "";
  // String get message => _message;
  // final telephony = Telephony.instance;

  // onMessage(SmsMessage message) async {
  //   _message = message.body ?? "Error reading message body.";
  //   print(message.address); //+977981******67, sender nubmer
  //   print(message.body); //sms text
  //   print(message.date); //1659690242000, timestamp
  //   if (kDebugMode) {
  //     print(
  //         "This is from onMessage function: =======================$_message");
  //   }
  //   update();
  // }

  // onSendStatus(SendStatus status) {
  //   _message = status == SendStatus.SENT ? "sent" : "delivered";
  //   update();
  // }

  // // Platform messages are asynchronous, so we initialize in an async method.
  // Future<void> initPlatformState() async {
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.

  //   try {
  //     final bool? result = await telephony.requestPhoneAndSmsPermissions;

  //     if (result != null && result) {
  //       telephony.listenIncomingSms(
  //           onNewMessage: onMessage, onBackgroundMessage: onBackgroundMessage);
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }
}

class CustomDialog extends StatelessWidget {
  const CustomDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AlertDialog(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/json/no_internet.json', // Replace with your image path
              height: 150.h,
              width: 150.w,
            ),
            Text(
              'No Internet!!! Please check your connection.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
