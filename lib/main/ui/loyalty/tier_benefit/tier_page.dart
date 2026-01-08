import 'dart:math';

import 'package:cam_id/res/app_colors.dart';
import 'package:cam_id/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'tier_bloc.dart';
import 'package:cam_id/res/app_images.dart';
import 'package:cam_id/generated/app_localizations.dart';

class TierPage extends StatefulWidget {
  const TierPage({super.key});

  @override
  State<TierPage> createState() => _TierPageState();
}

class _TierPageState extends State<TierPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (_) => TierBloc(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          // leadingWidth: 250,
          leading: IconButton(
            icon: SvgPicture.asset(AppImages.icBack, width: 24, height: 24),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            l10n.tierBenefits,
            style: AppStyles.header.copyWith(color: AppColors.color_5F5F),
          ),
        ),
        body: BlocConsumer<TierBloc, TierState>(
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
                    width: double.infinity,
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
                        Text("fadkl"),
                      ],
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
}
