import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/res/app_colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './loyalty_bloc.dart';

class LoyaltyPage extends StatefulWidget {
  const LoyaltyPage({super.key});

  @override
  State<LoyaltyPage> createState() => _LoyaltyPageState();
}

class _LoyaltyPageState extends State<LoyaltyPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final List<Map<String, dynamic>> coupons = [
    {
      'title': 'Plaza Premium Loung Normal',
      'discount': '25%',
      'points': 10,
      'exchanged': '12/200',
      'isFree': false,
    },
    {
      'title': 'Plaza Premium Loung Diamond',
      'discount': '40%',
      'points': null,
      'exchanged': '8/200',
      'isFree': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => LoyaltyBloc(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                left: 16,
                right: 16,
                bottom: 16,
              ),
              color: AppColors.colorMain,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu_sharp, color: Colors.white),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                  Text(
                    l10n.loyaltyPhoneNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Row(
                    children: [
                      Icon(Icons.card_giftcard, color: Colors.white),
                      SizedBox(width: 16),
                      Icon(Icons.history, color: Colors.white),
                      SizedBox(width: 16),
                      Icon(Icons.search, color: Colors.white),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(height: 250, color: AppColors.colorMain),
                        Column(
                          children: [
                            Container(
                              width: 140,
                              height: 140,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [Colors.red, Colors.orange],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  l10n.loyaltyPoints('0'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildTierItem(
                                  Icons.card_giftcard,
                                  l10n.loyaltyReward,
                                ),
                                _buildTierItem(
                                  Icons.sim_card_download,
                                  l10n.loyaltyTierBenefits,
                                  isCenter: true,
                                ),
                                _buildTierItem(
                                  Icons.history,
                                  l10n.loyaltyHistory,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.red,
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://via.placeholder.com/800x300?text=Khmer+Banner+Promotion',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          l10n.loyaltyBannerText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.loyaltyRewardCoupon,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(l10n.viewAll),
                          ),
                        ],
                      ),
                    ),

                    BlocBuilder<LoyaltyBloc, LoyaltyState>(
                      builder: (context, state) {
                        return CarouselSlider(
                          options: CarouselOptions(
                            height: 200,
                            viewportFraction: 0.55,
                            enlargeCenterPage: true,
                            onPageChanged: (index, reason) {
                              context.read<LoyaltyBloc>().add(
                                ChangeCouponIndexEvent(index),
                              );
                            },
                          ),
                          items:
                              coupons
                                  .map(
                                    (coupon) => _buildCouponCard(coupon, l10n),
                                  )
                                  .toList(),
                        );
                      },
                    ),

                    const SizedBox(height: 30),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.loyaltyVoucher,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(l10n.viewAll),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTierItem(IconData icon, String label, {bool isCenter = false}) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 30),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget _buildCouponCard(Map<String, dynamic> coupon, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 8),
        ],
      ),
      child: Column(
        children: [
          Text(
            l10n.loyaltyPlazaPremiumGroup,
            style: TextStyle(
              color: Colors.orange[700],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 60,
            color: Colors.grey[300],
            child: Center(child: Text(coupon['discount'] as String)),
          ),
          const SizedBox(height: 8),
          Text(
            coupon['title'] as String,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(l10n.loyaltyExchanged(coupon['exchanged'] as String)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (coupon['isFree'] == true)
                Text(
                  l10n.loyaltyFree,
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                )
              else
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 20),
                    Text(
                      '${coupon['points']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text(
                  l10n.loyaltyRedeem,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
