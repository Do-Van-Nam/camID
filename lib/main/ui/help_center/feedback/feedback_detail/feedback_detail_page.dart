import 'package:cached_network_image/cached_network_image.dart';
import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/data/model/notify/notify_model.dart';
import 'package:cam_id/main/ui/help_center/feedback/feedback_page.dart';
import 'package:cam_id/main/utils/utility_fuctions.dart';
import 'package:cam_id/main/utils/widget/common_widgets.dart';
import 'package:cam_id/res/app_colors.dart';
import 'package:cam_id/res/app_images.dart';
import 'package:cam_id/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'feedback_detail_bloc.dart';

class FeedbackDetailPage extends StatefulWidget {
  const FeedbackDetailPage({super.key});

  @override
  State<FeedbackDetailPage> createState() => _FeedbackDetailPageState();
}

class _FeedbackDetailPageState extends State<FeedbackDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => NotificationDetailBloc()
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

          title: Text(l10n.feedbackDetail, style: AppStyles.header),
        ),
        body: BlocBuilder<NotificationDetailBloc, NotificationDetailState>(
          builder: (context, state) {
            if (state.isLoadingNews) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.newsNotifications.isEmpty) {
              return Center(
                child: _buildEmptyNoti(l10n),
              ); // "Không có thông báo"
            }
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          spacing: 16,
                          children: [
                            // tieu de feedback
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16),
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      buildStatusBadge("closed", l10n),
                                      Text(
                                        "ID: 1233",
                                        style: AppStyles.poppins12Regular
                                            .copyWith(
                                              color: AppColors.color_3231,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "tieu de feedback",
                                    style: AppStyles.header,
                                  ),
                                ],
                              ),
                            ),
                            // acc , sdt
                            commonContainer(
                              child: Row(
                                spacing: 16,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Column(
                                      spacing: 16,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          l10n.accountNumber,
                                          style: AppStyles.poppins12Regular
                                              .copyWith(
                                                fontSize: 14,
                                                color: AppColors.color_8588,
                                              ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: AppColors.color_F7F7,
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          child: Text(
                                            "1232132",
                                            style: AppStyles.poppins12Regular,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      spacing: 16,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          l10n.phoneNumber,
                                          style: AppStyles.poppins12Regular
                                              .copyWith(
                                                fontSize: 14,
                                                color: AppColors.color_8588,
                                              ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: AppColors.color_F7F7,
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          child: Text(
                                            "1232132",
                                            style: AppStyles.poppins12Regular,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // info
                            commonContainer(
                              child: Column(
                                spacing: 8,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          spacing: 4,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: Colors.pink[50],
                                              ),
                                              child: SvgPicture.asset(
                                                AppImages.icCalendar2,
                                                width: 24,
                                                height: 24,
                                              ),
                                            ),
                                            Text(
                                              l10n.receiveDate,
                                              style: AppStyles.poppins12Regular
                                                  .copyWith(
                                                    color: AppColors.color_8588,
                                                  ),
                                            ),
                                            Text(
                                              "12/12/2025",
                                              style: AppStyles.poppins14Medium,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          spacing: 4,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: Colors.pink[50],
                                              ),
                                              child: SvgPicture.asset(
                                                AppImages.icCalendar2,
                                                width: 24,
                                                height: 24,
                                              ),
                                            ),
                                            Text(
                                              l10n.expectedDeadline,
                                              style: AppStyles.poppins12Regular
                                                  .copyWith(
                                                    color: AppColors.color_8588,
                                                  ),
                                            ),
                                            Text(
                                              "12/12/2025",
                                              style: AppStyles.poppins14Medium,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    l10n.serviceType,
                                    style: AppStyles.poppins12Regular.copyWith(
                                      color: AppColors.color_8588,
                                    ),
                                  ),
                                  Text(
                                    "Wifi",
                                    style: AppStyles.poppins14Medium,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    l10n.error,
                                    style: AppStyles.poppins12Regular.copyWith(
                                      color: AppColors.color_8588,
                                    ),
                                  ),
                                  Text(
                                    "errrorrrrrr",
                                    style: AppStyles.poppins14Medium,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    l10n.feedback,
                                    style: AppStyles.poppins12Regular.copyWith(
                                      color: AppColors.color_8588,
                                    ),
                                  ),
                                  Text(
                                    "errrorrrrrr",
                                    style: AppStyles.poppins14Medium,
                                  ),
                                ],
                              ),
                            ),
                            //danh gia
                            commonContainer(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.evaluateQuality,
                                    style: AppStyles.header,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                // Action của bạn
                                              },
                                              style: TextButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      // horizontal: 16,
                                                      vertical: 12,
                                                    ),
                                                backgroundColor: Colors
                                                    .transparent, // Đảm bảo trong suốt
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize
                                                    .min, // Để button không dãn hết chiều ngang
                                                children: [
                                                  SvgPicture.asset(
                                                    AppImages.icRadioBtn,
                                                    width: 20,
                                                    height: 20,
                                                  ),
                                                  const SizedBox(
                                                    width: 8,
                                                  ), // Khoảng cách giữa icon và text
                                                  Text(
                                                    l10n.satisfy,
                                                    style: AppStyles
                                                        .poppins12Regular
                                                        .copyWith(
                                                          color: AppColors
                                                              .color_0000,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                // Action của bạn
                                              },
                                              style: TextButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      // horizontal: 16,
                                                      vertical: 12,
                                                    ),
                                                backgroundColor: Colors
                                                    .transparent, // Đảm bảo trong suốt
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize
                                                    .min, // Để button không dãn hết chiều ngang
                                                children: [
                                                  SvgPicture.asset(
                                                    AppImages.icRadioBtnTicked,
                                                    width: 20,
                                                    height: 20,
                                                  ),
                                                  const SizedBox(
                                                    width: 8,
                                                  ), // Khoảng cách giữa icon và text
                                                  Text(
                                                    l10n.notSatisfy,
                                                    style: AppStyles
                                                        .poppins12Regular
                                                        .copyWith(
                                                          color: AppColors
                                                              .color_0000,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    commonButton(text: l10n.close, onPressed: () {}),
                  ],
                ),
              ),
            );
          },
        ),
      ),
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

  Widget _buildDetailItem(String title, String content) {
    return Column(
      spacing: 8,
      children: [
        Text(
          title,
          style: AppStyles.poppins12Regular.copyWith(
            color: AppColors.color_464B,
          ),
        ),
        Text(
          content,
          style: AppStyles.header.copyWith(
            fontSize: 14,
            color: AppColors.colorMain,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
