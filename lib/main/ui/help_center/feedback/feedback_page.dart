import 'dart:math';

import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/data/model/notify/notify_model.dart';
import 'package:cam_id/main/ui/help_center/feedback/feedback_bloc.dart';
import 'package:cam_id/main/utils/utility_fuctions.dart';
import 'package:cam_id/main/utils/widget/common_widgets.dart';
import 'package:cam_id/main/utils/widget/drop_down_widget.dart';
import 'package:cam_id/res/app_colors.dart';
import 'package:cam_id/res/app_fonts.dart';
import 'package:cam_id/res/app_images.dart';
import 'package:cam_id/res/app_styles.dart';
import 'package:cam_id/router.dart';
import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:fdottedline_nullsafety/fdottedline__nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'feedback_bloc.dart';

class HelpCenterFeedbackPage extends StatefulWidget {
  const HelpCenterFeedbackPage({super.key});

  @override
  State<HelpCenterFeedbackPage> createState() => _HelpCenterFeedbackPageState();
}

class _HelpCenterFeedbackPageState extends State<HelpCenterFeedbackPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<FocusNode> _focusNodes;
  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(6, (_) => FocusNode());
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => FeedbackBloc()
        // ..add(LoadNewsNotifications())
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

          title: Text(l10n.feedback, style: AppStyles.header),
          actions: [
            BlocBuilder<FeedbackBloc, FeedbackState>(
              builder: (context, state) {
                return IconButton(
                  icon: SvgPicture.asset(
                    AppImages.icFilter,
                    width: 24,
                    height: 24,
                  ),
                  onPressed: () {
                    // final FeedbackBloc = context.read<FeedbackBloc>();

                    doShowBottomSheet(context, _buildBottomSheet(context));
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
                    Tab(child: Text(l10n.mobileVasEmoney)),
                    Tab(child: Text(l10n.ftthTv360)),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [_buildMobileTab(l10n), _buildComplainTab(l10n)],
        ),
      ),
    );
  }

  Widget _buildMobileTab(AppLocalizations l10n) {
    return BlocBuilder<FeedbackBloc, FeedbackState>(
      builder: (context, state) {
        if (state.isLoadingNews) {
          return const Center(child: CircularProgressIndicator());
        }
        // nhap otp
        if (state.isSentOTP) {
          return Align(
            alignment: AlignmentGeometry.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 16,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 8,
                      children: [
                        Text(
                          l10n.otpSentTo,
                          style: AppStyles.poppins12Regular.copyWith(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          state.phoneNumber,
                          style: AppStyles.header.copyWith(fontSize: 14),
                        ),
                      ],
                    ),

                    // 6 ô OTP (giữ nguyên code cũ)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, (index) {
                        return _buildOtpBox(
                          context,
                          index,
                          state.digits[index],

                          _focusNodes[index],
                        );
                      }),
                    ),
                    // Timer đếm ngược
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.didNotReceiveOtp,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        state.isResendEnabled
                            ? TextButton(
                                onPressed: state.isResendEnabled
                                    ? () => context.read<FeedbackBloc>().add(
                                        ResendOtp(),
                                      )
                                    : null,
                                child: Text(
                                  l10n.resend_otp,
                                  style: TextStyle(
                                    color: state.isResendEnabled
                                        ? Colors.red
                                        : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : Text(
                                fomatTime(state.remainingSeconds),
                                style: TextStyle(color: Colors.red),
                              ),
                      ],
                    ),
                    // Nút Resend

                    // Nút Xác nhận
                    commonButton(
                      text: l10n.confirm,
                      onPressed: () {
                        print(context.read<FeedbackBloc>().otpCode);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        // list request rong
        if (!state.isInitial && state.newsNotifications.isEmpty) {
          return Align(
            alignment: AlignmentGeometry.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child:
                  // list request rong
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      spacing: 16,
                      children: [
                        Row(
                          children: [
                            Text(
                              l10n.requestProcessed,
                              style: AppStyles.header,
                            ),
                            Spacer(),
                          ],
                        ),
                        SvgPicture.asset(AppImages.icNoRQ),
                        Text(
                          textAlign: TextAlign.center,
                          l10n.noHistoryFound("chan", l10n.mobileVasEmoney),
                          maxLines: 3,
                          style: AppStyles.poppins12Regular.copyWith(
                            fontSize: 14,
                          ),
                        ),
                        commonButton(
                          text: l10n.changeAccount,
                          onPressed: () => doShowDialog(
                            context,
                            _buildChangeAccountDialog(context),
                          ),
                          color: AppColors.color_5F5F,
                          textColor: AppColors.color_0000,
                        ),
                        commonButton(text: l10n.addFeedback, onPressed: () {}),
                      ],
                    ),
                  ),
            ),
          );
        }
        // khoi tao, nhap so dien thoai
        if (state.isInitial) {
          // nhap so dien thoai
          return Align(
            alignment: AlignmentGeometry.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child:
                  // nhap account
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
                      mainAxisSize: MainAxisSize.min,
                      spacing: 16,
                      children: [
                        Text(
                          l10n.enterAccountToVerify,
                          style: AppStyles.poppins12Regular.copyWith(
                            fontSize: 16,
                            color: AppColors.color_8588,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.color_F7F7,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: TextField(
                            maxLines: 1,
                            decoration: InputDecoration(
                              hintText: l10n
                                  .enterAccountNumber, // "Nội dung chi tiết"
                              hintStyle: AppStyles.poppins12Regular.copyWith(
                                fontSize: 16,
                                color: AppColors.color_8588,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                            onChanged: (value) {
                              context.read<FeedbackBloc>().add(
                                PhoneChanged(value),
                              );
                            },
                            // context.read<FeedbackBloc>().add(ContentChanged(value)),
                          ),
                        ),
                        commonButton(
                          text: l10n.confirm,
                          onPressed: () {
                            context.read<FeedbackBloc>().add(SendOtp());
                          },
                        ),
                      ],
                    ),
                  ),
            ),
          );
        }

        //add request
        return SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16,
                    top: 16,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: commonContainer(
                      child: Column(
                        spacing: 8,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.selectType,
                            style: AppStyles.poppins12Regular.copyWith(
                              fontSize: 16,
                              color: AppColors.color_8588,
                            ),
                          ),
                          CustomDropdownButton3(
                            dropdownItems: ["1", "2", "2"],
                            hint: l10n.select,
                            onChanged: (value) => {},
                            value: "1",
                            icon: AppImages.icArrowDown,
                          ),
                          Text(
                            l10n.customerName,
                            style: AppStyles.poppins12Regular.copyWith(
                              fontSize: 16,
                              color: AppColors.color_8588,
                            ),
                          ),
                          inputTextField(
                            hintText: l10n.nameHint,
                            maxLine: 1,
                            onChanged: (value) {},
                          ),
                          Row(
                            spacing: 16,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Column(
                                  spacing: 16,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.accountNumber,
                                      style: AppStyles.poppins12Regular
                                          .copyWith(
                                            fontSize: 16,
                                            color: AppColors.color_8588,
                                          ),
                                    ),
                                    inputTextField(
                                      hintText: l10n.enterAccountNumber,
                                      maxLine: 1,
                                      onChanged: (value) {},
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  spacing: 16,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.phoneNumber,
                                      style: AppStyles.poppins12Regular
                                          .copyWith(
                                            fontSize: 16,
                                            color: AppColors.color_8588,
                                          ),
                                    ),
                                    inputTextField(
                                      hintText: l10n.enter_your_phone_number,
                                      maxLine: 1,
                                      onChanged: (value) {},
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Text(
                            l10n.error,
                            style: AppStyles.poppins12Regular.copyWith(
                              fontSize: 16,
                              color: AppColors.color_8588,
                            ),
                          ),
                          CustomDropdownButton3(
                            dropdownItems: ["1", "2", "2"],
                            hint: l10n.select,
                            onChanged: (value) => {},
                            value: "1",
                            icon: AppImages.icArrowDown,
                          ),
                          Text(
                            l10n.complaintType,
                            style: AppStyles.poppins12Regular.copyWith(
                              fontSize: 16,
                              color: AppColors.color_8588,
                            ),
                          ),
                          CustomDropdownButton3(
                            dropdownItems: ["1", "2", "2"],
                            hint: l10n.select,
                            onChanged: (value) => {},
                            value: "1",
                            icon: AppImages.icArrowDown,
                          ),
                          Text(
                            l10n.feedback,
                            style: AppStyles.poppins12Regular.copyWith(
                              fontSize: 16,
                              color: AppColors.color_8588,
                            ),
                          ),
                          inputTextField(
                            hintText: l10n.enterFeedbackHint,
                            maxLine: 1,
                            onChanged: (value) {},
                          ),
                          SizedBox(height: 8),
                          FDottedLine(
                            color: AppColors.color_8588, // Màu của đường viền
                            strokeWidth: 1.5, // Độ dày của viền
                            dottedLength: 6.0, // Độ dài mỗi đoạn nét đứt
                            space: 4.0, // Khoảng cách giữa các nét đứt
                            corner: FDottedLineCorner.all(16), // Bo góc ở đây
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 16,
                              ),
                              decoration: const BoxDecoration(
                                color: Colors.transparent, // Trong suốt
                              ),
                              child: Row(
                                spacing: 8,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(AppImages.icCamera),
                                  Text(
                                    l10n.uploadPhoto,
                                    style: AppStyles.poppins12Regular.copyWith(
                                      color: AppColors.colorMain,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                //color: Colors.white,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white),
                //padding: EdgeInsets.all(8),
                child: commonButton(text: l10n.sendFeedback, onPressed: () {}),
              ),
            ],
          ),
        );

        // List request
        return SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        Text(l10n.requestProcessed, style: AppStyles.header),
                        ListView.builder(
                          shrinkWrap:
                              true, // Quan trọng: Yêu cầu ListView chỉ chiếm không gian vừa đủ
                          physics:
                              const NeverScrollableScrollPhysics(), // Tắt cuộn riêng của ListView
                          itemCount: state.complainNotifications.length,
                          itemBuilder: (context, index) {
                            final noti = state.complainNotifications[index];
                            return _buildRequestCard(noti, context);
                          },
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                //color: Colors.white,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white),
                //padding: EdgeInsets.all(8),
                child: Column(
                  spacing: 8,
                  children: [
                    commonButton(
                      text: l10n.changeAccount,
                      onPressed: () => doShowDialog(
                        context,
                        _buildChangeAccountDialog(context),
                      ),
                      color: AppColors.color_5F5F,
                      textColor: AppColors.color_0000,
                    ),
                    commonButton(text: l10n.addFeedback, onPressed: () {}),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildComplainTab(AppLocalizations l10n) {
    return BlocBuilder<FeedbackBloc, FeedbackState>(
      builder: (context, state) {
        if (state.isLoadingComplain) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.complainNotifications.isEmpty) {
          return Center(child: _buildEmptyNoti(l10n)); // "Không có khiếu nại"
        }
        return
        // List request
        SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        Text(l10n.requestProcessed, style: AppStyles.header),
                        ListView.builder(
                          shrinkWrap:
                              true, // Quan trọng: Yêu cầu ListView chỉ chiếm không gian vừa đủ
                          physics:
                              const NeverScrollableScrollPhysics(), // Tắt cuộn riêng của ListView
                          itemCount: state.complainNotifications.length,
                          itemBuilder: (context, index) {
                            final noti = state.complainNotifications[index];
                            return _buildRequestCard(noti, context);
                          },
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                //color: Colors.white,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white),
                //padding: EdgeInsets.all(8),
                child: Column(
                  spacing: 8,
                  children: [
                    commonButton(
                      text: l10n.changeAccount,
                      onPressed: () {},
                      color: AppColors.color_5F5F,
                      textColor: AppColors.color_0000,
                    ),
                    commonButton(text: l10n.addFeedback, onPressed: () {}),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRequestCard(NotificationItem noti, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () {
        if (!noti.isRead) {
          context.read<FeedbackBloc>().add(MarkAsReadEvent(noti.id));
        }
        context.push(PATH_HELPCENTER_FEEDBACK_DETAIL);
      },
      child: Container(
        margin: EdgeInsets.only(top: 8),
        padding: EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "noi dung feedback",
              style: AppStyles.header.copyWith(fontSize: 14),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.time,
                  style: AppStyles.poppins12Regular.copyWith(
                    color: AppColors.color_8588,
                  ),
                ),
                Text("16:20:57  15/07/2024", style: AppStyles.poppins14Medium),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.phoneNumber,
                  style: AppStyles.poppins12Regular.copyWith(
                    color: AppColors.color_8588,
                  ),
                ),
                Text(
                  "09239384290",
                  style: AppStyles.poppins14Medium.copyWith(
                    color: AppColors.color_43B6,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.feedback,
                  style: AppStyles.poppins12Regular.copyWith(
                    color: AppColors.color_8588,
                  ),
                ),
                Text("noi dung feedback", style: AppStyles.poppins14Medium),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.status,
                  style: AppStyles.poppins12Regular.copyWith(
                    color: AppColors.color_8588,
                  ),
                ),
                buildStatusBadge("processing", l10n),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStatusBadge(String type, l10n) {
    String label = type == "received"
        ? l10n.received
        : type == "processing"
        ? l10n.processing
        : "empty";
    Color color = type == "received"
        ? AppColors.color_E11B
        : type == "processing"
        ? AppColors.color_FDB9
        : AppColors.color_FF1D;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: color), // Dùng Icon tròn cho nhanh
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
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
              context.read<FeedbackBloc>().add(ReadAllEvent(false));
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
              context.read<FeedbackBloc>().add(ClearAllEvent(false));
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

  Widget _buildOtpBox(
    BuildContext context,
    int index,
    String value,
    FocusNode focusNode,
  ) {
    final bloc = context.read<FeedbackBloc>();

    return SizedBox(
      width: 50,
      height: 50,
      child: TextField(
        focusNode: focusNode,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.top,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '', // Ẩn counter
          filled: true,
          fillColor: value.isEmpty ? Colors.grey[100] : Colors.red[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: value.isEmpty ? Colors.grey : Colors.red,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
        ),
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        onChanged: (digit) {
          if (digit.length == 1) {
            bloc.add(OtpDigitChanged(index, digit));

            // Tự động chuyển sang ô tiếp theo
            if (index < 5) {
              _focusNodes[index + 1].requestFocus();
            } else {
              focusNode.unfocus(); // Ẩn bàn phím khi đủ 6 số
              bloc.add(SubmitOtp());
            }
          } else if (digit.isEmpty) {
            if (value.isNotEmpty) {
              bloc.add(OtpDigitDeleted(index));
            }
            //  bloc.add(OtpDigitDeleted(index));

            // Quay lại ô trước khi xóa
            if (index > 0) {
              _focusNodes[index - 1].requestFocus();
            }
          }
        },
        onSubmitted: (_) {
          if (index < 5) FocusScope.of(context).nextFocus();
        },
      ),
    );
  }

  Widget _buildChangeAccountDialog(BuildContext context) {
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
        mainAxisSize: MainAxisSize
            .min, // Quan trọng: Để popup không chiếm hết chiều cao màn hình
        children: [
          // 2. Tiêu đề
          Text(
            l10n.notificationTitle,
            style: AppTextFonts.poppinsSemiBold.copyWith(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),

          // 3. Nội dung mô tả
          Text(
            l10n.confirmChangeAccount,
            style: AppTextFonts.poppinsRegular.copyWith(
              color: AppColors.color_8588,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
            //     style: AppTextFonts.poppins12Regular,
          ),
          const SizedBox(height: 24),

          // 4. Các nút bấm hành động
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: commonButton(
                  text: l10n.no,
                  color: AppColors.color_5F5F,
                  textColor: AppColors.color_0000,
                  onPressed: () => context.pop(),
                ),
              ),
              Expanded(
                child: commonButton(
                  text: l10n.yes,
                  onPressed: () {
                    context.read<FeedbackBloc>().add(ChangeAcc());
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

  @override
  void dispose() {
    _tabController.dispose();
    for (var node in _focusNodes) {
      node.dispose(); // Giải phóng
    }
    super.dispose();
  }
}

Widget buildStatusBadge(String type, l10n) {
  String label = type == "received"
      ? l10n.received
      : type == "processing"
      ? l10n.processing
      : l10n.statusClosed;
  Color color = type == "received"
      ? AppColors.color_E11B
      : type == "processing"
      ? AppColors.color_FDB9
      : AppColors.color_FF1D;
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, size: 8, color: color), // Dùng Icon tròn cho nhanh
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
