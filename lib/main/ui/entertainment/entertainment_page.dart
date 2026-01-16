import 'package:cached_network_image/cached_network_image.dart';
import 'package:cam_id/main/data/model/banner_model.dart';
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
import '../miniapp/mini_app_bloc.dart';
import '../miniapp/mini_app_event.dart';
import './entertainment_bloc.dart';
import 'package:cam_id/generated/app_localizations.dart';

import 'entertainment_state.dart';

class EntertainmentPage extends StatefulWidget {
  const EntertainmentPage({super.key});

  @override
  State<EntertainmentPage> createState() => _EntertainmentPageState();
}

class _EntertainmentPageState extends State<EntertainmentPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final List<String> bannerImages = [
    'https://cdn2.fptshop.com.vn/unsafe/1920x0/filters:format(webp):quality(75)/2023_10_15_638329878567586819_banner-la-gi-0.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQw6pCNJ7d7fAjcMTbeMORb2pvpEPyDn6WOeg&s',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQpTQZ2ymiyWERMbA6iLXtu-GdpqGqVpWKlLg&s',
    'https://www.shutterstock.com/image-vector/yellow-ribbons-set-isolated-white-260nw-2605249181.jpg',
  ];
  void openMiniApp(BuildContext context, String url) {
    context.read<MiniAppBloc>().add(MiniAppLoadUrl("$url?token=JWT"));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Giữ state khi chuyển tab
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (_) => EntertainmentBloc()..add(GetBannerEvent()),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,

          leading: GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Container(
              margin: const EdgeInsets.only(left: 16),
              width: 32,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(AppImages.icDrawerMenu),
              ),
            ),
          ),

          actions: [
            IconButton(
              icon: SvgPicture.asset(
                AppImages.icNotification,
                width: 24,
                height: 24,
              ),
              onPressed: () {
                context.push(PATH_NOTIFICATION);
              },
            ),
            IconButton(
              icon: SvgPicture.asset(AppImages.icSearch, width: 24, height: 24),
              onPressed: () {
                context.push(PATH_SEARCH);
              },
            ),

            SizedBox(width: 16),
          ],
        ),

        body: BlocBuilder<EntertainmentBloc, EntertainmentState>(
          builder: (context, state) {
            // if (state.isLoading) {
            //   return const Center(child: CircularProgressIndicator());
            // }

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                spacing: 16,
                children: [
                  // Banner carousel + indicator
                  Stack(
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 250,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 4),
                          viewportFraction: 1.05,
                          enlargeCenterPage: true,
                          onPageChanged: (index, reason) {
                            context.read<EntertainmentBloc>().add(
                              ChangeBannerEvent(index),
                            );
                          },
                        ),
                        items: state.bannerHeaderList.map((banner) {
                          return Builder(
                            builder: (BuildContext context) {
                              return CachedNetworkImage(
                                imageUrl: banner.adImgUrl ?? "1",
                                // 1. Placeholder: Hiển thị khi đang tải
                                placeholder: (context, url) => Image.asset(
                                  AppImages.imgEntertainmentDefault,
                                ),
                                // 2. ErrorWidget: Hiển thị khi lỗi
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                      AppImages.imgEntertainmentDefault,
                                    ),
                                // 3. ImageBuilder: Lắp ảnh vào BoxDecoration sau khi tải xong
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 5.0,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(24),
                                          bottomRight: Radius.circular(24),
                                        ),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                              );
                            },
                          );
                        }).toList(),
                      ),

                      Column(
                        children: [
                          const SizedBox(height: 160),
                          // Dấu chấm indicator
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: state.bannerHeaderList
                                .asMap()
                                .entries
                                .map((entry) {
                                  return Container(
                                    width: state.currentBannerIndex == entry.key
                                        ? 16
                                        : 6,
                                    height: 6,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color:
                                          state.currentBannerIndex == entry.key
                                          ? Colors.white
                                          : Colors.grey,
                                    ),
                                  );
                                })
                                .toList(),
                          ),

                          Container(
                            margin: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                              top: 8,
                            ),
                            padding: const EdgeInsets.all(16),
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
                            child: Column(
                              spacing: 16,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildServiceButton(
                                      AppImages.icTV360,
                                      l10n.tv360,
                                      () {
                                        openMiniApp(
                                          context,
                                          "https://www.24h.com.vn/",
                                        );
                                      },
                                    ),
                                    _buildServiceButton(
                                      AppImages.icVas,
                                      l10n.vasService,
                                      () async {
                                        openMiniApp(
                                          context,
                                          "https://www.24h.com.vn/",
                                        );
                                      },
                                    ),
                                    _buildServiceButton(
                                      AppImages.icGame,
                                      l10n.game,
                                      () {
                                        context.push(PATH_GAME);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  viewAllHeader(
                    title: l10n.tv360,
                    onViewAll: () {
                      openMiniApp(context, "https://tv360.metfone.com.kh/en");
                    },
                    context: context,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...state.listTv360
                            .map(
                              (item) => Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: _buildTv360Item(item),
                              ),
                            )
                            .toList(),
                        const Padding(padding: EdgeInsets.only(right: 16.0)),
                      ],
                    ),
                  ),
                  viewAllHeader(
                    title: l10n.game,
                    onViewAll: () => context.push(PATH_GAME),
                    context: context,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...state.listGame
                            .map(
                              (item) => Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: _buildGameItem(item),
                              ),
                            )
                            .toList(),
                        const Padding(padding: EdgeInsets.only(right: 16.0)),
                      ],
                    ),
                  ),
                  viewAllHeader(
                    title: l10n.vasService,
                    onViewAll: () {},
                    context: context,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 16, right: 16, top: 8),
                    padding: const EdgeInsets.all(16),
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
                    child: Column(
                      spacing: 16,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTVasItem(state.listVas[0]),
                            _buildTVasItem(state.listVas[1]),
                            _buildTVasItem(state.listVas[2]),
                            _buildTVasItem(state.listVas[3]),
                          ],
                        ),
                      ],
                    ),
                  ),

                  footerBanner(
                    banners: state.bannerFooterList,
                    context: context,
                    currentIndex: state.currentFooterBannerIndex,
                    onPageChanged: (index, reason) {
                      context.read<EntertainmentBloc>().add(
                        ChangeFooterBannerEvent(index),
                      );
                    },
                  ),
                  SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget footerBanner({
    required List<AdsModel> banners,
    required BuildContext context,
    required int currentIndex,
    required Function(int, CarouselPageChangedReason) onPageChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        spacing: 8,
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 150,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              viewportFraction: 1,
              enlargeCenterPage: true,
              onPageChanged: onPageChanged,
            ),
            items: banners.map((banner) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SafeImage(
                  url: banner.adImgUrl,
                  placeholder: AppImages.imgEntertainmentDefault,
                  errorAsset: AppImages.imgEntertainmentDefault,
                ),
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: banners.asMap().entries.map((entry) {
              return Container(
                width: currentIndex == entry.key ? 16 : 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: currentIndex == entry.key ? Colors.black : Colors.grey,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Widget nút dịch vụ
  Widget _buildServiceButton(String icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.pink[50],
            ),
            child: SvgPicture.asset(icon, width: 24, height: 24),
          ),
          const SizedBox(height: 8),
          Container(
            width: 90,
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: AppStyles.poppins12Regular.copyWith(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTv360Item(AdsModel item) {
    return GestureDetector(
      onTap: () {
        openMiniApp(context, "https://tv360.metfone.com.kh/en");
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SafeImage(
                  url: item.adImgUrl,
                  placeholder: AppImages.imgFilmDefault,
                  errorAsset: AppImages.imgFilmDefault,
                  height: 200,
                  width: 160,
                ),
              ),

              // Positioned(
              //   left: 8,
              //   bottom: 8,
              //   child: Container(
              //     constraints: const BoxConstraints(maxWidth: 140),
              //     padding: const EdgeInsets.symmetric(
              //       horizontal: 8,
              //       vertical: 4,
              //     ),
              //     decoration: BoxDecoration(
              //       color: Colors.black.withOpacity(0.6),
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //     child: Text(
              //       item.sourceLink ?? "--",
              //       style: const TextStyle(color: Colors.white, fontSize: 12),
              //       maxLines: 1,
              //       overflow: TextOverflow.ellipsis,
              //     ),
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 160,
            child: Text(
              item.des ?? "--",
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

  Widget _buildTVasItem(AdsModel item) {
    return GestureDetector(
      onTap: () {
        // Xử lý khi nhấn vào item
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SafeImage(
              url: item.adImgUrl,
              placeholder: AppImages.imgGameDefault,
              errorAsset: AppImages.imgGameDefault,
              height: 60,
              width: 60,
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(
              item.des ?? "--",
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

  Widget _buildGameItem(AdsModel item) {
    return Stack(
      alignment: AlignmentGeometry.center,
      children: [
        Column(
          children: [
            SizedBox(height: 8),
            Container(
              width: 120,
              height: 120,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                // Thay color bằng gradient
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFFF4F4), // #FFF4F4
                    Color(0xFFFDEDEE), // #FDEDEE
                  ],
                ),

                borderRadius: const BorderRadius.all(Radius.circular(16)),
                border: Border.all(color: AppColors.color_F7A8, width: 1),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
            ),
          ],
        ),
        Column(
          children: [
            // Ảnh game (bo góc trên)
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              child: SafeImage(
                url: item.adImgUrl,
                placeholder: AppImages.imgGameDefault,
                errorAsset: AppImages.imgGameDefault,
                height: 80,
                width: 80,
              ),
            ),

            // Phần dưới: tên + nút Play
            SizedBox(
              width: 100,
              child: Text(
                item.des ?? "--",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 12),

            // Nút Play đỏ
            SizedBox(
              width: 80,
              height: 40,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Play',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 4),
          ],
        ),
      ],
    );
  }
}
