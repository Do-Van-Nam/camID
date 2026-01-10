import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/data/model/value_child_charging_history_model.dart';
import 'package:cam_id/main/data/share_preference/share_preference.dart';
import 'package:cam_id/main/ui/charge_history_detail/charge_history_detail_bloc.dart';
import 'package:cam_id/main/ui/charge_history_detail/charge_history_detail_event.dart';
import 'package:cam_id/main/ui/charge_history_detail/charge_history_detail_state.dart';
import 'package:cam_id/main/ui/language/language_bloc.dart';
import 'package:cam_id/main/ui/language/language_event.dart';
import 'package:cam_id/main/utils/constant.dart';
import 'package:cam_id/main/utils/logger.dart';
import 'package:cam_id/main/utils/widget/loading_widget.dart';
import 'package:cam_id/res/app_colors.dart';
import 'package:cam_id/res/app_fonts.dart';
import 'package:cam_id/res/app_images.dart';
import 'package:cam_id/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class ChargeHistoryDetailPage extends StatefulWidget {
  final String type;
  final String day;
  const ChargeHistoryDetailPage(this.type, this.day, {super.key});

  @override
  State<ChargeHistoryDetailPage> createState() =>
      _ChargeHistoryDetailPageState();
}

class _TabInfo {
  final String key;
  final String label;
  _TabInfo(this.key, this.label);
}

