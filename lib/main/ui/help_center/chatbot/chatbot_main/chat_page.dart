import 'dart:async';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:cam_id/main/data/api/api_end_point.dart';
import 'package:cam_id/main/data/model/chatbot/button_callback.dart';
import 'package:cam_id/main/data/model/chatbot/button_callback_data_item.dart';
import 'package:cam_id/main/data/model/chatbot/ws_response_data.dart';
import 'package:cam_id/main/utils/utility_fuctions.dart';
import 'package:cam_id/main/utils/widget/image_widget.dart';
import 'package:cam_id/res/app_colors.dart';
import 'package:cam_id/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'chat_bloc.dart';
import 'package:cam_id/res/app_images.dart';
import 'package:cam_id/generated/app_localizations.dart';

class ChatBotPage extends StatefulWidget {
  final String? initialMessage;

  const ChatBotPage({super.key, this.initialMessage});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (_) =>
          ChatBloc()
            ..add(InitChatEvent(widget.initialMessage ?? l10n.chatbotStart)),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leadingWidth: 550,
          leading: Row(
            children: [
              IconButton(
                icon: SvgPicture.asset(AppImages.icBack, width: 24, height: 24),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 4),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage(AppImages.imgChatBot5),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.chatbotTitle, style: AppStyles.headerWhite),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      CircleAvatar(radius: 5, backgroundColor: Colors.green),
                      const SizedBox(width: 4),
                      Text(
                        l10n.online,
                        style: const TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        body: BlocConsumer<ChatBloc, ChatState>(
          listener: (context, state) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_scrollController.hasClients) {
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }
            });
          },
          builder: (context, state) {
            return Stack(
              children: [
                // Overlay mờ khi mở menu

                // Background chat
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Image.asset(AppImages.chatbotBG, fit: BoxFit.fitWidth),
                ),

                // Nội dung chat chính
                SafeArea(
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Danh sách tin nhắn + input...
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(16),
                            itemCount:
                                state.messages.length +
                                (state.isTyping ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == state.messages.length &&
                                  state.isTyping) {
                                return _buildBotTyping();
                              }
                              final msg = state.messages[index];
                              return _buildMessageBubble(msg, context);
                            },
                          ),
                        ),

                        _buildInputField(context, state),
                      ],
                    ),
                  ),
                ),
                if (state.isOpenMenu)
                  GestureDetector(
                    onTap: () {
                      // WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.read<ChatBloc>().add(ToggleMenuEvent());
                      // });
                    },
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.5),
                    ),
                  ),

                // Menu trắng
                if (state.isOpenMenu)
                  Positioned(
                    bottom: 40, // Khoảng cách từ FAB
                    left: 16,
                    child: Material(
                      // Thêm Material để shadow hoạt động tốt hơn
                      elevation: 10,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 220,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildMenuItem(
                              iconPath: AppImages.icMenuRed,
                              label: l10n.mainMenu,
                              onTap: () {
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  context.read<ChatBloc>().add(
                                    SendMessageEvent(
                                      l10n.mainMenu,
                                      "main_menu",
                                      WSCode.wsGetMenu,
                                    ),
                                  );
                                  context.read<ChatBloc>().add(
                                    ToggleMenuEvent(),
                                  );
                                });
                              },
                            ),
                            _buildMenuItem(
                              iconPath: AppImages.icLogin,
                              label: l10n.changePhoneNumberLogin,
                              onTap: () {
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  context.read<ChatBloc>().add(
                                    SendMessageEvent(
                                      l10n.changePhoneNumberLogin,
                                      "change_phone_number",
                                      WSCode.wsGetMenu,
                                    ),
                                  );
                                  context.read<ChatBloc>().add(
                                    SendMessageEvent(
                                      l10n.changePhoneNumberLogin,
                                      "change_phone_number",
                                      "reset-user",
                                      userMessage: false,
                                    ),
                                  );
                                  context.read<ChatBloc>().add(
                                    ToggleMenuEvent(),
                                  );
                                });
                              },
                            ),
                            _buildMenuItem(
                              iconPath: AppImages.icMessage,
                              label: l10n.newChat,
                              onTap: () async {
                                final completer = Completer();
                                context.read<ChatBloc>().add(
                                  ResetChatEvent(completer: completer),
                                );

                                await completer
                                    .future; // Đợi cho đến khi Bloc xử lý xong Reset

                                context.read<ChatBloc>().add(
                                  SendMessageEvent(
                                    l10n.chatbotStart,
                                    "new_chat",
                                    WSCode.wsGetMenu,
                                  ),
                                );
                                context.read<ChatBloc>().add(ToggleMenuEvent());

                                if (_controller.text.trim().isNotEmpty) {
                                  _controller.clear();
                                }
                              },
                            ),
                            _buildMenuItem(
                              iconPath: AppImages.icCall,
                              label: l10n.callTheStaffs,
                              onTap: () {
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  context.read<ChatBloc>().add(
                                    ToggleMenuEvent(),
                                  );
                                  makePhoneCall("1204");
                                });
                                print('Gọi nhân viên');
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMessageBubble(WsResponseData msg, BuildContext context) {
    developer.log(msg.buttonCallbackDataList.length.toString());
    return msg.isBot
        // tra loi cua bot
        ? Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                // noi dung tra loi cua bot
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(msg.answer ?? msg.descriptionButton),
                      SizedBox(height: 4),
                      Text(
                        '${msg.datetime!.hour}:${msg.datetime!.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                // cac nut lua chon
                msg.buttonCallbackDataList.isNotEmpty
                    ?
                      // chi co 1 nhom nut
                      msg.buttonCallbackDataList.length == 1
                          ? LayoutBuilder(
                              builder: (context, constraints) {
                                double width = constraints.maxWidth;
                                List<ButtonCallback> buttons = msg
                                    .buttonCallbackDataList[0]
                                    .buttonCallBacks;
                                int itemCount = buttons.length;

                                return Wrap(
                                  children: List.generate(itemCount, (index) {
                                    // Kiểm tra nếu là phần tử cuối cùng và tổng số lượng là số lẻ
                                    bool isLastAndOdd =
                                        (index == itemCount - 1) &&
                                        (itemCount % 2 != 0);

                                    return Container(
                                      width: isLastAndOdd
                                          ? width
                                          : width /
                                                2, // Nếu lẻ thì rộng 100%, ngược lại 50%

                                      child: _buildBotButton(
                                        buttons[index],
                                        context,
                                      ),
                                    );
                                  }),
                                );
                              },
                            )
                          // co nhieu hon 1 nhom nut
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              //height: 250,
                              child: Row(
                                children: List.generate(
                                  msg.buttonCallbackDataList.length,
                                  (index) {
                                    return _buildGroupBotButton(
                                      msg.buttonCallbackDataList[index],
                                      context,
                                    );
                                  },
                                ),
                              ),
                            )
                    : SizedBox(),
                msg.suggestionQuestion?.isNotEmpty ?? false
                    ? LayoutBuilder(
                        builder: (context, constraints) {
                          double width = constraints.maxWidth;
                          List<String> buttons = msg.suggestionQuestion!;
                          int itemCount = buttons.length;
                          return Wrap(
                            children: List.generate(itemCount, (index) {
                              ButtonCallback temp = ButtonCallback(
                                buttonName: buttons[index],
                                callbackData: "callbackData",
                                type: "type",
                                isCallLinkIfLogin: "isCallLinkIfLogin",
                              );
                              return Container(
                                width: width,

                                child: _buildBotButton(temp, context, true),
                              );
                            }),
                          );
                        },
                      )
                    : SizedBox(),
              ],
            ),
          )
        : Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(msg.descriptionButton),
                  SizedBox(height: 4),
                  Text(
                    '${msg.datetime!.hour}:${msg.datetime!.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _buildBotButton(
    ButtonCallback buttonCallback,
    BuildContext context, [
    bool isQuestion = false,
  ]) {
    bool hasUrl = buttonCallback.iconNameAddress != null;
    return GestureDetector(
      onTap: () {
        isQuestion
            ? context.read<ChatBloc>().add(
                SendMessageFromInputEvent(buttonCallback.buttonName),
              )
            : context.read<ChatBloc>().add(
                SendMessageEvent(
                  buttonCallback.buttonName,
                  buttonCallback.callbackData,
                  WSCode.wsGetMenu,
                ),
              );
      },
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: hasUrl
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  CircleAvatar(
                    child: SafeImage(
                      url: buttonCallback.buttonName,
                      placeholder: AppImages.imgEntertainmentDefault,
                      errorAsset: AppImages.imgEntertainmentDefault,
                    ),
                  ),
                  Text(buttonCallback.buttonName),
                ],
              )
            : Center(child: Text(buttonCallback.buttonName)),
      ),
    );
  }

  Widget _buildGroupBotButton(
    ButtonCallbackDataItem item,
    BuildContext context,
  ) {
    return Container(
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(item.title ?? ""),
          ...item.buttonCallBacks
              .map(
                (btn) => TextButton(
                  onPressed: () {
                    context.read<ChatBloc>().add(
                      SendMessageEvent(
                        btn.buttonName,
                        btn.callbackData,
                        WSCode.wsGetMenu,
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(AppImages.icTickCircle),
                      Text(btn.buttonName),
                    ],
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _buildBotTyping() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            3,
            (i) => Container(
              margin: EdgeInsets.only(right: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(BuildContext context, ChatState state) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () {
              context.read<ChatBloc>().add(ToggleMenuEvent());
            },
            child: SvgPicture.asset(
              AppImages.icMenu,
              width: 24,
              height: 24,
              // colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn), // Nếu cần đổi màu icon trắng
            ),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Write your message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty && !state.isTyping) {
                  developer.log("nhap input va gui");
                  print("nhap input va gui");
                  context.read<ChatBloc>().add(
                    SendMessageFromInputEvent(value.trim()),
                  );
                  _controller.clear();
                }
              },
            ),
          ),
          SizedBox(width: 8),
          FloatingActionButton(
            enableFeedback: !state.isTyping,
            backgroundColor: Colors.red,
            shape: CircleBorder(),
            onPressed: () {
              if (_controller.text.trim().isNotEmpty && !state.isTyping) {
                context.read<ChatBloc>().add(
                  SendMessageFromInputEvent(_controller.text.trim()),
                );
                _controller.clear();
              }
            },
            child: SvgPicture.asset(AppImages.icSend, width: 24, height: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String iconPath,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(Colors.red, BlendMode.srcIn),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
