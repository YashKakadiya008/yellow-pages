import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yellowpages/controllers/auth_controller.dart';
import 'package:yellowpages/controllers/bindings/bindings.dart';
import 'package:yellowpages/data/services/SharedPreferencesService.dart';
import 'package:yellowpages/routes/routes_helper.dart';
import 'package:yellowpages/routes/routes_name.dart';
import 'package:yellowpages/themes/themes.dart';
import 'controllers/app_controller.dart';
import 'utils/app_constants.dart';
import 'utils/services/localstorage/init_hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isLoggedIn = await SharedPreferencesService.getLoginStatus();
  // Initialize GetX and set isLoggedIn in AuthController
  Get.put(AuthController()).updateLoginStatus(isLoggedIn);

  await initHive();
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
        designSize: const Size(430, 892),
        minTextAdapt: true,
        splitScreenMode: true,
        useInheritedMediaQuery: true,
        builder: (context, child) {
          return GetMaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            scaffoldMessengerKey: scaffoldMessengerKey,
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            initialBinding: InitBindings(),
            themeMode: Get.put(AppController()).themeManager(),
            initialRoute: RoutesName.initial,
            getPages: RouteHelper.routes(),
          );
        });
  }
}
