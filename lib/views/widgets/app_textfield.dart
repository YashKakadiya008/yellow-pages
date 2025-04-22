import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yellowpages/themes/themes.dart';
import '../../config/app_colors.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool autofocus;
  final bool obscureText;
  final String? hinText;
  final String? labelText;
  final FocusNode? focusNode;

  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign? textAlign;
  final Function(String)? onChanged;
  final MaxLengthEnforcement maxLengthEnforcement;
  final EdgeInsetsGeometry? contentPadding;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final int? minLines;
  final int? maxLines;

  const AppTextField({
    super.key,
    required this.controller,
    this.autofocus = false,
    this.obscureText = false,
    this.focusNode,
    this.hinText,
    this.labelText,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.textAlign,
    this.onChanged,
    this.maxLengthEnforcement = MaxLengthEnforcement.enforced,
    this.contentPadding,
    this.validator,
    this.prefixIcon,
    this.minLines,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return TextFormField(
      focusNode: focusNode,
      // onTapOutside: (v) {
      //   Helpers.hideKeyboard();
      // },
      controller: controller,
      autofocus: autofocus,
      minLines: minLines ?? 1,
      maxLines: maxLines ?? 1,
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
      inputFormatters: inputFormatters,
      maxLengthEnforcement: maxLengthEnforcement,
      style: t.displayMedium,
      keyboardType: keyboardType,
      textAlign: textAlign ?? TextAlign.start,
      cursorColor: AppColors.mainColor,
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixIcon: prefixIcon,
        prefixIconConstraints: BoxConstraints(
          minWidth: 18.h,
          minHeight: 18.h,
        ),
        labelText: labelText,
        labelStyle: t.displayMedium?.copyWith(color: AppThemes.getGreyColor()),
        isDense: true,
        contentPadding:
            contentPadding ?? EdgeInsets.only(left: 10.w, bottom: 0),
        filled: true,
        fillColor: Colors.transparent,
        hintText: hinText ?? "",
        hintStyle: t.displayMedium?.copyWith(color: AppColors.greyColor),
      ),
    );
  }
}
