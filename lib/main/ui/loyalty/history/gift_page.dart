import 'package:cached_network_image/cached_network_image.dart';
import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/data/model/notify/notify_model.dart';
import 'package:cam_id/main/utils/utility_fuctions.dart';
import 'package:cam_id/main/utils/widget/common_widgets.dart';
import 'package:cam_id/res/app_colors.dart';
import 'package:cam_id/res/app_fonts.dart';
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

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
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

          title: Text(l10n.history, style: AppStyles.header),
          actions: [
            IconButton(
              icon: SvgPicture.asset(
                AppImages.icCalendarSearch,
                width: 24,
                height: 24,
              ),
              onPressed: () {
                    final feedbackBloc = context.read<GiftBloc>();

                    showDialog(
                      context: context,
                      builder: (dialogContext) {
                        // Cung cấp Bloc cho context của Dialog
                        return BlocProvider.value(
                          value: feedbackBloc,
                          child: Dialog(
                            backgroundColor: Colors.transparent,
                            // BlocBuilder phải nằm ở ĐÂY để lắng nghe thay đổi khi đang mở Dialog
                            child: BlocBuilder<GiftBloc, GiftState>(
                              builder: (context, state) {
                                return _buildFilterDialog(context, state);
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
            ),   ],
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
                    Tab(child: Text(l10n.all)),
                    Tab(child: Text(l10n.received)),
                    Tab(child: Text(l10n.used)),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [

            _buildHistoryTab(l10n),
            _buildHistoryTab(l10n),
            _buildHistoryTab(l10n),
          ],
        ),
      ),
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
          CircleAvatar(
          radius: 30,
          backgroundColor: Colors.pink[50],
          child: SvgPicture.asset(AppImages.icMagicStar, width: 24, height: 24),
        ),
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
          Text(
            "${AppLocalizations.of(context)!.points} 100",
            style: AppStyles.poppins14Medium
          ),
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

    Widget _buildFilterDialog(BuildContext context, GiftState state) {
    final bloc = context.read<GiftBloc>();
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize
            .min, // Quan trọng: Để popup không chiếm hết chiều cao màn hình
        children: [
          // 2. Tiêu đề
          Center(
            child: Text(
              l10n.selectDateRange,
              style: AppTextFonts.poppinsSemiBold.copyWith(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          // chon ngay thang
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.from,
                      style: AppStyles.poppins12Regular.copyWith(
                        fontSize: 16,
                        color: AppColors.color_8588,
                      ),
                    ),
                    datePickerField(
                      context: context,
                      selectedDate: DateTime.now(),
                      onDateSelected: (newDate) {
                      //  bloc.add(DateFilterChanged(newDate, "from"));
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.to,
                      style: AppStyles.poppins12Regular.copyWith(
                        fontSize: 16,
                        color: AppColors.color_8588,
                      ),
                    ),
                    datePickerField(
                      context: context,
                      selectedDate: DateTime.now(),
                      onDateSelected: (newDate) {
                    //    bloc.add(DateFilterChanged(newDate, "to"));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          // chon service type
          Text(
            l10n.serviceType,
            style: AppStyles.poppins12Regular.copyWith(
              fontSize: 16,
              color: AppColors.color_8588,
            ),
          ),
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: 
                  _buildFilterItem(false, l10n.today, "value", (){})
                ),
                Expanded(
                  child: 
                  _buildFilterItem(false, l10n.thisMonth, "value", (){})
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: 
                  _buildFilterItem(false, l10n.thisWeek, "value", (){})
                ),
                Expanded(
                  child: 
                  _buildFilterItem(false, l10n.thisYear, "value", (){})
                ),
              ],
            )
          ],
        ),
         // 4. Các nút bấm hành động
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: commonButton(
                  text: l10n.cancel,
                  color: AppColors.color_5F5F,
                  textColor: AppColors.color_0000,
                  onPressed: () => context.pop(),
                ),
              ),
              Expanded(
                child: commonButton(
                  text: l10n.search,
                  onPressed: () {
               //     bloc.add(ChangeAcc());
                    context.pop();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildFilterItem(bool isSelected,String label, String value,VoidCallback onTap) {
    return GestureDetector(
      onTap:
        onTap
      ,
      child: Row(
        children: [
            SvgPicture.asset(isSelected ? AppImages.icRadioBtnTicked : AppImages.icRadioBtn),
          Text(label, style: AppStyles.poppins12Regular.copyWith(
            fontSize: 16,
            color: AppColors.color_8588,
          ),),
        ],
      ),
    );
  }

}
