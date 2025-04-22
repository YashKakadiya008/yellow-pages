import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yellowpages/views/widgets/text_theme_extension.dart';
import '../../../../config/app_colors.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/helpers.dart';
import '../../widgets/app_textfield.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/spacing.dart';

class SupportTicketViewScreen extends StatefulWidget {
  const SupportTicketViewScreen({super.key});

  @override
  State<SupportTicketViewScreen> createState() =>
      _SupportTicketViewScreenState();
}

class _SupportTicketViewScreenState extends State<SupportTicketViewScreen> {
  bool isShowEmoji = false;
  FocusNode focusNode = FocusNode();
  TextEditingController messageController = TextEditingController();
  onBackspacePressed() {
    messageController
      ..text = messageController.text.characters.toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: messageController.text.length));
  }

  @override
  void initState() {
    focusNode.addListener(() {
      setState(() {
        if (focusNode.hasFocus) {
          if (isShowEmoji == true) {
            isShowEmoji = false;
          }
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // Dispose of the FocusNode when it is no longer needed
    focusNode.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Get.isDarkMode ? const Color(0xff0E111F) : AppColors.whiteColor,
      appBar: CustomAppBar(
        bgColor:
            Get.isDarkMode ? const Color(0xff0E111F) : AppColors.whiteColor,
        title: "Support Ticket",
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
            shrinkWrap: true,
            reverse:
                true, // To make the chat messages scroll from bottom to top
            itemCount: messageList.length,
            itemBuilder: (BuildContext context, int index) {
              var data = messageList[index];
              return ListTile(
                title: Column(
                  crossAxisAlignment: data.isAdmin == false
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // setState(() {
                        //   timeVisible = !timeVisible;
                        //   selectedIndex = index;
                        // });
                      },
                      child: data.isAttatchment == false
                          ? Container(
                              constraints: BoxConstraints(
                                maxWidth: 300.w,
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.w,
                                  vertical: calculateHorizontalPadding(
                                      data.message.length)),
                              // padding: EdgeInsets.symmetric(
                              //     horizontal: 20.w, vertical: 5.h),
                              decoration: BoxDecoration(
                                color: data.isAdmin == false
                                    ? AppColors.mainColor
                                    : Get.isDarkMode
                                        ? const Color(0xff161A2D)
                                        : AppColors.mainColor.withOpacity(
                                            .2), // User and admin message bubble color
                                borderRadius: data.isAdmin == true
                                    ? BorderRadius.only(
                                        bottomRight: Radius.circular(40.r),
                                        topRight: Radius.circular(40.r),
                                        topLeft: Radius.circular(40.r),
                                      )
                                    : BorderRadius.only(
                                        topLeft: Radius.circular(40.r),
                                        topRight: Radius.circular(40.r),
                                        bottomLeft: Radius.circular(40.r),
                                      ),
                              ),
                              child: Text(
                                data.message,
                                style: context.t.displayMedium?.copyWith(
                                  color: data.isAdmin
                                      ? Get.isDarkMode
                                          ? AppColors.whiteColor
                                          : AppColors.blackColor
                                      : AppColors.whiteColor,
                                ),
                              ),
                            )
                          : Column(
                              crossAxisAlignment: data.isAdmin == false
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: data.isAdmin == true
                                      ? MainAxisAlignment.start
                                      : MainAxisAlignment.end,
                                  children: [
                                    data.isAdmin == true
                                        ? Container(
                                            height: 34.h,
                                            width: 34.h,
                                            margin:
                                                EdgeInsets.only(right: 12.w),
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              color: AppColors.mainColor,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          data.image ?? ""))),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w, vertical: 5.h),
                                      decoration: BoxDecoration(
                                        color: data.isAdmin == false
                                            ? AppColors.mainColor
                                            : AppThemes
                                                .getFillColor(), // User and admin message bubble color
                                        borderRadius: data.isAdmin == true
                                            ? BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(40.r),
                                                topRight: Radius.circular(40.r),
                                                topLeft: Radius.circular(40.r),
                                              )
                                            : BorderRadius.only(
                                                topLeft: Radius.circular(40.r),
                                                topRight: Radius.circular(40.r),
                                                bottomLeft:
                                                    Radius.circular(40.r),
                                              ),
                                      ),
                                      child: Container(
                                        constraints: BoxConstraints(
                                          maxWidth:
                                              MediaQuery.sizeOf(context).width *
                                                  .5,
                                        ),
                                        child: Text(
                                          data.message,
                                          style:
                                              context.t.displayMedium?.copyWith(
                                            color: data.isAdmin
                                                ? Get.isDarkMode
                                                    ? AppColors.whiteColor
                                                    : AppColors.blackColor
                                                : AppColors.whiteColor,
                                          ), // User and admin message text color
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Wrap(
                                      alignment: data.isAdmin == false
                                          ? WrapAlignment.end
                                          : WrapAlignment.start,
                                      runSpacing: 5,
                                      spacing: 2,
                                      children: [
                                        data.isAttatchment == false
                                            ? const SizedBox()
                                            : InkWell(
                                                onTap: () async {
                                                  // get the file name from attachment path
                                                  // Uri uri = Uri.parse(
                                                  //     attachment.attachmentPath);
                                                  // String filename =
                                                  //     uri.pathSegments.last;
                                                  // Get.find<TicketListController>()
                                                  //         .attachmentPath
                                                  //         .value =
                                                  //     attachment.attachmentPath;

                                                  // // finally download the file
                                                  // await Get.find<TicketListController>()
                                                  //     .downloadFile(
                                                  //         fileUrl:
                                                  //             attachment.attachmentPath,
                                                  //         fileName: filename,
                                                  //         context: context);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10.w,
                                                      vertical: 5.h),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.mainColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.r),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      // Get.find<TicketListController>()
                                                      //                 .attachmentPath
                                                      //                 .value ==
                                                      //             attachment
                                                      //                 .attachmentPath &&
                                                      //         Get.find<
                                                      //                 TicketListController>()
                                                      //             .isDownloadPressed
                                                      //             .value
                                                      //     ? Text(
                                                      //         Get.find<
                                                      //                 TicketListController>()
                                                      //             .downloadCompleted
                                                      //             .value,
                                                      //         style: TextStyle(
                                                      //           fontSize: 15.sp,
                                                      //           fontFamily: 'Dubai',
                                                      //           color: AppColors
                                                      //               .appWhiteColor,
                                                      //           // You can adjust the style as needed
                                                      //         ),
                                                      //       )
                                                      //     : SizedBox.shrink(),
                                                      Icon(
                                                        Icons.download,
                                                        size: 17.h,
                                                        color: AppColors
                                                            .whiteColor,
                                                      ),
                                                      Text(
                                                        data.attatchmentName ??
                                                            "",
                                                        style: TextStyle(
                                                          fontSize: 15.sp,
                                                          fontFamily: 'Dubai',
                                                          color: AppColors
                                                              .whiteColor,
                                                          // You can adjust the style as needed
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                      ]),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              );
            },
          )),
          Padding(
            padding: EdgeInsets.only(bottom: 15.h),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 60.h,
                maxHeight: 350.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: Image.asset(
                            "$rootImageDir/file_pick.png",
                            height: 19.h,
                          )),
                      Expanded(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: 46.h,
                            maxHeight: 100.h,
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              color: AppThemes.getFillColor(),
                              borderRadius: BorderRadius.circular(32.r),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                    child: AppTextField(
                                  focusNode: focusNode,
                                  controller: messageController,
                                  contentPadding: EdgeInsets.only(left: 20.w),
                                  maxLines: 8,
                                  hinText: "Type any text here",
                                )),
                                HSpace(3.w),
                                InkResponse(
                                  onTap: () {
                                    setState(() {
                                      isShowEmoji = !isShowEmoji;
                                      Helpers.hideKeyboard();
                                    });
                                  },
                                  radius: 8.r,
                                  child: Image.asset(
                                    "$rootImageDir/emoji.png",
                                    height: 20.h,
                                  ),
                                ),
                                HSpace(15.w),
                              ],
                            ),
                          ),
                        ),
                      ),
                      HSpace(10.w),
                      InkResponse(
                        onTap: () {
                          messageController.clear();
                        },
                        child: Container(
                          height: 46.h,
                          width: 46.h,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10.h),
                          decoration: BoxDecoration(
                            color: AppThemes.getFillColor(),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 5.w),
                            child: Image.asset("$rootImageDir/send_active.png"),
                          ),
                        ),
                      ),
                      HSpace(20.w),
                    ],
                  ),
                  if (isShowEmoji)
                    SizedBox(
                        height: 250.h,
                        child: EmojiPicker(
                          textEditingController: messageController,
                          onBackspacePressed: onBackspacePressed,
                          config: Config(
                            columns: 11,
                            emojiSizeMax: 24.h,
                            verticalSpacing: 0,
                            horizontalSpacing: 0,
                            gridPadding: EdgeInsets.zero,
                            initCategory: Category.RECENT,
                            bgColor: Get.isDarkMode
                                ? AppColors.darkBgColor
                                : AppColors.whiteColor,
                            indicatorColor: AppColors.mainColor,
                            iconColor: Colors.grey,
                            iconColorSelected: AppColors.mainColor,
                            backspaceColor: AppColors.mainColor,
                            skinToneDialogBgColor: Colors.white,
                            skinToneIndicatorColor: Colors.grey,
                            enableSkinTones: true,
                            recentTabBehavior: RecentTabBehavior.RECENT,
                            recentsLimit: 28,
                            replaceEmojiOnLimitExceed: false,
                            noRecents: Text(
                              'No Recents',
                              style: context.t.titleSmall,
                              textAlign: TextAlign.center,
                            ),
                            loadingIndicator: const SizedBox.shrink(),
                            tabIndicatorAnimDuration: kTabScrollDuration,
                            categoryIcons: const CategoryIcons(),
                            buttonMode: ButtonMode.MATERIAL,
                            checkPlatformCompatibility: true,
                          ),
                        )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double calculateHorizontalPadding(int textLength) {
    if (textLength > 35) {
      return 5.h;
    } else {
      return 15.h;
    }
  }

  List<MessageCategory> messageList = [
    MessageCategory(
      isAdmin: false,
      message: 'Please tell about data Transfer',
      isAttatchment: false,
    ),
    MessageCategory(
        isAdmin: false,
        message: 'How are you?',
        isAttatchment: true,
        attatchmentName: 'File1'),
    MessageCategory(
        isAdmin: true,
        isAttatchment: false,
        message: 'Please check it out!',
        image:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRn8VObWtmJRuB3kJSf0mbEv9_3r8YICVKu2w&usqp=CAU'),
    MessageCategory(
      isAdmin: false,
      message: 'I need your help',
      isAttatchment: false,
    ),
    MessageCategory(
      isAdmin: false,
      message: 'I want to know about th data processing system',
      isAttatchment: false,
    ),
    MessageCategory(
        isAdmin: true,
        isAttatchment: false,
        message: 'Would you please tell me what\'s the problem?',
        image:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRn8VObWtmJRuB3kJSf0mbEv9_3r8YICVKu2w&usqp=CAU'),
    MessageCategory(
      isAdmin: false,
      message: 'Okay I\'m waiting',
      isAttatchment: false,
    ),
    MessageCategory(
        isAdmin: true,
        message: 'Wait a moment!',
        isAttatchment: false,
        image:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRn8VObWtmJRuB3kJSf0mbEv9_3r8YICVKu2w&usqp=CAU'),
    MessageCategory(
      isAdmin: false,
      message: 'Please tell about data Transfer',
      isAttatchment: false,
    ),
    MessageCategory(
        isAdmin: true,
        isAttatchment: false,
        image:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRn8VObWtmJRuB3kJSf0mbEv9_3r8YICVKu2w&usqp=CAU',
        message: 'Hello, How can i help you?'),
  ];
}

class MessageCategory {
  final bool isAdmin;
  final String message;
  final String? image;
  final bool isAttatchment;
  final String? attatchmentName;
  MessageCategory(
      {required this.isAdmin,
      required this.message,
      this.image,
      required this.isAttatchment,
      this.attatchmentName});
}
