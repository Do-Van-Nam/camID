import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/data/model/my_service_group_model.dart';
import 'package:cam_id/main/data/model/service_group_model.dart';
import 'package:cam_id/main/ui/metfone_service/metfone_service_bloc.dart';
import 'package:cam_id/main/ui/metfone_service/metfone_service_event.dart';
import 'package:cam_id/main/ui/metfone_service/metfone_service_state.dart';
import 'package:cam_id/main/utils/constant.dart';
import 'package:cam_id/main/utils/dialog/confirm_renew_dialog.dart';
import 'package:cam_id/main/utils/package_short_des.dart';
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

class MetfoneServicePage extends StatefulWidget {
  const MetfoneServicePage({super.key});
  @override
  State<MetfoneServicePage> createState() => _MetfoneServicePageState();
}

class _MetfoneServicePageState extends State<MetfoneServicePage>
    with SingleTickerProviderStateMixin {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  late final MetfoneServiceBloc _bloc;
  late TabController _tabController;
  List<MyServiceGroup>? listServiceForYou = [];
  List<ServiceGroup>? listMyService = [];
  LoadingWidgetState viewState = LoadingWidgetState.loading;
  LoadingWidgetState viewStateForYou = LoadingWidgetState.loading;
  LoadingWidgetState viewStateMyService = LoadingWidgetState.loading;

  final List<ServiceGroup> fakeList = [
    ServiceGroup()
      ..name = "Data Daily"
      ..code = "D1"
      ..shortDes = "Data: 1GB; Time: 24h"
      ..iconUrl = "https://example.com/icon_d1.png"
      ..price = 1.0
      ..state = 1
      ..validity = "1 Day"
      ..autoRenew = "Yes"
      ..currency = "USD"
      ..expired = "2026-12-31",

    ServiceGroup()
      ..name = "Combo Week"
      ..code = "C7"
      ..shortDes = "Data: 7GB; SMS: 50; Time: 7 days"
      ..iconUrl = "https://example.com/icon_c7.png"
      ..price = 3.5
      ..state = 1
      ..validity = "7 Days"
      ..autoRenew = "No"
      ..currency = "USD"
      ..expired = "2026-12-31",

    ServiceGroup()
      ..name = "Unlimited Month"
      ..code = "U30"
      ..shortDes = "Data: Unlimited; SMS: 200; Time: 30 days"
      ..iconUrl = "https://example.com/icon_unlimited.png"
      ..price = 10.0
      ..state = 1
      ..validity = "30 Days"
      ..autoRenew = "Yes"
      ..currency = "USD"
      ..expired = "2026-12-31",
  ];

  @override
  void initState() {
    super.initState();
    _bloc = MetfoneServiceBloc();
    _tabController = TabController(length: 2, vsync: this);
    _bloc.add(GetServiceForYouEvent());
    _bloc.add(GetMyServicesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocListener<MetfoneServiceBloc, MetfoneServiceState>(
        listener: (context, state) {
          if (state is MetfoneServiceLoading) {
            setState(() {
              viewStateForYou = LoadingWidgetState.loading;
              viewStateMyService = LoadingWidgetState.loading;
            });
          }
          if (state is DoActionLoading) {
            LoadingOverlayWidget.show(context);
          }

          if (state is GetServiceForYouSuccess) {
            setState(() {
              viewStateForYou = LoadingWidgetState.success;
              listServiceForYou = state.listService;
            });
          }
          if (state is GetServiceForYouFailure) {
            setState(() {
              viewStateForYou = LoadingWidgetState.empty;
            });
          }
          if (state is GetMyServiceSuccess) {
            setState(() {
              viewStateMyService = LoadingWidgetState.success;
              listMyService = state.listService;
              // listMyService = fakeList;
            });
          }
          if (state is GetMyServiceFailure) {
            setState(() {
              viewStateMyService = LoadingWidgetState.empty;
              // viewStateMyService = LoadingWidgetState.success;
              // listMyService = fakeList;
            });
          }
          if (state is StopActionServiceSuccess) {
            LoadingOverlayWidget.hide();
            _bloc.add(GetServiceForYouEvent());
            _bloc.add(GetMyServicesEvent());
          }
          if (state is StopActionServiceFailure) {
            LoadingOverlayWidget.hide();
            AppToast.show(
              context,
              state.message.isNotEmpty ? state.message : l10n.error_occurred,
            );
          }
          if (state is DoActionServiceSuccess) {
            LoadingOverlayWidget.hide();
            _bloc.add(GetServiceForYouEvent());
            _bloc.add(GetMyServicesEvent());
          }
          if (state is DoActionServiceFailure) {
            LoadingOverlayWidget.hide();
            AppToast.show(
              context,
              state.message.isNotEmpty ? state.message : l10n.error_occurred,
            );
          }
        },
        child: Scaffold(
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
            title: Text(l10n.metfone_services, style: AppStyles.headerBlack),
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
                      Tab(child: Text(l10n.services_for_you)),
                      Tab(child: Text(l10n.my_services)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          backgroundColor: AppColors.color_F7F7,
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildTabContent(listServiceForYou, viewStateForYou),
              _buildTabMyService(listMyService, viewStateMyService),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(List? list, LoadingWidgetState state) {
    if (state == LoadingWidgetState.loading) {
      return LoadingWidget(
        state: LoadingWidgetState.loading,
        child: const SizedBox.shrink(),
      );
    }

    if (list == null || list.isEmpty) {
      return LoadingWidget(
        state: LoadingWidgetState.empty,
        child: const SizedBox.shrink(),
      );
    }

    return LoadingWidget(
      state: LoadingWidgetState.success,
      child: _buildItemPackage(),
    );
  }

  Widget _buildTabMyService(List? list, LoadingWidgetState state) {
    if (state == LoadingWidgetState.loading) {
      return LoadingWidget(
        state: LoadingWidgetState.loading,
        child: const SizedBox.shrink(),
      );
    }

    if (list == null || list.isEmpty) {
      return LoadingWidget(
        state: LoadingWidgetState.empty,
        child: const SizedBox.shrink(),
      );
    }

    return LoadingWidget(
      state: LoadingWidgetState.success,
      child: _buildItemPackageMyService(),
    );
  }

  Widget _buildItemPackage() {
    final list = listServiceForYou ?? [];

    if (list.isEmpty) {
      return const SizedBox.shrink();
    }
    // final listService = list[0].services;
    final allServices = list
        .where((g) => g.services != null)
        .expand((g) => g.services!)
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: allServices.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (context, index) {
          final item = allServices[index];
          final info = parseShortDes(item.shortDes);
          return Container(
            width: 163,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [AppColors.color_E11B, AppColors.color_FF34],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 44,
                  padding: const EdgeInsets.fromLTRB(12, 15, 12, 12),
                  child: Row(
                    children: [
                      Text(
                        item.name ?? "NAME",
                        style: AppTextFonts.poppinsRegular.copyWith(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      if (info.isParsed)
                        Text(
                          info.data!,
                          style: AppTextFonts.poppinsSemiBold.copyWith(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                    decoration: BoxDecoration(
                      color: AppColors.color_FFFF,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.color_5F5F,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        '\$${Constant.formatNumber(item.price ?? 0.0)}/',
                                    style: AppTextFonts.poppinsSemiBold
                                        .copyWith(
                                          fontSize: 20,
                                          color: AppColors.color_1618,
                                        ),
                                  ),
                                  TextSpan(
                                    text: item.validity,
                                    style: AppTextFonts.poppinsRegular.copyWith(
                                      fontSize: 16,
                                      color: AppColors.color_1618,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(AppImages.icCheck),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                info.time ?? '',
                                style: AppTextFonts.poppinsRegular.copyWith(
                                  color: AppColors.color_8588,
                                  fontSize: 12,
                                ),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (info.isParsed)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(AppImages.icCheck),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  info.sms ?? '',
                                  style: AppTextFonts.poppinsRegular.copyWith(
                                    color: AppColors.color_8588,
                                    fontSize: 12,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        const Spacer(),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 36,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.color_FFFF,
                              elevation: 0,
                              side: const BorderSide(
                                color: AppColors.color_1618,
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1000),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 4),
                            ),
                            child: Text(
                              l10n.register,
                              style: AppTextFonts.poppinsRegular.copyWith(
                                color: AppColors.color_1618,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildItemPackageMyService() {
    final list = listMyService ?? [];

    if (list.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = list[index];
        bool isOn = item.autoRenew == "1";
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.color_FFFF,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(AppImages.icLogoV2),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name ?? "",
                          style: AppTextFonts.poppinsMedium.copyWith(
                            fontSize: 14,
                            color: AppColors.color_1618,
                          ),
                        ),
                        SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              AppImages.icCalendarCircle,
                              height: 14,
                              width: 14,
                            ),
                            SizedBox(width: 4),
                            Text(
                              item.expired ?? "",
                              style: AppTextFonts.poppinsRegular.copyWith(
                                fontSize: 12,
                                color: AppColors.color_8588,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Transform.scale(
                    scale: 0.9,
                    child: CupertinoSwitch(
                      value: isOn,
                      onChanged: (v) {
                        ConfirmRenewDialog.show(
                          context,
                          title: l10n.confirm,
                          isOn: isOn,
                          onContinue: () {
                            setState(() {
                              // list[index].autoRenew = v ? "1" : "0";
                              if (isOn) {
                                _bloc.add(StopActionServiceEvent(item.code!));
                              } else {
                                _bloc.add(
                                  DoActionServiceEvent(
                                    item.autoCode!,
                                    "",
                                    item.name!,
                                    "${Constant.SUPER_EXCHANGE} ${item.name}",
                                    342,
                                    ""
                                  ),
                                );
                              }
                            });
                          },
                        );
                      },
                      activeTrackColor: AppColors.color_43B6,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                item.shortDes ?? "",
                style: AppTextFonts.poppinsRegular.copyWith(
                  fontSize: 14,
                  color: AppColors.color_464B,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 12),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.color_F7F7,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Text(
                      l10n.price,
                      style: AppTextFonts.poppinsRegular.copyWith(
                        fontSize: 14,
                        color: AppColors.color_8588,
                      ),
                    ),
                    Spacer(),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                '\$${Constant.formatNumber(item.price ?? 0.0)}/',
                            style: AppTextFonts.poppinsMedium.copyWith(
                              fontSize: 16,
                              color: AppColors.color_E11B,
                            ),
                          ),
                          TextSpan(
                            text: item.validity,
                            style: AppTextFonts.poppinsRegular.copyWith(
                              fontSize: 12,
                              color: AppColors.color_464B,
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
        );
      },
    );
  }
}
