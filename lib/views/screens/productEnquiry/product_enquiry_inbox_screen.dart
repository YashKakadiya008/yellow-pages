import 'dart:async';
import 'dart:convert';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yellowpages/data/services/SharedPreferencesService.dart';
import 'package:http/http.dart' as http;
import 'package:yellowpages/utils/services/SocketService.dart';
import 'package:yellowpages/views/widgets/text_theme_extension.dart';
import '../../../../config/app_colors.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/helpers.dart';
import '../../widgets/app_textfield.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/spacing.dart';

class ProductEnquiryInboxScreen extends StatefulWidget {
  const ProductEnquiryInboxScreen({super.key});

  @override
  State<ProductEnquiryInboxScreen> createState() =>
      _ProductEnquiryInboxScreenState();
}

class _ProductEnquiryInboxScreenState extends State<ProductEnquiryInboxScreen> {
  bool isShowEmoji = false;
  FocusNode focusNode = FocusNode();
  TextEditingController messageController = TextEditingController();
  final SocketService socketService = SocketService();
  Timer? typingTimer;

  List<MessageCategory> messages = [];
  bool isTyping = false;
  late String chatId;
  late String userId;

  void onBackspacePressed() {
    messageController
      ..text = messageController.text.characters.toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: messageController.text.length));
  }

  void setUserId() async {
    userId = await SharedPreferencesService.getUserID() ?? '';
  }

  Future<void> fetchMessages() async {
    final token = await SharedPreferencesService.getAccessToken();
    final url = Uri.parse("${AppConstants.baseUri}/chats/$chatId/messages");

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          messages = (data['messages'] as List)
              .map((msg) => MessageCategory(
                    isAdmin: msg['sender']['_id'] != userId,
                    message: msg['text'] ?? '',
                    isAttatchment: false,
                  ))
              .toList();
        });
      } else {
        print("Failed to load messages: ${response.body}");
      }
    } catch (e) {
      print("Error fetching messages: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    chatId = Get.arguments['chatId'] ?? '';
    setUserId();
    fetchMessages();
    // Initialize socket connection
    socketService.initializeSocket();

    // Join the chat room
    socketService.joinChat(chatId);

    socketService.onNewMessage((data) {
      print("New message: ${data['message']['text']}");
      if (data != null &&
          data['message']['text'] != null &&
          userId != data['message']['sender']['_id']) {
        print("Message Text: ${data['message']['text']}");
        setState(() {
          messages.insert(
            0,
            MessageCategory(
              isAdmin: true,
              message: data['message']['text'] ?? '', // Fallback if null
              isAttatchment: false,
              image: data['senderImage'] ?? '', // Fallback if null
            ),
          );
        });
      } else {
        print("Received data doesn't have expected structure or text is null.");
      }
    });

    // Set up typing status listener
    socketService.onTypingStatus((data) {
      if (mounted) {
        setState(() {
          isTyping = data['isTyping'];
        });
      }
    });

    // Error handling
    socketService.onError((error) {
      print('Socket error: $error');
      // Show error message to user if needed
    });

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        handleTyping(true);
      }
    });
  }

  void sendMessage() {
    if (messageController.text.trim().isEmpty) return;

    final message = messageController.text.trim();
    print('Sending message: $chatId');
    // Send message through socket
    socketService.sendMessage(
      chatId: chatId,
      text: message,
    );

    // Add message to local list
    setState(() {
      messages.insert(
          0,
          MessageCategory(
            isAdmin: false,
            message: message,
            isAttatchment: false,
          ));
    });

    messageController.clear();
  }

  void handleTyping(bool isTyping) {
    if (isTyping) {
      socketService.sendTypingStatus(chatId, true);

      // Reset the timer if the user continues typing
      typingTimer?.cancel();

      // Set a delay before sending "stopped typing" status
      typingTimer = Timer(Duration(seconds: 2), () {
        socketService.sendTypingStatus(chatId, false);
      });
    }
  }

  @override
  void dispose() {
    focusNode.dispose();
    messageController.dispose();
    socketService.leaveChat(chatId);
    socketService.disconnect();
    typingTimer?.cancel();
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
        title: "Chat",
      ),
      body: Column(
        children: [
          if (isTyping)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Text(
                "User is typing...",
                style: context.t.labelMedium?.copyWith(
                  color: AppColors.mainColor,
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                var data = messages[index];
                return ListTile(
                  title: Column(
                    crossAxisAlignment: data.isAdmin
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: 300.w,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.w,
                            vertical:
                                calculateHorizontalPadding(data.message.length),
                          ),
                          decoration: BoxDecoration(
                            color: data.isAdmin
                                ? (Get.isDarkMode
                                    ? const Color(0xff161A2D)
                                    : AppColors.mainColor.withOpacity(.2))
                                : AppColors.mainColor,
                            borderRadius: data.isAdmin
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
                                  ? (Get.isDarkMode
                                      ? AppColors.whiteColor
                                      : AppColors.blackColor)
                                  : AppColors.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
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
                        ),
                      ),
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
                                    onChanged: (value) {
                                      print("Typing: $value");
                                      handleTyping(value.isNotEmpty);
                                    },
                                  ),
                                ),
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
                        onTap: sendMessage,
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
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double calculateHorizontalPadding(int textLength) {
    return textLength > 35 ? 5.h : 15.h;
  }
}

class MessageCategory {
  final bool isAdmin;
  final String message;
  final String? image;
  final bool isAttatchment;
  final String? attatchmentName;

  MessageCategory({
    required this.isAdmin,
    required this.message,
    this.image,
    required this.isAttatchment,
    this.attatchmentName,
  });
}
