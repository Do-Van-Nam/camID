import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/data/model/notify/notify_model.dart';
import 'package:cam_id/main/utils/utility_fuctions.dart';
import 'package:cam_id/res/app_colors.dart';
import 'package:cam_id/res/app_images.dart';
import 'package:cam_id/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import './notification_bloc.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
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
      create: (_) => NotificationBloc()
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

          title: Text(l10n.notificationTitle, style: AppStyles.header),
          actions: [
            BlocBuilder<NotificationBloc, NotificationState>(
              builder: (context, state) {
                return IconButton(
                  icon: SvgPicture.asset(
                    AppImages.icMore,
                    width: 24,
                    height: 24,
                  ),
                  onPressed: () {
                    final notificationBloc = context.read<NotificationBloc>();

                    doShowBottomSheet(
                      context,
                      BlocProvider.value(
                        value: notificationBloc, // Dùng lại bloc đang chạy
                        child: _buildBottomSheet(context),
                      ),
                    );
                  },
                );
              },
            ),

            SizedBox(width: 16),
          ],
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
                    Tab(child: Text(l10n.notificationTabNews)),
                    Tab(child: Text(l10n.notificationTabComplain)),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [_buildNewsTab(l10n), _buildComplainTab(l10n)],
        ),
      ),
    );
  }

  Widget _buildNewsTab(AppLocalizations l10n) {
    return BlocBuilder<NotificationBloc, NotificationState>(
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
            child: Container(
              width: double.infinity,

              // margin: const EdgeInsets.all(8),
              padding: EdgeInsets.only(top: 16),
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
              child: ListView.builder(
                shrinkWrap:
                    true, // Quan trọng: Yêu cầu ListView chỉ chiếm không gian vừa đủ
                physics:
                    const NeverScrollableScrollPhysics(), // Tắt cuộn riêng của ListView
                itemCount: state.newsNotifications.length,
                itemBuilder: (context, index) {
                  final noti = state.newsNotifications[index];
                  return _buildNotificationCard(
                    noti,
                    context,
                    index < state.newsNotifications.length - 1,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildComplainTab(AppLocalizations l10n) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        if (state.isLoadingComplain) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.complainNotifications.isEmpty) {
          return Center(child: _buildEmptyNoti(l10n)); // "Không có khiếu nại"
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              width: double.infinity,

              // margin: const EdgeInsets.all(8),
              padding: EdgeInsets.only(top: 16),
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
              child: ListView.builder(
                shrinkWrap:
                    true, // Quan trọng: Yêu cầu ListView chỉ chiếm không gian vừa đủ
                physics:
                    const NeverScrollableScrollPhysics(), // Tắt cuộn riêng của ListView
                itemCount: state.complainNotifications.length,
                itemBuilder: (context, index) {
                  final noti = state.complainNotifications[index];
                  return _buildNotificationCard(
                    noti,
                    context,
                    index < state.complainNotifications.length - 1,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotificationCard(
    NotificationItem noti,
    BuildContext context,
    bool hasBottomBorder,
  ) {
    return Slidable(
      // 1. Key giúp Flutter định danh item khi danh sách thay đổi
      key: ValueKey(noti.id),

      // 2. Định nghĩa các hành động khi kéo sang trái (end action)
      endActionPane: ActionPane(
        motion: const ScrollMotion(), // Hiệu ứng trượt
        extentRatio: 0.25, // Độ rộng của nút xóa (25% chiều rộng item)
        children: [
          Center(
            child: Container(
              width: 80,
              height: 80,
              margin: EdgeInsets.only(left: 16, top: 16),
              padding: const EdgeInsets.all(
                8,
              ), // Padding để nội dung không chạm biên
              decoration: BoxDecoration(
                color: AppColors.color_F755_08,
                borderRadius: BorderRadius.circular(
                  12,
                ), // Bo góc cho mềm mại nếu cần
              ),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Căn giữa theo chiều dọc
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Căn giữa theo chiều ngang
                children: [
                  SvgPicture.asset(
                    AppImages.icTrash,
                    width: 24, // Nên cố định kích thước icon
                    height: 24,
                  ),
                  const SizedBox(
                    height: 4,
                  ), // Khoảng cách nhỏ giữa icon và text
                  Text(
                    AppLocalizations.of(context)!.delete,
                    style: AppStyles.poppins12Regular.copyWith(
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          // SlidableAction(
          //   onPressed: (context) {
          //     // Gọi sự kiện xóa trong Bloc của bạn tại đây
          //     // context.read<NotificationBloc>().add(DeleteNotificationEvent(noti.id));
          //   },
          //   backgroundColor: AppColors.color_F755_08,
          //   foregroundColor: Colors.white,
          //   icon: Icons.delete,
          //   label: AppLocalizations.of(context)!.delete,
          //   padding: EdgeInsets.all(16),
          //   margin:
          //   borderRadius: const BorderRadius.all(Radius.circular(16)),
          // ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          if (!noti.isRead) {
            context.read<NotificationBloc>().add(MarkAsReadEvent(noti.id));
          }
          // Có thể mở chi tiết thông báo ở đây
        },
        child: Container(
          margin: EdgeInsets.only(top: 8),
          padding: EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: hasBottomBorder
                ? [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 1,
                      // Offset(x, y): y = 4 sẽ đẩy bóng xuống dưới, x = 0 giữ bóng ở giữa
                      offset: const Offset(0, 1),
                    ),
                  ]
                : [],
          ),
          child: Row(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(AppImages.icCamIdLogo),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    const SizedBox(height: 8),
                    Text(
                      noti.message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      spacing: 4,
                      children: [
                        SvgPicture.asset(AppImages.icCalendarCircle),
                        Text(
                          '${noti.date.day}/${noti.date.month}/${noti.date.year} ${noti.date.hour}:${noti.date.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
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
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        spacing: 16,
        mainAxisSize: MainAxisSize.min, // Chỉ cao bằng nội dung bên trong
        children: [
          // 2. Nội dung chính
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              Text(
                l10n.more, // Dùng l10n.notificationTitle nếu muốn
                style: AppStyles.header.copyWith(fontSize: 18),
              ),
              GestureDetector(
                onTap: () => context.pop(),
                child: SvgPicture.asset(AppImages.icClose),
              ),
            ],
          ),
          // 1. Thanh gạch ngang nhỏ trên đầu (Handle bar)
          Divider(
            color: Colors.grey.withOpacity(0.2), // Màu xám mờ
            thickness: 1, // Độ dày của đường kẻ
            height:
                1, // Khoảng cách mà widget này chiếm (bao gồm cả khoảng trống trên dưới)
            indent: 16, // Khoảng cách thụt vào từ bên trái
            endIndent: 16, // Khoảng cách thụt vào từ bên phải
          ),
          GestureDetector(
            onTap: () {
              context.read<NotificationBloc>().add(ReadAllEvent(false));
              context.pop();
            },

            child: Row(
              spacing: 8,
              children: [
                SvgPicture.asset(AppImages.icTask),
                Text(l10n.readAll, style: AppStyles.poppins14Medium),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              context.read<NotificationBloc>().add(ClearAllEvent(false));
              context.pop();
            },
            child: Row(
              spacing: 8,
              children: [
                SvgPicture.asset(AppImages.icTrashBlack),
                Text(l10n.clearAll, style: AppStyles.poppins14Medium),
              ],
            ),
          ),
          const SizedBox(height: 20), // Khoảng trống an toàn dưới cùng
        ],
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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
