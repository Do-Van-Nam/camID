import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/utils/utility_fuctions.dart';
import 'package:cam_id/main/utils/widget/common_widgets.dart';
import 'package:cam_id/res/app_colors.dart';
import 'package:cam_id/res/app_fonts.dart';
import 'package:cam_id/res/app_images.dart';
import 'package:cam_id/res/app_styles.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'game_list_bloc.dart';

class GameListPage extends StatelessWidget {
  const GameListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (_) => GameListBloc(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0, // ngăn elevation khi cuộn dưới
          surfaceTintColor: Colors.transparent, // ngăn tint màu khi cuộn
          leading: GestureDetector(
            onTap: () {
              context.pop();
            },
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: SvgPicture.asset(
                    AppImages.icBackBlack,
                    // width: 24,
                    // height: 24,
                  ),
                ),
              ),
            ),
          ),

          title: Text(l10n.specialGame, style: AppStyles.header),
        ),

        body: BlocBuilder<GameListBloc, GameListState>(
          builder: (context, state) {
            if (state.isLoadingBanners) {
              return const Center(child: CircularProgressIndicator());
            }
            return SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 16),
                  Expanded(
                    // padding: const EdgeInsets.only(top: 16.0),
                    // width: double.infinity,
                    // height:
                    //     320, // Chiều cao cố định – điều chỉnh theo kích thước card của bạn
                    child: GridView.builder(
                      scrollDirection: Axis.vertical, // Cuộn dọc
                      physics:
                          const BouncingScrollPhysics(), // Cuộn mượt (iOS style) hoặc ClampingScrollPhysics()
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            2, // 2 hàng (vì cuộn ngang → crossAxis là chiều dọc)
                        childAspectRatio:
                            0.85, // Tỷ lệ width/height của mỗi card (tùy chỉnh cho đẹp)
                        crossAxisSpacing:
                            16, // Khoảng cách dọc giữa 2 voucher trong cùng cột
                        mainAxisSpacing:
                            16, // Khoảng cách ngang giữa các cột khi cuộn
                      ),
                      itemCount: state.specialGames.length,
                      itemBuilder: (context, index) {
                        return _buildGameCard(
                          state.specialGames[index].imageUrl,
                          state.specialGames[index].title,
                          () {},
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGameCard(String url, String name, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 1,
              child: CachedNetworkImage(
                imageUrl: url,
                // width: 120,
                // height: 160,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: AppStyles.poppins14Medium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
