import 'package:flutter/widgets.dart';
import 'package:yellowpages/config/app_colors.dart';

class Styles {

  static const String appFontFamily = 'Nunito';

  static var baseStyle = const TextStyle(
    color: AppColors.blackColor,
    fontSize: 16,
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w400,
  );
  static var largeTitle = const TextStyle(
    color: AppColors.blackColor,
    fontSize: 24,
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w600,
  );
  static var smallTitle = const TextStyle(
    color: AppColors.blackColor,
    fontSize: 22,
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w600,
  );
  static var bodyLarge = const TextStyle(
    color: AppColors.blackColor,
    fontSize: 18,
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w500,
  );
  static var bodyMedium = const TextStyle(
    color: AppColors.blackColor,
    fontSize: 16,
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w500,
  );
  static var bodySmall = const TextStyle(
    color: AppColors.blackColor,
    fontSize: 14,
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w500,
  );
  static var appBarTitle = const TextStyle(
    color: AppColors.blackColor,
    fontSize: 20,
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w600,
  );
  
  
}
