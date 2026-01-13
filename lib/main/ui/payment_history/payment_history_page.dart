import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/data/model/auto_renew_model.dart';
import 'package:cam_id/main/data/model/info_payment_model.dart';
import 'package:cam_id/main/data/model/linked_payment_method_model.dart';
import 'package:cam_id/main/data/model/payment_history_model.dart';
import 'package:cam_id/main/ui/payment_history/payment_history_bloc.dart';
import 'package:cam_id/main/ui/payment_history/payment_history_event.dart';
import 'package:cam_id/main/ui/payment_history/payment_history_state.dart';
import 'package:cam_id/main/utils/bottom_sheet/cancel_auto_renew_bottom_sheet.dart';
import 'package:cam_id/main/utils/bottom_sheet/filter_bottom_sheet.dart';
import 'package:cam_id/main/utils/constant.dart';
import 'package:cam_id/main/utils/widget/app_toast_widget.dart';
import 'package:cam_id/main/utils/widget/loading_overlay_widget.dart';
import 'package:cam_id/main/utils/widget/loading_widget.dart';
import 'package:cam_id/res/app_colors.dart';
import 'package:cam_id/res/app_fonts.dart';
import 'package:cam_id/res/app_images.dart';
import 'package:cam_id/res/app_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class PaymentHistoryPage extends StatefulWidget {
  const PaymentHistoryPage({super.key});
  @override
  State<PaymentHistoryPage> createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage>
    with SingleTickerProviderStateMixin {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  late final PaymentHistoryBloc _bloc;
  late TabController _tabController;
  final List<PaymentHistoryModel> fakePaymentList = [
    PaymentHistoryModel()
      ..paymentDate = '2025-01-01'
      ..paymentTime = '09:00 AM'
      ..historyPerDayList = [
        HistoryPerDay()
          ..id = '1'
          ..service = 'Topup'
          ..method = 'Wallet'
          ..image = 'img/topup.png'
          ..amount = '2000'
          ..content = 'Renewed at 9:30 AM on the 20th of every month via eMoney'
          ..paymentTime = '09:01 AM'
          ..receiveIsdn = '097000001'
          ..partnerAccount = 'PartnerA',
        HistoryPerDay()
          ..id = '2'
          ..service = 'Bill'
          ..method = 'Cash'
          ..image = 'img/bill.png'
          ..amount = '5000'
          ..content = 'Electric bill'
          ..paymentTime = '09:02 AM'
          ..receiveIsdn = '097000002'
          ..partnerAccount = 'PartnerB',
        HistoryPerDay()
          ..id = '3'
          ..service = 'Data Pack'
          ..method = 'Wallet'
          ..image = 'img/data.png'
          ..amount = '3000'
          ..content = 'Buy data'
          ..paymentTime = '09:03 AM'
          ..receiveIsdn = '097000003'
          ..partnerAccount = 'PartnerC',
        HistoryPerDay()
          ..id = '4'
          ..service = 'Voice Pack'
          ..method = 'Card'
          ..image = 'img/voice.png'
          ..amount = '2500'
          ..content = 'Buy voice pack'
          ..paymentTime = '09:04 AM'
          ..receiveIsdn = '097000004'
          ..partnerAccount = 'PartnerD',
      ],
    PaymentHistoryModel()
      ..paymentDate = '2025-01-02'
      ..paymentTime = '10:00 AM'
      ..historyPerDayList = [
        HistoryPerDay()
          ..id = '5'
          ..service = 'Topup'
          ..method = 'Wallet'
          ..image = 'img/topup.png'
          ..amount = '4000'
          ..content = 'Top up prepaid'
          ..paymentTime = '10:01 AM'
          ..receiveIsdn = '097000005'
          ..partnerAccount = 'PartnerA',
        HistoryPerDay()
          ..id = '6'
          ..service = 'Bill'
          ..method = 'Cash'
          ..image = 'img/bill.png'
          ..amount = '6000'
          ..content = 'Water bill'
          ..paymentTime = '10:02 AM'
          ..receiveIsdn = '097000006'
          ..partnerAccount = 'PartnerB',
        HistoryPerDay()
          ..id = '7'
          ..service = 'Data Pack'
          ..method = 'Card'
          ..image = 'img/data.png'
          ..amount = '3500'
          ..content = 'Internet package'
          ..paymentTime = '10:03 AM'
          ..receiveIsdn = '097000007'
          ..partnerAccount = 'PartnerC',
        HistoryPerDay()
          ..id = '8'
          ..service = 'Voice Pack'
          ..method = 'Wallet'
          ..image = 'img/voice.png'
          ..amount = '2700'
          ..content = 'Call pack'
          ..paymentTime = '10:04 AM'
          ..receiveIsdn = '097000008'
          ..partnerAccount = 'PartnerD',
      ],
    PaymentHistoryModel()
      ..paymentDate = '2025-01-03'
      ..paymentTime = '11:00 AM'
      ..historyPerDayList = [
        HistoryPerDay()
          ..id = '9'
          ..service = 'Topup'
          ..method = 'Card'
          ..image = 'img/topup.png'
          ..amount = '1500'
          ..content = 'Top up prepaid'
          ..paymentTime = '11:01 AM'
          ..receiveIsdn = '097000009'
          ..partnerAccount = 'PartnerA',
        HistoryPerDay()
          ..id = '10'
          ..service = 'Utility'
          ..method = 'Wallet'
          ..image = 'img/bill.png'
          ..amount = '4500'
          ..content = 'Cable fee'
          ..paymentTime = '11:02 AM'
          ..receiveIsdn = '097000010'
          ..partnerAccount = 'PartnerB',
        HistoryPerDay()
          ..id = '11'
          ..service = 'Data Pack'
          ..method = 'Wallet'
          ..image = 'img/data.png'
          ..amount = '3200'
          ..content = 'Daily data'
          ..paymentTime = '11:03 AM'
          ..receiveIsdn = '097000011'
          ..partnerAccount = 'PartnerC',
        HistoryPerDay()
          ..id = '12'
          ..service = 'Voice Pack'
          ..method = 'Cash'
          ..image = 'img/voice.png'
          ..amount = '2900'
          ..content = 'Voice pack'
          ..paymentTime = '11:04 AM'
          ..receiveIsdn = '097000012'
          ..partnerAccount = 'PartnerD',
      ],
    PaymentHistoryModel()
      ..paymentDate = '2025-01-04'
      ..paymentTime = '12:00 PM'
      ..historyPerDayList = [
        HistoryPerDay()
          ..id = '13'
          ..service = 'Topup'
          ..method = 'Wallet'
          ..image = 'img/topup.png'
          ..amount = '2500'
          ..content = 'Top up prepaid'
          ..paymentTime = '12:01 PM'
          ..receiveIsdn = '097000013'
          ..partnerAccount = 'PartnerA',
        HistoryPerDay()
          ..id = '14'
          ..service = 'Postpaid'
          ..method = 'Card'
          ..image = 'img/bill.png'
          ..amount = '7000'
          ..content = 'Postpaid bill'
          ..paymentTime = '12:02 PM'
          ..receiveIsdn = '097000014'
          ..partnerAccount = 'PartnerB',
        HistoryPerDay()
          ..id = '15'
          ..service = 'Data Pack'
          ..method = 'Wallet'
          ..image = 'img/data.png'
          ..amount = '3300'
          ..content = 'Unlimited data'
          ..paymentTime = '12:03 PM'
          ..receiveIsdn = '097000015'
          ..partnerAccount = 'PartnerC',
        HistoryPerDay()
          ..id = '16'
          ..service = 'Voice Pack'
          ..method = 'Cash'
          ..image = 'img/voice.png'
          ..amount = '2800'
          ..content = 'Voice 30 days'
          ..paymentTime = '12:04 PM'
          ..receiveIsdn = '097000016'
          ..partnerAccount = 'PartnerD',
      ],
    PaymentHistoryModel()
      ..paymentDate = '2025-01-05'
      ..paymentTime = '01:00 PM'
      ..historyPerDayList = [
        HistoryPerDay()
          ..id = '17'
          ..service = 'Topup'
          ..method = 'Wallet'
          ..image = 'img/topup.png'
          ..amount = '2100'
          ..content = 'Top up prepaid'
          ..paymentTime = '01:01 PM'
          ..receiveIsdn = '097000017'
          ..partnerAccount = 'PartnerA',
        HistoryPerDay()
          ..id = '18'
          ..service = 'Bill'
          ..method = 'Wallet'
          ..image = 'img/bill.png'
          ..amount = '8000'
          ..content = 'School fee'
          ..paymentTime = '01:02 PM'
          ..receiveIsdn = '097000018'
          ..partnerAccount = 'PartnerB',
        HistoryPerDay()
          ..id = '19'
          ..service = 'Data Pack'
          ..method = 'Wallet'
          ..image = 'img/data.png'
          ..amount = '3500'
          ..content = 'Unlimited data'
          ..paymentTime = '01:03 PM'
          ..receiveIsdn = '097000019'
          ..partnerAccount = 'PartnerC',
        HistoryPerDay()
          ..id = '20'
          ..service = 'Voice Pack'
          ..method = 'Card'
          ..image = 'img/voice.png'
          ..amount = '2400'
          ..content = 'Monthly voice'
          ..paymentTime = '01:04 PM'
          ..receiveIsdn = '097000020'
          ..partnerAccount = 'PartnerD',
      ],
  ];
  final fakeAutoRenewList = List<AutoRenewModel>.generate(5, (index) {
    return AutoRenewModel()
      ..paymentDate = '2026-01-${(index + 1).toString().padLeft(2, '0')}'
      ..historyPerDayList = List<AutoRenewHistoryPerDay>.generate(4, (i) {
        return AutoRenewHistoryPerDay()
          ..id = 'ID_${index}_$i'
          ..service = 'Service $i'
          ..image = 'https://example.com/img_$i.png'
          ..amount = '${(i + 1) * 1000} KHR'
          ..content = 'Auto renew content $i'
          ..status = i % 2 == 0 ? 0 : 1
          ..createDate = DateTime.now().millisecondsSinceEpoch
          ..accountNumber = '09876543$i'
          ..accountPartner = 'Partner $i'
          ..formatDate = '01-${i + 1}-2026'
          ..linkedDate = '2026-01-${i + 1}'
          ..linkedPaymentId = 'LPID_${index}_$i'
          ..cancelConfirmMessage = 'Bạn có chắc muốn tắt dịch vụ $i?'
          ..expiredIn = '${(i + 1) * 5} ngày'
          ..originalService = 'top-up';
      });
  });

  List<PaymentHistoryModel>? listPayment = [];
  List<AutoRenewModel>? listAutoRenew = [];

  LoadingWidgetState viewStateHistory = LoadingWidgetState.loading;
  LoadingWidgetState viewStateAutoRenew = LoadingWidgetState.loading;
  int pageHistory = 1;
  int pageAutoRenew = 1;
  int pageSizeHistory = 20;
  int pageSizeAutoRenew = 20;
  String fromDate = "";
  String toDate = "";
  String filter = Constant.WEEK;
  LinkedPaymentMethodModel? linkedPaymentMethodModel;
  InfoPayment? infoPayment;
  bool isLoadingMoreAuto = false;
  bool hasMoreAuto = true;
  bool isLoadingMoreHistory = false;
  bool hasMoreHistory = true;
  final ScrollController _scrollAutoRenewController = ScrollController();
  final ScrollController _scrollHistoryController = ScrollController();

  @override
  void initState() {
    super.initState();
    _bloc = PaymentHistoryBloc();
    _bloc.add(
      GetPaymentHistoryEvent(fromDate, toDate, pageHistory, pageSizeHistory),
    );
    _bloc.add(
      GetAutoRenewHistoryEvent(
        fromDate,
        toDate,
        filter,
        pageAutoRenew,
        pageSizeAutoRenew,
      ),
    );
    _tabController = TabController(length: 2, vsync: this);
    _scrollAutoRenewController.addListener(() {
      if (_scrollAutoRenewController.position.pixels >=
          _scrollAutoRenewController.position.maxScrollExtent - 50) {
        _loadMoreAuto();
      }
    });

    _scrollHistoryController.addListener(() {
      if (_scrollHistoryController.position.pixels >=
          _scrollHistoryController.position.maxScrollExtent - 50) {
        _loadMoreHistory();
      }
    });
  }

  @override
  void dispose() {
    _bloc.close();
    _tabController.dispose();
    _scrollAutoRenewController.dispose();
    _scrollHistoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: BlocProvider.value(
        value: _bloc,
        child: BlocListener<PaymentHistoryBloc, PaymentHistoryState>(
          listener: (context, state) {
            if (state is PaymentHistoryLoading) {
              setState(() {
                viewStateHistory = LoadingWidgetState.loading;
              });
            }
            if (state is AutoRenewHistoryLoading) {
              setState(() {
                viewStateAutoRenew = LoadingWidgetState.loading;
              });
            }
            if (state is GetPaymentHistorySuccess) {
              setState(() {
                viewStateHistory = LoadingWidgetState.success;

                if (pageHistory == 1) {
                  listPayment = state.listPayment;
                } else {
                  listPayment?.addAll(state.listPayment ?? []);
                }

                hasMoreHistory =
                    (state.listPayment?.length ?? 0) == pageSizeHistory;
                isLoadingMoreHistory = false;
              });
            }

            if (state is GetPaymentHistoryFailure) {
              setState(() {
                listPayment = fakePaymentList;
                viewStateHistory = LoadingWidgetState.success;
                // if (pageHistory == 1 && listPayment?.isEmpty == true) {
                //   viewStateHistory = LoadingWidgetState.empty;
                // } else {
                //   viewStateHistory = LoadingWidgetState.success;
                //   isLoadingMoreHistory = false;
                //   hasMoreHistory = false;
                // }
              });
            }

            if (state is GetAutoRenewSuccess) {
              setState(() {
                viewStateAutoRenew = LoadingWidgetState.success;

                if (pageAutoRenew == 1) {
                  listAutoRenew = state.listAutoRenew;
                } else {
                  listAutoRenew?.addAll(state.listAutoRenew ?? []);
                }

                hasMoreAuto =
                    (state.listAutoRenew?.length ?? 0) == pageSizeAutoRenew;
                isLoadingMoreAuto = false;
              });
            }

            if (state is GetAutoRenewFailure) {
              setState(() {
                listAutoRenew = fakeAutoRenewList;
                viewStateAutoRenew = LoadingWidgetState.success;
                // if (pageAutoRenew == 1 && listAutoRenew?.isEmpty == true) {
                //   viewStateAutoRenew = LoadingWidgetState.empty;
                // } else {
                //   viewStateAutoRenew = LoadingWidgetState.success;
                //   isLoadingMoreAuto = false;
                //   hasMoreAuto = false;
                // }
              });
            }

            if (state is CancelAutoRenewSuccess) {
              LoadingOverlayWidget.hide();
              pageSizeHistory = 1;
              _bloc.add(
                GetAutoRenewHistoryEvent(
                  fromDate,
                  toDate,
                  filter,
                  pageAutoRenew,
                  pageSizeAutoRenew,
                ),
              );
            }

            if (state is CancelAutoRenewFailure) {
              LoadingOverlayWidget.hide();
              AppToast.show(context, state.message);
            }

            if (state is SaveAutoRenewSuccess) {
              LoadingOverlayWidget.hide();
              pageSizeHistory = 1;
              _bloc.add(
                GetAutoRenewHistoryEvent(
                  fromDate,
                  toDate,
                  filter,
                  pageAutoRenew,
                  pageSizeAutoRenew,
                ),
              );
            }

            if (state is SaveAutoRenewFailure) {
              LoadingOverlayWidget.hide();
              AppToast.show(context, state.message);
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.color_F7F7,
            appBar: AppBar(
              backgroundColor: AppColors.color_FFFF,
              elevation: 0,
              centerTitle: true,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.color_1618,
                ),
                onPressed: () => context.pop(),
              ),
              title: Text(l10n.payment_history, style: AppStyles.headerBlack),
              actions: [
                InkWell(
                  onTap: () async {
                    final result = await showFilterBottomSheet(
                      context,
                      filter,
                      showFull: true,
                    );
                    if (result != null) {
                      _updateFilter(result);
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(AppImages.icFilterV2),
                      const SizedBox(width: 4),
                      Text(
                        l10n.filter,
                        style: AppTextFonts.poppinsRegular.copyWith(
                          fontSize: 10,
                          color: AppColors.color_E11B,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(52),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    height: 44,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.all(2),

                    decoration: BoxDecoration(
                      color: AppColors.color_5F5F,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: AppColors.color_1618,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      indicatorColor: AppColors.color_1618,
                      dividerColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: AppColors.color_FFFF,
                      unselectedLabelColor: AppColors.color_464B,
                      tabs: [
                        Tab(child: Text(l10n.history)),
                        Tab(child: Text(l10n.auto_renew)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildTabHistory(), // tab 1
                _buildTabAutoRenew(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabHistory() {
    return LoadingWidget(
      state: viewStateHistory,
      child: ListView.builder(
        controller: _scrollHistoryController,
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        itemCount: listPayment?.length,
        itemBuilder: (context, index) {
          final parent = listPayment?[index];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index != 0) SizedBox(height: 16),
              Text(
                parent?.paymentDate ?? '',
                style: AppTextFonts.poppinsRegular.copyWith(
                  fontSize: 14,
                  color: AppColors.color_464B,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.color_FFFF,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ...List.generate(parent?.historyPerDayList?.length ?? 0, (
                      i,
                    ) {
                      final item = parent?.historyPerDayList![i];
                      return Container(
                        // margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(AppImages.icEmoney),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item?.service ?? '',
                                        style: AppTextFonts.poppinsSemiBold
                                            .copyWith(
                                              fontSize: 14,
                                              color: AppColors.color_1618,
                                            ),
                                      ),
                                      Text(
                                        item?.content ?? '',
                                        style: AppTextFonts.poppinsRegular
                                            .copyWith(
                                              fontSize: 12,
                                              color: AppColors.color_8588,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '\$${item?.amount}',
                                  style: AppTextFonts.poppinsSemiBold.copyWith(
                                    fontSize: 14,
                                    color: AppColors.color_43B6,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 17),
                            Divider(height: 1, color: AppColors.color_5F5F),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              if ((index + 1) == listPayment?.length) SizedBox(height: 16),
            ],
          );
        },
      ),
    );
    // return ;
  }

  Widget _buildTabAutoRenew() {
    return LoadingWidget(
      state: viewStateAutoRenew,
      child: ListView.builder(
        controller: _scrollAutoRenewController,
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        itemCount: listAutoRenew?.length,
        itemBuilder: (context, index) {
          final parent = listAutoRenew?[index];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index != 0) SizedBox(height: 16),
              Text(
                parent?.paymentDate ?? '',
                style: AppTextFonts.poppinsRegular.copyWith(
                  fontSize: 14,
                  color: AppColors.color_464B,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.color_FFFF,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ...List.generate(parent?.historyPerDayList?.length ?? 0, (
                      i,
                    ) {
                      final item = parent?.historyPerDayList![i];
                      bool isOn = item?.status == 0;
                      return Container(
                        // margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(AppImages.icEmoney),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item?.service ?? '',
                                        style: AppTextFonts.poppinsSemiBold
                                            .copyWith(
                                              fontSize: 14,
                                              color: AppColors.color_1618,
                                            ),
                                      ),
                                      Text(
                                        item?.content ?? '',
                                        style: AppTextFonts.poppinsRegular
                                            .copyWith(
                                              fontSize: 12,
                                              color: AppColors.color_8588,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      '\$${item?.amount}',
                                      style: AppTextFonts.poppinsSemiBold
                                          .copyWith(
                                            fontSize: 14,
                                            color: AppColors.color_43B6,
                                          ),
                                    ),
                                    Transform.scale(
                                      scale: 0.9,
                                      child: CupertinoSwitch(
                                        value: isOn,
                                        onChanged: (v) {
                                          setState(() {
                                            // isOn = v;
                                            if (isOn) {
                                              showCancelPaymentBottomSheet(
                                                context,
                                                item!,
                                              );
                                            } else {
                                              LoadingOverlayWidget.show(context);
                                              _bloc.add(SaveAutoRenewEvent(item?.id ?? ""));
                                            }
                                          });
                                        },
                                        activeTrackColor: AppColors.color_43B6,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 17),
                            Divider(height: 1, color: AppColors.color_5F5F),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              if ((index + 1) == listPayment?.length) SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  Future<void> showCancelPaymentBottomSheet(
    BuildContext context,
    AutoRenewHistoryPerDay data,
  ) async {
    final linkedPaymentMethodModel = LinkedPaymentMethodModel(
      image: data.image,
      accountPartner: data.accountPartner,
      partnerCode: (data.expiredIn != null && data.expiredIn!.isNotEmpty)
          ? Constant.ABA_ACCOUNT
          : '',
      expiredDate: (data.expiredIn != null && data.expiredIn!.isNotEmpty)
          ? data.expiredIn
          : '',
      linkedDate: (data.expiredIn != null && data.expiredIn!.isNotEmpty)
          ? data.expiredIn
          : data.linkedDate,
    );

    final infoPayment = InfoPayment(
      questionCancel: data.cancelConfirmMessage,
      service: data.service,
      originalService: data.originalService,
      phoneNumber: data.accountNumber,
      amountCancel: data.amount,
      contentWarning: data.content,
    );

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) => CancelAutoRenewBottomSheet(
        linkedPaymentMethodModel: linkedPaymentMethodModel,
        infoPayment: infoPayment,
        onCancel: () => Navigator.of(context).pop(),
        onConfirm: (paymentType, paymentMethod) {
          Navigator.of(context).pop();
          if (paymentType == PaymentType.CANCEL) {
            LoadingOverlayWidget.show(context);
            _bloc.add(CancelAutoRenewEvent(data.id ?? ""));
          }
        },

        paymentType: PaymentType.CANCEL,
      ),
    );
  }

  Future<void> _updateFilter(String filter) async {
    final now = DateTime.now();

    String newStartTime;
    String newEndTime = Constant.formatDateV2(now.millisecondsSinceEpoch);

    switch (filter) {
      case Constant.TODAY:
        newStartTime = Constant.formatDateV2(
          DateTime(now.year, now.month, now.day).millisecondsSinceEpoch,
        );
        break;
      case Constant.WEEK:
        newStartTime = Constant.formatDateV2(
          now.subtract(const Duration(days: 7)).millisecondsSinceEpoch,
        );
        break;
      case Constant.MONTH:
        newStartTime = Constant.formatDateV2(
          now.subtract(const Duration(days: 30)).millisecondsSinceEpoch,
        );
        break;
      case Constant.CUSTOM:
        await _pickCustomDate();
        return;
      default:
        newStartTime = Constant.formatDateV2(
          now.subtract(const Duration(days: 7)).millisecondsSinceEpoch,
        );
    }

    setState(() {
      this.filter = filter;
      fromDate = newStartTime;
      toDate = newEndTime;
      _bloc.add(
        GetAutoRenewHistoryEvent(
          fromDate,
          toDate,
          filter,
          pageAutoRenew,
          pageSizeAutoRenew,
        ),
      );
    });
  }

  Future<void> _pickCustomDate() async {
    final now = DateTime.now();

    final values = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.range,
        okButton: Container(
          margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
          child: Text(
            l10n.confirm,
            style: AppTextFonts.poppinsMedium.copyWith(
              fontSize: 14,
              color: AppColors.color_1618,
            ),
          ),
        ),
        cancelButton: Text(
          l10n.cancel,
          style: AppTextFonts.poppinsMedium.copyWith(
            fontSize: 14,
            color: AppColors.color_E11B,
          ),
        ),
        firstDate: DateTime(2000),
        lastDate: DateTime(now.year + 5),
        selectedDayHighlightColor: AppColors.color_E11B,
        selectedRangeHighlightColor: AppColors.color_E11B_10,
      ),
      value: [now.subtract(const Duration(days: 7)), now],
      dialogSize: const Size(320, 450),
      borderRadius: BorderRadius.circular(16),
      dialogBackgroundColor: AppColors.color_FFFF,
    );

    if (values != null &&
        values.length == 2 &&
        values[0] != null &&
        values[1] != null) {
      final start = values[0]!;
      final end = values[1]!;

      setState(() {
        fromDate = Constant.formatDateV2(start.millisecondsSinceEpoch);
        toDate = Constant.formatDateV2(end.millisecondsSinceEpoch);
        filter = Constant.CUSTOM;
      });
      pageAutoRenew = 1;
      _bloc.add(
        GetAutoRenewHistoryEvent(
          fromDate,
          toDate,
          filter,
          pageAutoRenew,
          pageSizeAutoRenew,
        ),
      );
    }
  }

  void _loadMoreAuto() {
    if (isLoadingMoreAuto || !hasMoreAuto) return;
    setState(() => isLoadingMoreAuto = true);
    pageAutoRenew++;
    _bloc.add(
      GetAutoRenewHistoryEvent(
        fromDate,
        toDate,
        filter,
        pageAutoRenew,
        pageSizeAutoRenew,
      ),
    );
  }

  void _loadMoreHistory() {
    if (isLoadingMoreHistory || !hasMoreHistory) return;
    setState(() => isLoadingMoreHistory = true);
    pageHistory++;
    _bloc.add(
      GetPaymentHistoryEvent(fromDate, toDate, pageHistory, pageSizeHistory),
    );
  }
}
