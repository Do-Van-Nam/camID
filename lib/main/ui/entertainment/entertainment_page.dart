import 'package:cam_id/res/app_colors.dart';
import 'package:cam_id/res/app_fonts.dart';
import 'package:cam_id/res/app_images.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../miniapp/mini_app_bloc.dart';
import '../miniapp/mini_app_event.dart';
import './entertainment_bloc.dart';
import 'package:cam_id/generated/app_localizations.dart';

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
      create: (_) => EntertainmentBloc(),
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
                // Xử lý khi nhấn vào biểu tượng thông báo
              },
            ),
            IconButton(
              icon: SvgPicture.asset(AppImages.icSearch, width: 24, height: 24),
              onPressed: () {
                // Xử lý khi nhấn vào biểu tượng thông báo
              },
            ),

            SizedBox(width: 16),
          ],
        ),

        body: Column(
          children: [
            // Banner carousel + indicator
            Expanded(
              child: Column(
                children: [
                  // Carousel Slider
                  BlocBuilder<EntertainmentBloc, EntertainmentState>(
                    builder: (context, state) {
                      return CarouselSlider(
                        options: CarouselOptions(
                          height: 200,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 4),
                          viewportFraction: 0.95,
                          enlargeCenterPage: true,
                          onPageChanged: (index, reason) {
                            context.read<EntertainmentBloc>().add(
                              ChangeBannerEvent(index),
                            );
                          },
                        ),
                        items: bannerImages.map((url) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: NetworkImage(url),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Dấu chấm indicator
                  BlocBuilder<EntertainmentBloc, EntertainmentState>(
                    builder: (context, state) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: bannerImages.asMap().entries.map((entry) {
                          return Container(
                            width: 10,
                            height: 10,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: state.currentBannerIndex == entry.key
                                  ? AppColors.colorMain
                                  : Colors.grey,
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),

                  const SizedBox(height: 32),
                  Container(
                    margin: const EdgeInsets.all(16),
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
                            _buildServiceButton(
                              AppImages.icTV360,
                              l10n.tv360,
                              () {
                                openMiniApp(context, "https://www.24h.com.vn/");
                              },
                            ),
                            _buildServiceButton(
                              AppImages.icVas,
                              l10n.vasService,
                              () async {
                                openMiniApp(context, "https://www.24h.com.vn/");
                              },
                            ),
                            _buildServiceButton(
                              AppImages.icGame,
                              l10n.game,
                              () async {
                                openMiniApp(context, "https://www.24h.com.vn/");
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ],
        ),
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
              style: AppTextFonts.poppins12RegularCentered,
            ),
          ),
        ],
      ),
    );
  }
}
