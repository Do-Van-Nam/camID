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
import 'ranking_bloc.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (_) => GameBloc(),
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

          title: Text(l10n.ranking, style: AppStyles.header),
        ),

        body: BlocBuilder<GameBloc, GameState>(
          builder: (context, state) {
            if (state.isLoadingBanners) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: _buildRankItem(
                        index + 1,
                        state.actionGames[index].imageUrl,
                        state.actionGames[index].title,
                        Random().nextInt(1000000),
                      ),
                    );
                  },
                  itemCount: state.actionGames.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRankItem(int rank, String url, String name, int score) {
    return Row(
      spacing: 4,
      children: [
        SizedBox(
          width: 40,
          child: Center(
            child: rank <= 3
                ? Image.asset(
                    rank == 1
                        ? AppImages.icBadge1
                        : rank == 2
                        ? AppImages.icBadge2
                        : AppImages.icBadge3,
                    width: 30,
                    height: 30,
                  )
                : Text(
                    '$rank',
                    style: AppStyles.poppins14Medium.copyWith(
                      color: Colors.black,
                    ),
                  ),
          ),
        ),
        ClipOval(
          child: CachedNetworkImage(
            width: 60,
            height: 60,
            imageUrl: url,
            fit: BoxFit.cover,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        const SizedBox(width: 12),
        Text(name, style: AppStyles.poppins14Medium),
        Spacer(),
        Container(
          width: 100,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.color_E11B_04,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              SvgPicture.asset(AppImages.icRedStar, width: 20, height: 20),
              const SizedBox(width: 4),
              Text(
                formatWithDots(score),
                style: AppStyles.poppins14Medium.copyWith(color: Colors.red),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
