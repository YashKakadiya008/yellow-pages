import 'package:flutter/material.dart';
import 'package:yellowpages/utils/services/helpers.dart';
import '../../config/app_colors.dart';
import '../../config/dimensions.dart';

class AppButton extends StatelessWidget {
  final void Function()? onTap;
  final String? text;
  final TextStyle? style;
  final double? buttonWidth;
  final double? buttonHeight;
  final Color? bgColor;
  final BorderRadius? borderRadius;
  final bool? isLoading;

  const AppButton(
      {super.key,
      this.onTap,
      this.text,
      this.style,
      this.buttonWidth,
      this.buttonHeight,
      this.bgColor,
      this.isLoading = false,
      this.borderRadius});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius ?? Dimensions.kBorderRadius,
      child: Ink(
        width: buttonWidth ?? double.maxFinite,
        height: buttonHeight ?? Dimensions.buttonHeight,
        decoration: BoxDecoration(
          color: bgColor ?? AppColors.mainColor,
          borderRadius: borderRadius ?? Dimensions.kBorderRadius,
        ),
        child: Center(
          child: isLoading == true
              ? Helpers.appLoader(color: AppColors.whiteColor)
              : Text(
                  text ?? "Continue",
                  style: style ??
                      t.bodyLarge?.copyWith(color: AppColors.whiteColor),
                ),
        ),
      ),
    );
  }
}
