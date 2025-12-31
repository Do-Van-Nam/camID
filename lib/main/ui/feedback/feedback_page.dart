import 'package:cam_id/main/utils/widget/common_widgets.dart';
import 'package:cam_id/res/app_colors.dart';
import 'package:cam_id/res/app_fonts.dart';
import 'package:cam_id/res/app_images.dart';
import 'package:cam_id/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cam_id/generated/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'feedback_bloc.dart';
import 'feedback_event.dart';
import 'feedback_state.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy AppLocalizations
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => FeedbackBloc(),
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

          title: Text(l10n.feedbackTitleLabel, style: AppStyles.header),
        ),
        // "Phản hồi & Đánh giá"
        body: BlocConsumer<FeedbackBloc, FeedbackState>(
          listener: (context, state) {
            if (state.submitSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.feedbackThankYou),
                ), // "Cảm ơn phản hồi của bạn!"
              );
            }
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,

                            margin: const EdgeInsets.only(top: 8),
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
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Color(0x14FDB913),
                                  child: ClipOval(
                                    child: SvgPicture.asset(
                                      AppImages.icStar,
                                      width: 32,
                                      height: 32,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    l10n.wifiFeedbackTitle, // "Chúng tôi rất mong nhận được phản hồi từ bạn để cải thiện ứng dụng."
                                    style: AppStyles.poppins12Regular.copyWith(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,

                            margin: const EdgeInsets.only(top: 8),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 8,
                              children: [
                                Text(
                                  l10n.rateYourExperience, // "Bạn đánh giá trải nghiệm tổng thể của ứng dụng như thế nào?"
                                  style: AppStyles.header,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  width: double.infinity,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    color: AppColors.color_F7F7F7,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    spacing: 8,
                                    children: [
                                      Text(l10n.satisfactionLevel),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          _buildSatificationItem(
                                            1,
                                            state.satisLv,
                                            AppImages.icSatification1,
                                            AppImages.icSatification1Active,
                                            "label",
                                            () {
                                              context.read<FeedbackBloc>().add(
                                                SatisficationLevelChanged(1),
                                              );
                                            },
                                          ),
                                          _buildSatificationItem(
                                            2,
                                            state.satisLv,
                                            AppImages.icSatification2,
                                            AppImages.icSatification2Active,
                                            "label",
                                            () {
                                              context.read<FeedbackBloc>().add(
                                                SatisficationLevelChanged(2),
                                              );
                                            },
                                          ),
                                          _buildSatificationItem(
                                            3,
                                            state.satisLv,
                                            AppImages.icSatification3,
                                            AppImages.icSatification3Active,
                                            "label",
                                            () {
                                              context.read<FeedbackBloc>().add(
                                                SatisficationLevelChanged(3),
                                              );
                                            },
                                          ),
                                          _buildSatificationItem(
                                            4,
                                            state.satisLv,
                                            AppImages.icSatification4,
                                            AppImages.icSatification4Active,
                                            "label",
                                            () {
                                              context.read<FeedbackBloc>().add(
                                                SatisficationLevelChanged(4),
                                              );
                                            },
                                          ),
                                          _buildSatificationItem(
                                            5,
                                            state.satisLv,
                                            AppImages.icSatification5,
                                            AppImages.icSatification5Active,
                                            "label",
                                            () {
                                              context.read<FeedbackBloc>().add(
                                                SatisficationLevelChanged(5),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                _buildRatingStarItem(
                                  l10n.speedOfInternet,
                                  "speed",
                                  context,
                                  state,
                                ),
                                _buildRatingStarItem(
                                  l10n.price,
                                  "price",
                                  context,
                                  state,
                                ),
                                _buildRatingStarItem(
                                  l10n.customerService,
                                  "customerService",
                                  context,
                                  state,
                                ),
                                _buildRatingStarItem(
                                  l10n.technicalSupport,
                                  "technical",
                                  context,
                                  state,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppColors.color_F7F7F7,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: TextField(
                                    maxLines: 6,
                                    decoration: InputDecoration(
                                      hintText: l10n
                                          .enterYourExperience, // "Nội dung chi tiết"
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                    onChanged: (value) => context
                                        .read<FeedbackBloc>()
                                        .add(ContentChanged(value)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: commonButton(
                      text: l10n.feedbackSubmitButton,
                      onPressed: () {},
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

  Widget _buildSatificationItem(
    double id,
    double satisLv,
    String imagePath,
    String imageActive,
    String label,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: CircleAvatar(
              backgroundColor: id == satisLv
                  ? AppColors.color_F7A8AA
                  : Colors.transparent,
              child: Image.asset(
                id == satisLv ? imageActive : imagePath,
                width: 32,
                height: 32,
                fit: BoxFit.contain,
              ),
            ),
          ),
          id == satisLv
              ? Container(
                  width: 48,
                  height: 24,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Đặt ảnh làm lớp nền
                      SvgPicture.asset(
                        AppImages.icRedLabel,
                        width: 48,
                        height: 24,
                        fit: BoxFit
                            .contain, // Dùng fill để ảnh ép đúng vào khung 48x24
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.yellow,
                          ); // Nếu hiện màu đỏ là do sai đường dẫn ảnh
                        },
                      ),
                      // Đặt chữ lên trên
                      Positioned(
                        bottom: 2,
                        child: Text(
                          label,
                          style: AppStyles.poppins12Regular.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildRatingStarItem(
    String label,
    String type,
    BuildContext context,
    FeedbackState state,
  ) {
    double rate = type == 'speed'
        ? state.speedRate
        : type == 'price'
        ? state.priceRate
        : type == 'customerService'
        ? state.customerServiceRate
        : state.technicalRate;
    return Row(
      children: [
        Text(
          label, // "Đánh giá bằng sao"
          style: AppStyles.poppins12Regular.copyWith(fontSize: 16),
        ),
        Spacer(),
        RatingBar.builder(
          initialRating: rate,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: false,
          itemCount: 5,
          itemSize: 24,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          unratedColor: Colors.amberAccent,
          itemBuilder: (context, index) {
            if (index < rate) {
              return SvgPicture.asset(AppImages.icStarRateFill);
              // return SvgPicture.asset(AppImages.icStarRateEmpty);
            } else {
              return SvgPicture.asset(
                AppImages.icStarRateEmpty,
                // AppImages.icStarRateEmpty, // Asset cho sao chưa đánh dấu
              );
            }
          },
          onRatingUpdate: (rating) {
            context.read<FeedbackBloc>().add(RateChanged(rating, type));
          },
        ),
      ],
    );
  }
}
