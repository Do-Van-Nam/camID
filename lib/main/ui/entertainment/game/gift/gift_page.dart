import 'package:cached_network_image/cached_network_image.dart';
import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/data/model/notify/notify_model.dart';
import 'package:cam_id/main/utils/utility_fuctions.dart';
import 'package:cam_id/main/utils/widget/common_widgets.dart';
import 'package:cam_id/res/app_colors.dart';
import 'package:cam_id/res/app_images.dart';
import 'package:cam_id/res/app_styles.dart';
import 'package:cam_id/router.dart';
import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'gift_bloc.dart';

class GiftPage extends StatefulWidget {
  const GiftPage({super.key});

  @override
  State<GiftPage> createState() => _GiftPageState();
}

class _GiftPageState extends State<GiftPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => GiftBloc()
        ..add(LoadNewsNotifications())
        ..add(LoadComplainNotifications()),
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

          title: Text(l10n.myGift, style: AppStyles.header),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(56),

            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),

                decoration: BoxDecoration(
                  color: AppColors.color_5F5F,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TabBar(
                  // padding: const EdgeInsets.symmetric(
                  //   horizontal: 16,
                  //   vertical: 8,
                  // ),
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  indicatorColor: Colors.grey,
                  dividerColor: Colors.transparent,
                  // Tùy chỉnh kích thước indicator
                  indicatorSize:
                      TabBarIndicatorSize.tab, // Tắt indicator mặc định
                  labelColor: Colors.white, // Chữ tab được chọn: trắng
                  unselectedLabelColor: Colors.black, // Chữ tab không chọn: xám
                  tabs: [
                    Tab(child: Text(l10n.prizeList)),
                    Tab(child: Text(l10n.myPrize)),
                    Tab(child: Text(l10n.history)),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildPrizeListTab(l10n),
            _buildMyPrizeTab(l10n),
            _buildHistoryTab(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildPrizeListTab(AppLocalizations l10n) {
    return BlocBuilder<GiftBloc, GiftState>(
      builder: (context, state) {
        if (state.isLoadingNews) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.newsNotifications.isEmpty) {
          return Center(child: _buildEmptyNoti(l10n)); // "Không có thông báo"
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ListView.builder(
              shrinkWrap:
                  true, // Quan trọng: Yêu cầu ListView chỉ chiếm không gian vừa đủ
              physics:
                  const NeverScrollableScrollPhysics(), // Tắt cuộn riêng của ListView
              itemCount: state.newsNotifications.length,
              itemBuilder: (context, index) {
                final noti = state.newsNotifications[index];
                return _buildPrizeCard(
                  noti,
                  context,
                  index < state.newsNotifications.length - 1,
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildMyPrizeTab(AppLocalizations l10n) {
    return BlocBuilder<GiftBloc, GiftState>(
      builder: (context, state) {
        if (state.isLoadingNews) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.newsNotifications.isEmpty) {
          return Center(child: _buildEmptyNoti(l10n)); // "Không có thông báo"
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ListView.builder(
              shrinkWrap:
                  true, // Quan trọng: Yêu cầu ListView chỉ chiếm không gian vừa đủ
              physics:
                  const NeverScrollableScrollPhysics(), // Tắt cuộn riêng của ListView
              itemCount: state.newsNotifications.length,
              itemBuilder: (context, index) {
                final noti = state.newsNotifications[index];
                return _buildMyPrizeCard(
                  noti,
                  context,
                  index < state.newsNotifications.length - 1,
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildHistoryTab(AppLocalizations l10n) {
    return BlocBuilder<GiftBloc, GiftState>(
      builder: (context, state) {
        if (state.isLoadingNews) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.newsNotifications.isEmpty) {
          return Center(child: _buildEmptyNoti(l10n)); // "Không có thông báo"
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ListView.builder(
              shrinkWrap:
                  true, // Quan trọng: Yêu cầu ListView chỉ chiếm không gian vừa đủ
              physics:
                  const NeverScrollableScrollPhysics(), // Tắt cuộn riêng của ListView
              itemCount: state.newsNotifications.length,
              itemBuilder: (context, index) {
                final noti = state.newsNotifications[index];
                return _buildHistoryCard(
                  noti,
                  context,
                  index < state.newsNotifications.length - 1,
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildPrizeCard(
    NotificationItem noti,
    BuildContext context,
    bool hasBottomBorder,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          // Phần Header (Ảnh + Title)
          Row(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl:
                      'https://cdn2.fptshop.com.vn/unsafe/1920x0/filters:format(webp):quality(75)/2023_10_15_638329878567586819_banner-la-gi-0.jpg',
                  height: 76,
                  width: 76,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(
                      noti.title,
                      style: TextStyle(
                        fontWeight: noti.isRead
                            ? FontWeight.normal
                            : FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      noti.message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.prizeList,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  AppLocalizations.of(context)!.viewAll,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(
            height: 64, // Cao hơn item một chút để không bị cấn Shadow
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              separatorBuilder: (context, index) =>
                  const SizedBox(width: 12), // Tạo khoảng cách giữa các ô
              itemBuilder: (context, index) {
                return _buildPrizeItem();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyPrizeCard(
    NotificationItem noti,
    BuildContext context,
    bool hasBottomBorder,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Row(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl:
                      'https://cdn2.fptshop.com.vn/unsafe/1920x0/filters:format(webp):quality(75)/2023_10_15_638329878567586819_banner-la-gi-0.jpg',
                  height: 36,
                  width: 36,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              Expanded(
                child: Text(noti.title, style: AppStyles.poppins12Regular),
              ),
            ],
          ),
          DottedDashedLine(
            height: 0.5,
            width: double.infinity,
            dashColor: AppColors.color_8588,
            axis: Axis.horizontal,
            dashSpace: 12,
            dashWidth: 12,
          ),

          Row(
            spacing: 8,
            children: [
              _buildPrizeItem(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Text("iphone", style: AppStyles.poppins14Medium),

                    Row(
                      children: [
                        SvgPicture.asset(AppImages.icCalendarCircle),
                        Text(
                          "1/2/2025 5:12",
                          style: AppStyles.poppins12Regular,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 120,
                child: commonButton(text: "Redeem", onPressed: () {}),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(
    NotificationItem noti,
    BuildContext context,
    bool hasBottomBorder,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        spacing: 8,
        children: [
          _buildPrizeItem(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text("iphone", style: AppStyles.poppins14Medium),

                Row(
                  children: [
                    SvgPicture.asset(AppImages.icCalendarCircle),
                    Text("1/2/2025 5:12", style: AppStyles.poppins12Regular),
                  ],
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl:
                  'https://cdn2.fptshop.com.vn/unsafe/1920x0/filters:format(webp):quality(75)/2023_10_15_638329878567586819_banner-la-gi-0.jpg',
              height: 64,
              width: 64,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrizeItem() {
    return Container(
      width: 60,
      height: 60,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFF4F4), Color(0xFFFDEDEE)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: const Center(child: Text("Prize Item")), // Thêm con cho đỡ trống
    );
  }

  Widget _buildEmptyNoti(l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppImages.imgEmptyNoti),
          Text(
            l10n.noNotiTitle,
            style: AppStyles.poppins12Regular.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
