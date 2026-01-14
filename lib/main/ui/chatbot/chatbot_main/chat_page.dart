import 'dart:math';

import 'package:cam_id/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import './chat_bloc.dart';
import 'package:cam_id/res/app_images.dart';
import 'package:cam_id/generated/app_localizations.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

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
      create: (_) => ChatBloc(),
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
                              return _buildMessageBubble(msg);
                            },
                          ),
                        ),

                        if (state.messages.length == 1)
                          _buildLanguageSelection(state),
                        if (state.messages.length > 2)
                          _buildQuickButtons(context),
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
                                    ToggleMenuEvent(),
                                  );
                                });
                              },
                            ),
                            _buildMenuItem(
                              iconPath: AppImages.icMessage,
                              label: l10n.newChat,
                              onTap: () {
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  context.read<ChatBloc>().add(
                                    ToggleMenuEvent(),
                                  );
                                });
                                if (_controller.text.trim().isNotEmpty) {
                                  context.read<ChatBloc>().add(
                                    SendMessageEvent(_controller.text.trim()),
                                  );
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

  Widget _buildMessageBubble(Message msg) {
    return Align(
      alignment: msg.isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: msg.isBot ? Colors.grey[200] : Colors.red[50],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: msg.isBot
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            Text(msg.text),
            SizedBox(height: 4),
            Text(
              '${msg.time.hour}:${msg.time.minute.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
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

  Widget _buildLanguageSelection(ChatState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildLangButton(
            'ខ្មែរ',
            'km',
            state.selectedLanguage == 'km',
            context,
          ),
          _buildLangButton(
            'English',
            'en',
            state.selectedLanguage == 'en',
            context,
          ),
        ],
      ),
    );
  }

  Widget _buildLangButton(
    String text,
    String lang,
    bool selected,
    BuildContext context,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? Colors.red : Colors.grey[300],
      ),
      onPressed: () => context.read<ChatBloc>().add(ChangeLanguageEvent(lang)),
      child: Text(
        text,
        style: TextStyle(color: selected ? Colors.white : Colors.black),
      ),
    );
  }

  Widget _buildQuickButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _quickButton('Mobile Service', context),
          _quickButton('WiFi Service', context),
          _quickButton('Switch Language', context),
          _quickButton('FAQs', context),
        ],
      ),
    );
  }

  Widget _quickButton(String text, BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        _controller.text = text;
        context.read<ChatBloc>().add(SendMessageEvent(text));
        _controller.clear();
      },
      child: Text(text),
    );
  }

  Widget _buildInputField(BuildContext context, ChatState state) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.grey[100],
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
                if (value.trim().isNotEmpty) {
                  context.read<ChatBloc>().add(SendMessageEvent(value.trim()));
                  _controller.clear();
                }
              },
            ),
          ),
          SizedBox(width: 8),
          FloatingActionButton(
            backgroundColor: Colors.red,
            shape: CircleBorder(),
            onPressed: () {
              if (_controller.text.trim().isNotEmpty) {
                context.read<ChatBloc>().add(
                  SendMessageEvent(_controller.text.trim()),
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