class _ChargeHistoryDetailPageState extends State<ChargeHistoryDetailPage>
    with SingleTickerProviderStateMixin {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  late TabController _tabController;
  late final ChargeHistoryDetailBloc _bloc;
  late List<_TabInfo> _tabs;
  String subType = "all";
  final startTime = DateTime.now().millisecondsSinceEpoch;
  final sevenDaysAgoTime = DateTime.now()
      .subtract(const Duration(days: 7))
      .millisecondsSinceEpoch;
  LoadingWidgetState viewState = LoadingWidgetState.loading;

  List<ValueChildChargingHistoryModel> listAll = [];
  List<ValueChildChargingHistoryModel> listCall = [];
  List<ValueChildChargingHistoryModel> listData = [];
  List<ValueChildChargingHistoryModel> listSMS = [];
  List<ValueChildChargingHistoryModel> listService = [];

  @override
  void initState() {
    super.initState();
    _bloc = ChargeHistoryDetailBloc();

    final timestamp = Constant.parseTimestamp(widget.day);

    _bloc.add(GetChargeHistoryDetailEvent(timestamp, widget.type, subType));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _tabs = _buildTabs(widget.type);
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: BlocProvider.value(
        value: _bloc,
        child: BlocListener<ChargeHistoryDetailBloc, ChargeHistoryDetailState>(
          listener: (context, state) {
            if(state is ChargeHistoryDetailLoading){
              setState(() {
                viewState = LoadingWidgetState.loading;
              });
            }
            if (state is GetChargeHistoryDetailSuccess) {
              setState(() {
                listAll = state.listAll ?? [];
                listCall = state.listCall ?? [];
                listData = state.listData ?? [];
                listSMS = state.listSMS ?? [];
                listService = state.listService ?? [];
                viewState = LoadingWidgetState.success;
              });
            }
            if (state is GetChargeHistoryDetailFailure) {
              setState(() {
                viewState = LoadingWidgetState.empty;
              });
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.color_F7F7,
            body: BlocBuilder<ChargeHistoryDetailBloc, ChargeHistoryDetailState>(
              builder: (context, state) {
                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      color: AppColors.color_FFFF,
                      child: Column(
                        children: [
                          SafeArea(
                            bottom: false,
                            child: SizedBox(
                              height: kToolbarHeight,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.arrow_back_ios_new,
                                        color: AppColors.color_1618,
                                      ),
                                      onPressed: () => context.pop(),
                                    ),
                                  ),
                                  Text(
                                    "${capitalize(widget.type)} - ${widget.day}",
                                    style: AppStyles.headerBlack,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (_tabs.length > 1)
                            Container(
                              height: 44,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: AppColors.color_F7F7,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TabBar(
                                controller: _tabController,
                                indicator: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                indicatorColor: Colors.grey,
                                dividerColor: Colors.transparent,
                                indicatorSize: TabBarIndicatorSize.tab,
                                labelColor: Colors.white,
                                unselectedLabelColor: Colors.black,
                                tabs: _tabs.map((e) {
                                  return Tab(
                                    child: Text(
                                      e.label,
                                      style: AppTextFonts.poppinsSemiBold
                                          .copyWith(fontSize: 14),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _tabs.length > 1
                          ? TabBarView(
                        controller: _tabController,
                        children: _tabs.map((tab) {
                          final list = _getListByTab(tab.key);

                          if (viewState == LoadingWidgetState.loading) {
                            return LoadingWidget(
                              state: LoadingWidgetState.loading,
                              child: const SizedBox.shrink(),
                            );
                          }

                          if (list.isEmpty) {
                            return LoadingWidget(
                              state: LoadingWidgetState.empty,
                              child: const SizedBox.shrink(),
                            );
                          }

                          return LoadingWidget(
                            state: LoadingWidgetState.success,
                            child: _buildList(list),
                          );
                        }).toList(),
                      )
                          : Builder(
                        builder: (_) {
                          final list = _getListByTab(_tabs[0].key);

                          if (viewState == LoadingWidgetState.loading) {
                            return LoadingWidget(
                              state: LoadingWidgetState.loading,
                              child: const SizedBox.shrink(),
                            );
                          }

                          if (list.isEmpty) {
                            return LoadingWidget(
                              state: LoadingWidgetState.empty,
                              child: const SizedBox.shrink(),
                            );
                          }

                          return LoadingWidget(
                            state: LoadingWidgetState.success,
                            child: _buildList(list),
                          );
                        },
                      ),
                    )

                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildList(List<ValueChildChargingHistoryModel> list) {
    if (list.isEmpty) {
      return Center(child: Text(l10n.no_data));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, i) {
        final item = list[i];
        return Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              SvgPicture.asset(_typeIcon(item), width: 54, height: 54),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title ?? "",
                      style: AppTextFonts.poppinsSemiBold.copyWith(
                        fontSize: 14,
                        color: AppColors.color_1618,
                      ),
                      maxLines: 1,
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        SvgPicture.asset(
                          AppImages.icCalendarCircle,
                          height: 14,
                          width: 14,
                        ),
                        SizedBox(width: 4),
                        Text(
                          item.time ?? "",
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
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "\$${Constant.formatNumber(item.amount ?? 0.0)}",
                    style: AppTextFonts.poppinsSemiBold.copyWith(
                      fontSize: 14,
                      color: AppColors.color_43B6,
                    ),
                  ),
                  Text(
                    "${item.duration ?? 0} ${_formatTypeWithPlural(item)}",
                    style: AppTextFonts.poppinsRegular.copyWith(
                      fontSize: 12,
                      color: AppColors.color_8588,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatTypeWithPlural(ValueChildChargingHistoryModel item) {
    final count = item.duration ?? 0;
    final base = _typeName(item);
    return count > 1 ? "${base}s" : base;
  }

  String _typeName(ValueChildChargingHistoryModel item) {
    switch (item.subType) {
      case Constant.HISTORY_CALL:
        return l10n.call;
      case Constant.HISTORY_SMS:
        return l10n.sms;
      case Constant.HISTORY_DATA:
        return l10n.data;
      case Constant.HISTORY_OTHER:
        return l10n.service;
      default:
        return "";
    }
  }

  String _typeIcon(ValueChildChargingHistoryModel item) {
    switch (item.subType) {
      case Constant.HISTORY_CALL:
        return AppImages.icHistoryCall;
      case Constant.HISTORY_SMS:
        return AppImages.icHistorySMS;
      case Constant.HISTORY_DATA:
        return AppImages.icHistoryData;
      case Constant.HISTORY_OTHER:
        return AppImages.icHistoryService;
      default:
        return AppImages.icHistoryService;
    }
  }

  List<ValueChildChargingHistoryModel> _getListByTab(String key) {
    switch (key) {
      case Constant.HISTORY_CALL:
        return listCall;
      case Constant.HISTORY_SMS:
        return listSMS;
      case Constant.HISTORY_DATA:
        return listData;
      case Constant.HISTORY_SERVICE:
        return listService;
      default:
        return listAll;
    }
  }

  List<_TabInfo> _buildTabs(String type) {
    if (type == Constant.HISTORY_BASIC) {
      return [
        _TabInfo("all", l10n.all),
        _TabInfo("call", l10n.call),
        _TabInfo("sms", l10n.sms),
        _TabInfo("service", l10n.service),
      ];
    }

    if (type == Constant.HISTORY_ROAMING) {
      return [
        _TabInfo("all", l10n.all),
        _TabInfo("call", l10n.call),
        _TabInfo("sms", l10n.sms),
        _TabInfo("data", l10n.data),
      ];
    }

    return [_TabInfo(type, _mapLabel(type))];
  }

  String _mapLabel(String type) {
    switch (type) {
      case Constant.HISTORY_CALL:
        return l10n.call;
      case Constant.HISTORY_SMS:
        return l10n.sms;
      case Constant.HISTORY_DATA:
        return l10n.data;
    }
    return l10n.all;
  }

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
