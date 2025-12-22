import 'package:cam_id/res/app_colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './entertainment_bloc.dart';

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

  @override
  Widget build(BuildContext context) {
    super.build(context); // Giữ state khi chuyển tab

    return BlocProvider(
      create: (_) => EntertainmentBloc(),
      child: Scaffold(
        body: Column(
          children: [
            // Header với nút menu
            Container(
              width: double.infinity,
              height: kToolbarHeight + MediaQuery.of(context).padding.top,
              color: AppColors.colorMain,
              alignment: Alignment.bottomLeft,
              child: IconButton(
                icon: const Icon(Icons.menu_sharp, color: Colors.white),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),

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
                        items:
                            bannerImages.map((url) {
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
                        children:
                            bannerImages.asMap().entries.map((entry) {
                              return Container(
                                width: 10,
                                height: 10,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      state.currentBannerIndex == entry.key
                                          ? AppColors.colorMain
                                          : Colors.grey,
                                ),
                              );
                            }).toList(),
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  // 3 nút dịch vụ
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildServiceButton(
                          icon: Icons.tv,
                          label: Applocalization.of(context)!.tv360,
                          color: Colors.redAccent,
                          onTap: () {
                            // TODO: Xử lý mở TV360
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Mở TV360')),
                            );
                          },
                        ),
                        _buildServiceButton(
                          icon: Icons.sports_esports,
                          label: 'Game',
                          color: Colors.green,
                          onTap: () {
                            // TODO: Xử lý mở Game
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Mở Game Center')),
                            );
                          },
                        ),
                        _buildServiceButton(
                          icon: Icons.extension,
                          label: 'VAS Service',
                          color: Colors.purple,
                          onTap: () {
                            // TODO: Xử lý mở VAS
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Mở VAS Service')),
                            );
                          },
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
  Widget _buildServiceButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color, width: 2),
            ),
            child: Icon(icon, size: 40, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
