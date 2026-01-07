import 'package:cached_network_image/cached_network_image.dart';
import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/data/model/notify/notify_model.dart';
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
import 'notification_detail_bloc.dart';

class NotificationDetailPage extends StatefulWidget {
  const NotificationDetailPage({super.key});

  @override
  State<NotificationDetailPage> createState() => _NotificationDetailPageState();
}

class _NotificationDetailPageState extends State<NotificationDetailPage>
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

          title: Text(l10n.detail, style: AppStyles.header),
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
                        child: Container(
                          width: double.infinity,

                          // margin: const EdgeInsets.all(8),
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
                            spacing: 16,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "https://cdn2.fptshop.com.vn/unsafe/1920x0/filters:format(webp):quality(75)/2023_10_15_638329878567586819_banner-la-gi-0.jpg",
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              Text(
                                "tieu de thong bao",
                                textAlign: TextAlign.left,
                                style: AppStyles.header,
                              ),
                              Row(
                                spacing: 4,
                                children: [
                                  SvgPicture.asset(AppImages.icCalendarGray),
                                  Text(
                                    "09/08/2025 7:41",
                                    style: AppStyles.poppins12Regular.copyWith(
                                      fontSize: 14,
                                      color: AppColors.color_8588,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.all(16),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.color_F7F7,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildDetailItem(l10n.voice, "900min"),
                                    _buildDetailItem(l10n.sms, "900min"),
                                    _buildDetailItem(l10n.data, "900min"),
                                  ],
                                ),
                              ),
                              Text(
                                "chi tiet thong bao, chi tiet thong bao, chi tiet thong bao, chi tiet thong bao, chi tiet thong bao, chi tiet thong bao, chi tiet thong bao, chi tiet thong bao, ",
                                textAlign: TextAlign.left,
                                style: AppStyles.poppins12Regular.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    commonButton(text: l10n.getNow, onPressed: () {}),
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
