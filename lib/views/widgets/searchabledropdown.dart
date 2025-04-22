import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../config/app_colors.dart';
import '../../config/styles.dart';
import '../../config/dimensions.dart';
import '../../themes/themes.dart';

class CustomSearchableDropdown extends StatefulWidget {
  final List<String> items;
  final String? selectedValue;
  final Function(String) onChanged;
  final String hint;
  final double? height;
  final double? width;
  final double? fontSize;
  final TextStyle? hintStyle;
  final Color? bgColor;
  final TextStyle? selectedStyle;
  final bool isSearchable;

  const CustomSearchableDropdown({
    Key? key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    required this.hint,
    this.height,
    this.width,
    this.fontSize,
    this.hintStyle,
    this.bgColor,
    this.selectedStyle,
    this.isSearchable = true,
  }) : super(key: key);

  @override
  State<CustomSearchableDropdown> createState() => _CustomSearchableDropdownState();
}

class _CustomSearchableDropdownState extends State<CustomSearchableDropdown> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  bool _isDropdownOpen = false;
  List<String> _filteredItems = [];
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showOverlay();
      } else {
        _hideOverlay();
      }
    });

    if (widget.selectedValue != null) {
      _searchController.text = widget.selectedValue!;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _hideOverlay();
    super.dispose();
  }

  void _showOverlay() {
    _isDropdownOpen = true;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _isDropdownOpen = false;
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _filterItems(String query) {
    setState(() {
      _filteredItems = widget.items
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });

    _overlayEntry?.markNeedsBuild();
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5),
          child: Material(
            elevation: 2,
            borderRadius: Dimensions.kBorderRadius,
            child: Container(
              decoration: BoxDecoration(
                color: widget.bgColor ?? AppThemes.getFillColor(),
                borderRadius: Dimensions.kBorderRadius,
              ),
              constraints: BoxConstraints(
                maxHeight: 200.h,
              ),
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _filteredItems.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  thickness: 1,
                  color: Get.isDarkMode ? AppColors.whiteColor.withOpacity(0.1) : AppColors.black10,
                ),
                itemBuilder: (context, index) {
                  final item = _filteredItems[index];
                  return InkWell(
                    onTap: () {
                      _searchController.text = item;
                      widget.onChanged(item);
                      _hideOverlay();
                      _focusNode.unfocus();
                    },
                    child: Container(
                      height: 46.h,
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item,
                        style: widget.selectedStyle ??
                            TextStyle(
                              fontSize: 14.sp,
                              color: Get.isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        height: widget.height ?? 46.h,
        width: widget.width ?? double.infinity,
        decoration: BoxDecoration(
          color: widget.bgColor ?? AppThemes.getFillColor(),
          borderRadius: Dimensions.kBorderRadius,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                focusNode: _focusNode,
                enabled: widget.isSearchable,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Get.isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: widget.hintStyle ??
                      TextStyle(
                        fontSize: 16.sp,
                        color: AppThemes.getGreyColor(),
                        fontWeight: FontWeight.w400,
                      ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12.h, 
                    horizontal: 15.w,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                onChanged: _filterItems,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: AppThemes.getGreyColor(),
                size: 22.h, // Slightly increased for better visibility
              ),
            ),
          ],
        ),
      ),
    );
  }
}
