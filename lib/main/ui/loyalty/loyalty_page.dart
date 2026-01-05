import 'package:cached_network_image/cached_network_image.dart';
import 'package:cam_id/app.dart';
import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/data/model/reward_model.dart';
import 'package:cam_id/main/utils/widget/common_widgets.dart';
import 'package:cam_id/res/app_fonts.dart';
import 'package:cam_id/res/app_images.dart';
import 'package:cam_id/res/app_styles.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import './loyalty_bloc.dart';

class LoyaltyPage extends StatelessWidget {
  const LoyaltyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => LoyaltyBloc()..add(LoadLoyaltyData()),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Image.asset(
            AppImages.chatbotBG,
            fit: BoxFit.cover,
            alignment: Alignment.topLeft,
          ),
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

          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("ten nguoi dung", style: AppStyles.poppins12Regular),
                  SvgPicture.asset(
                    AppImages.icWhiteRightArrow,
                    width: 24,
                    height: 24,
                  ),
                ],
              ),
              Text(
                "so dien thoai",
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: SvgPicture.asset(AppImages.icSearch, width: 24, height: 24),
              onPressed: () {
                // Xử lý khi nhấn vào biểu tượng thông báo
              },
            ),
            IconButton(
              icon: SvgPicture.asset(
                AppImages.icChartSquare,
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
        backgroundColor: Colors.grey[100],
        body: BlocBuilder<LoyaltyBloc, LoyaltyState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Stack(
              children: [
                // Background chat
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Image.asset(AppImages.chatbotBG, fit: BoxFit.fitWidth),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 160),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      // Points card
                      SizedBox(height: 120),
                      Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 230,
                            margin: const EdgeInsets.only(top: 40),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                            ),
                          ),
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
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SvgPicture.asset(
                                      AppImages.icCamIDLogo,
                                      width: 32,
                                      height: 32,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            24,
                                          ),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SvgPicture.asset(
                                            AppImages.icBronzeBadge,
                                            width: 18,
                                            height: 18,
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            "bronze",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          SvgPicture.asset(
                                            AppImages.icWhiteRightArrow,
                                            width: 16,
                                            height: 16,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFFEF4F6),
                                        Color(0xFFFDE2E6),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.loyaltyPoints(state.points),
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        l10n.loyaltyNextTier(
                                          state.nextTierPoints,
                                        ),
                                      ),
                                      LinearProgressIndicator(
                                        value:
                                            state.points /
                                            (state.points +
                                                state.nextTierPoints),
                                        backgroundColor: Colors.grey[300],
                                        valueColor:
                                            const AlwaysStoppedAnimation(
                                              Colors.red,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 16),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            AppImages.icCrown,
                                            width: 20,
                                            height: 20,
                                          ),
                                          SizedBox(width: 4),
                                          Text(l10n.loyaltyTierBenefits),
                                        ],
                                      ),
                                      Container(
                                        width: 1,
                                        height: 24,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        color: Colors.grey[400],
                                      ),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            AppImages.icHistory,
                                            width: 20,
                                            height: 20,
                                          ),
                                          SizedBox(width: 4),
                                          Text(l10n.loyaltyHistory),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      Container(
                        decoration: BoxDecoration(color: Colors.white),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),

                            // Reward title
                            viewAllHeader(
                              title: l10n.loyaltyReward,
                              onViewAll: () {},
                              context: context,
                            ),

                            const SizedBox(height: 10),

                            // Category icons
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  // mainAxisAlignment:
                                  //     MainAxisAlignment.spaceEvenly,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _categoryIcon(
                                      AppImages.icShop,
                                      l10n.loyaltyShopping,
                                    ),
                                    SizedBox(width: 16),
                                    _categoryIcon(
                                      AppImages.icFood,

                                      l10n.loyaltyRestaurantHotel,
                                    ),
                                    SizedBox(width: 16),
                                    _categoryIcon(
                                      AppImages.icHeart,
                                      l10n.loyaltyHealthCare,
                                    ),
                                    SizedBox(width: 16),
                                    _categoryIcon(
                                      AppImages.icAirplane,
                                      l10n.loyaltyTravel,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Reward - Coupon
                            viewAllHeader(
                              title: l10n.loyaltyRewardCoupon,
                              onViewAll: () {},
                              context: context,
                            ),

                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Row(
                                children: state.coupons
                                    .map(
                                      (coupon) => Container(
                                        width: 260,
                                        margin: const EdgeInsets.only(
                                          right: 12,
                                        ),
                                        child: _buildCouponCard(coupon, l10n),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Banner quảng cáo (text nếu cần dịch)
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              height: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    "https://via.placeholder.com/800x300?text=1\$+=+2500\$",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  l10n.loyaltyBannerPromotion, // Nếu muốn dịch banner text
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Voucher title
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    l10n.loyaltyVoucher,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    l10n.viewAll,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 10),

                            // Voucher grid
                            SizedBox(
                              height:
                                  320, // Chiều cao cố định – điều chỉnh theo kích thước card của bạn
                              child: GridView.builder(
                                scrollDirection: Axis.horizontal, // Cuộn ngang
                                physics:
                                    const BouncingScrollPhysics(), // Cuộn mượt (iOS style) hoặc ClampingScrollPhysics()
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      2, // 2 hàng (vì cuộn ngang → crossAxis là chiều dọc)
                                  childAspectRatio:
                                      0.45, // Tỷ lệ width/height của mỗi card (tùy chỉnh cho đẹp)
                                  crossAxisSpacing:
                                      16, // Khoảng cách dọc giữa 2 voucher trong cùng cột
                                  mainAxisSpacing:
                                      16, // Khoảng cách ngang giữa các cột khi cuộn
                                ),
                                itemCount: state.coupons.length,
                                itemBuilder: (context, index) {
                                  return _buildVoucherCard(
                                    state.coupons[index],
                                    l10n,
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 50),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _categoryIcon(String icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.pink[50],
          child: SvgPicture.asset(icon, width: 24, height: 24),
        ),
        const SizedBox(height: 8),
        Container(
          width: 72,
          child: Text(label, textAlign: TextAlign.center, maxLines: 2),
        ),
      ],
    );
  }

  Widget _buildCouponCard(RewardCoupon coupon, AppLocalizations l10n) {
    return Container(
      width: 150,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            child: CachedNetworkImage(
              imageUrl: coupon.imageUrl,
              placeholder: (context, url) =>
                  CircularProgressIndicator(), // Đang tải
              errorWidget: (context, url, error) =>
                  Icon(Icons.error, color: Colors.red), // Lỗi
              fit: BoxFit.cover,
              width: double.infinity,
              height: 160,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coupon.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    SvgPicture.asset(AppImages.icCoin, width: 24, height: 24),
                    Text("${coupon.points}"),
                  ],
                ),
                const SizedBox(height: 8),
                Stack(
                  children: [
                    LinearProgressIndicator(
                      minHeight: 18,
                      borderRadius: BorderRadius.circular(16),
                      value: coupon.exchanged / (coupon.total),
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation(Colors.red),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        spacing: 4,
                        children: [
                          SvgPicture.asset(
                            AppImages.icLightning,
                            width: 16,
                            height: 16,
                          ),
                          Text(
                            l10n.loyaltyExchanged(
                              coupon.exchanged,
                              coupon.total,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Spacer(),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Colors.black,
                          width: 2,
                        ), // Viền đen, độ dày 2
                        foregroundColor:
                            Colors.black, // Màu chữ + icon (quan trọng nhất!)
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            30,
                          ), // Bo góc nếu muốn
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ), // Tùy chỉnh padding
                      ),
                      onPressed: () {},
                      child: Text(l10n.loyaltyRedeem),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherCard(RewardCoupon coupon, AppLocalizations l10n) {
    return Container(
      width: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: CachedNetworkImage(
              imageUrl: coupon.imageUrl,
              placeholder: (context, url) =>
                  CircularProgressIndicator(), // Đang tải
              errorWidget: (context, url, error) =>
                  Icon(Icons.error, color: Colors.red), // Lỗi
              fit: BoxFit.cover,
              width: 160,
              height: 160,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(coupon.title),
                const SizedBox(height: 8),

                Row(
                  children: [
                    SvgPicture.asset(AppImages.icCoin, width: 24, height: 24),
                    Text("${coupon.points}"),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Colors.black,
                          width: 2,
                        ), // Viền đen, độ dày 2
                        foregroundColor:
                            Colors.black, // Màu chữ + icon (quan trọng nhất!)
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            30,
                          ), // Bo góc nếu muốn
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ), // Tùy chỉnh padding
                      ),
                      onPressed: () {},
                      child: Text(l10n.loyaltyRedeem),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
