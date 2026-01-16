import 'package:cached_network_image/cached_network_image.dart';
import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/data/model/game/category_model.dart';
import 'package:cam_id/main/data/model/game/game_model.dart';
import 'package:cam_id/main/utils/utility_fuctions.dart';
import 'package:cam_id/main/utils/widget/common_widgets.dart';
import 'package:cam_id/main/utils/widget/image_widget.dart';
import 'package:cam_id/res/app_colors.dart';
import 'package:cam_id/res/app_fonts.dart';
import 'package:cam_id/res/app_images.dart';
import 'package:cam_id/res/app_styles.dart';
import 'package:cam_id/router.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import './game_bloc.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

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

          title: Text(l10n.game, style: AppStyles.header),
          actions: [
            IconButton(
              icon: SvgPicture.asset(
                AppImages.icSearchBlack,
                width: 24,
                height: 24,
              ),
              onPressed: () {
                // Xử lý khi nhấn vào biểu tượng thông báo
              },
            ),

            SizedBox(width: 16),
          ],
        ),

        body: BlocBuilder<GameBloc, GameState>(
          builder: (context, state) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner carousel
                    if (state.isLoadingBanners)
                      const Center(child: CircularProgressIndicator())
                    else
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 160,
                          autoPlay: true,
                          viewportFraction: 0.8,
                          enlargeCenterPage: false,
                          enlargeFactor: 0.2,
                          onPageChanged: (index, reason) {
                            context.read<GameBloc>().add(
                              ChangeBannerEvent(index),
                            );
                          },
                        ),
                        items: state.banners
                            .map(
                              (url) => Container(
                                clipBehavior: Clip.antiAlias,
                                margin: EdgeInsets.symmetric(horizontal: 18),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  // image: DecorationImage(
                                  //   image: CachedNetworkImageProvider(url),
                                  //   fit: BoxFit.cover,
                                  // ),
                                ),
                                child: SafeImage(
                                  width: double.infinity,
                                  url: url,
                                  placeholder:
                                      AppImages.imgEntertainmentDefault,
                                  errorAsset: AppImages.imgEntertainmentDefault,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: state.banners.asMap().entries.map((entry) {
                        return Container(
                          width: state.currentBannerIndex == entry.key ? 16 : 6,
                          height: 6,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: state.currentBannerIndex == entry.key
                                ? AppColors.colorMain
                                : Colors.grey,
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),

                    // My Gift & Ranking buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildBigButton(
                              l10n.myGift,
                              AppImages.imgReward,
                              () => context.push(PATH_GIFT),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildBigButton(
                              l10n.ranking,
                              AppImages.imgRanking,
                              () => context.push(PATH_RANKING),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    viewAllHeader(
                      title: l10n.category,
                      onViewAll: () {},
                      context: context,
                    ),

                    const SizedBox(height: 12),

                    // Category chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          _buildCategoryChip(
                            l10n.trendingNow,
                            AppImages.icStarEmpty,
                          ),
                          _buildCategoryChip(
                            l10n.specialGame,
                            AppImages.icCrown,
                          ),
                          _buildCategoryChip(l10n.action, AppImages.icAction),
                        ],
                      ),
                    ),
                    // Trending now
                    viewAllHeader(
                      title: l10n.trendingNow,
                      onViewAll: () {},
                      context: context,
                    ),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: state.trendingGames.length,
                        itemBuilder: (context, index) {
                          final game = state.trendingGames[index];
                          return Container(
                            width: 280,
                            margin: EdgeInsets.only(right: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                  game.imageUrl,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              children: [
                                if (game.players.isNotEmpty)
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.vertical(
                                          bottom: Radius.circular(16),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              for (int i = 0; i < 5; i++)
                                                SvgPicture.asset(
                                                  AppImages.icStarFill,
                                                  width: 16,
                                                  height: 16,
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            game.title,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            spacing: 8,
                                            children: [
                                              SvgPicture.asset(
                                                AppImages.icGame2,
                                                width: 12,
                                                height: 12,
                                                color: Colors.white70,
                                              ),
                                              Text(
                                                game.players,
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                else
                                  Positioned(
                                    bottom: 8,
                                    left: 8,
                                    child: Text(
                                      game.title,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),
                    ...List.generate(state.categoryItems.length, (index) {
                      return _buildGameSection(
                        context: context,
                        cate: state.categoryItems[index],
                        title: state.categoryItems[index].name ?? "",
                      );
                    }),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGameSection({
    required BuildContext context,
    required CategoryItem cate,
    required String title,
  }) {
    return Column(
      children: [
        viewAllHeader(title: title, onViewAll: () {}, context: context),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: cate.games?.length,
            itemBuilder: (context, index) {
              final game = cate.games?[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: _buildGameItem(game!, context),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBigButton(String title, String image, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String text, String icon) {
    return Container(
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.transparent),
      ),
      child: Row(
        children: [
          SvgPicture.asset(icon, width: 24, height: 24),
          const SizedBox(width: 8),
          Text(text, style: AppStyles.poppins12RegularCentered),
        ],
      ),
    );
  }

  Widget _buildGameItem(GameModel game, BuildContext context) {
    return GestureDetector(
      onTap: () {
        openMiniApp(context, game.link ?? "");
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SafeImage(
              url: game.iconUrl ?? '',
              width: 120,
              height: 120,
              fit: BoxFit.cover,
              placeholder: AppImages.imgGameDefault,
              errorAsset: AppImages.imgGameDefault,
            ),
          ),
          SizedBox(
            width: 120,
            child: Text(
              game.name ?? "--",
              textAlign: TextAlign.left,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.poppins12RegularCentered,
            ),
          ),
        ],
      ),
    );
  }
}
