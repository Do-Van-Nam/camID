import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/data/model/charge_history_model.dart';
import 'package:cam_id/main/data/model/value_charging_history_model.dart';
import 'package:cam_id/main/data/model/value_child_charging_history_model.dart';
import 'package:cam_id/main/ui/charge_history/charge_history_bloc.dart';
import 'package:cam_id/main/ui/charge_history/charge_history_event.dart';
import 'package:cam_id/main/ui/charge_history/charge_history_state.dart';
import 'package:cam_id/main/utils/bottom_sheet/filter_bottom_sheet.dart';
import 'package:cam_id/main/utils/constant.dart';
import 'package:cam_id/main/utils/logger.dart';
import 'package:cam_id/main/utils/widget/loading_widget.dart';
import 'package:cam_id/res/app_colors.dart';
import 'package:cam_id/res/app_fonts.dart';
import 'package:cam_id/res/app_images.dart';
import 'package:cam_id/res/app_styles.dart';
import 'package:cam_id/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class ChargeHistoryPage extends StatefulWidget {
  const ChargeHistoryPage({super.key});
  @override
  State<ChargeHistoryPage> createState() => _ChargeHistoryPageState();
}

class _ChargeHistoryPageState extends State<ChargeHistoryPage> {
  late final ChargeHistoryBloc _bloc;

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  List<ChargeHistoryModel>? listChargingHistory;
  LoadingWidgetState viewState = LoadingWidgetState.loading;

  String _selectedType = Constant.HISTORY_BASIC;
  int _selectedIndex = 0;
  List<ValueChargingHistoryModel>? listBasic = [];
  List<ValueChargingHistoryModel>? listData = [];
  List<ValueChargingHistoryModel>? listCall = [];
  List<ValueChargingHistoryModel>? listSMS = [];
  List<ValueChargingHistoryModel>? listRoaming = [];
  final Set<String> _calledTypes = {};
  final Map<String, LoadingWidgetState> _viewStates = {
    Constant.HISTORY_BASIC: LoadingWidgetState.loading,
    Constant.HISTORY_DATA: LoadingWidgetState.loading,
    Constant.HISTORY_CALL: LoadingWidgetState.loading,
    Constant.HISTORY_SMS: LoadingWidgetState.loading,
    Constant.HISTORY_ROAMING: LoadingWidgetState.loading,
  };
  bool _showTabs = false;
  String selectedFilter = "last7days";
  int startTime = DateTime.now().subtract(const Duration(days: 7)).millisecondsSinceEpoch;
  int endTime = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();
    _bloc = ChargeHistoryBloc();
    _bloc.add(GetChargeHistoryEvent(startTime, Constant.HISTORY_BASIC));
    _calledTypes.add(_selectedType);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: BlocProvider.value(
        value: _bloc,
        child: BlocListener<ChargeHistoryBloc, ChargeHistoryState>(
          listener: (context, state) {
            if (state is ChargeHistoryLoading) {
              setState(() {
                viewState = LoadingWidgetState.loading;
              });
            }
            if (state is GetChargeHistorySuccess) {
              final type = state.type;
              setState(() {
                listChargingHistory = state.listChargingHistory;
                listBasic = state.listBasic;
                listData = state.listData;
                listCall = state.listCall;
                listSMS = state.listSMS;
                listRoaming = state.listRoaming;

                final currentList = switch (type) {
                  Constant.HISTORY_BASIC => listBasic,
                  Constant.HISTORY_DATA => listData,
                  Constant.HISTORY_CALL => listCall,
                  Constant.HISTORY_SMS => listSMS,
                  Constant.HISTORY_ROAMING => listRoaming,
                  _ => null,
                };

                _viewStates[type] = (currentList == null || currentList.isEmpty)
                    ? LoadingWidgetState.empty
                    : LoadingWidgetState.success;

                // if (!_showTabs &&
                //     type == Constant.HISTORY_BASIC &&
                //     currentList != null &&
                //     currentList.isNotEmpty) {
                //   _showTabs = true;
                // }
                if (!_showTabs &&
                    type == Constant.HISTORY_BASIC) {
                  _showTabs = true;
                }
              });
            }

            if (state is GetChargeHistoryFailure) {
              final type = state.type;
              setState(() {
                _viewStates[type] = LoadingWidgetState.empty;
              });
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.color_F7F7,
            body: BlocBuilder<ChargeHistoryBloc, ChargeHistoryState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      color: AppColors.color_FFFF,
                      child: SafeArea(
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
                                l10n.charge_history,
                                style: AppStyles.headerBlack,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: InkWell(
                                    onTap: () async {
                                      // showMyBottomSheet(context);
                                      final result = await showFilterBottomSheet(context, selectedFilter);
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
                                          style: AppTextFonts.poppinsRegular
                                              .copyWith(
                                                fontSize: 10,
                                                color: AppColors.color_E11B,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (_showTabs) ...[SizedBox(height: 16), _buildTabType()],
                    Expanded(
                      child: LoadingWidget(
                        state:
                            _viewStates[_selectedType] ??
                            LoadingWidgetState.loading,
                        child: IndexedStack(
                          index: _selectedIndex,
                          children: [
                            _buildTabList(
                              listBasic,
                              _buildListItem,
                              Constant.HISTORY_BASIC,
                            ),
                            _buildTabList(
                              listData,
                              _buildListItemOne,
                              Constant.HISTORY_DATA,
                            ),
                            _buildTabList(
                              listCall,
                              _buildListItemOne,
                              Constant.HISTORY_CALL,
                            ),
                            _buildTabList(
                              listSMS,
                              _buildListItemOne,
                              Constant.HISTORY_SMS,
                            ),
                            _buildTabList(
                              listRoaming,
                              _buildListItem,
                              Constant.HISTORY_ROAMING,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabList(
    List<ValueChargingHistoryModel>? items,
    Widget Function(ValueChargingHistoryModel, String) itemBuilder,
    String type,
  ) {
    if (items == null) return Container();
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, index) => itemBuilder(items[index], type),
    );
  }

  Widget _buildListItem(ValueChargingHistoryModel item, String type) {
    final call = item.valuesChild?.firstWhere(
      (e) => e.subType == Constant.HISTORY_CALL,
      orElse: () => ValueChildChargingHistoryModel(duration: 0, amount: 0),
    );

    final callDuration = call?.duration ?? 0;
    final callDurationText =
        "$callDuration ${callDuration > 1 ? l10n.seconds : l10n.second}";
    final sms = item.valuesChild?.firstWhere(
      (e) => e.subType == Constant.HISTORY_SMS,
      orElse: () => ValueChildChargingHistoryModel(duration: 0, amount: 0),
    );
    final smsDuration = sms?.duration ?? 0;
    final smsDurationText =
        "$smsDuration ${smsDuration > 1 ? l10n.messages : l10n.message}";

    final service = item.valuesChild?.firstWhere(
      (e) => e.subType == Constant.HISTORY_OTHER,
      orElse: () => ValueChildChargingHistoryModel(duration: 0, amount: 0),
    );
    final serviceDuration = service?.duration ?? 0;
    final serviceDurationText =
        "$serviceDuration ${serviceDuration > 1 ? l10n.services : l10n.service_}";
    final data = item.valuesChild?.firstWhere(
      (e) => e.subType == Constant.HISTORY_DATA,
      orElse: () => ValueChildChargingHistoryModel(duration: 0, amount: 0),
    );
    final dataDuration = data?.duration ?? 0;
    final dataDurationText = "$dataDuration ${Constant.MB}";
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(12, 8, 0, 0),
                  child: Text(
                    "${l10n.total} \$${item.total}",
                    style: AppTextFonts.poppinsSemiBold.copyWith(
                      fontSize: 14,
                      color: AppColors.color_1618,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 2, 2, 0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(AppImages.icCardChargeHistory),
                    InkWell(
                      onTap: () {
                        context.push(
                          PATH_CHARGE_HISTORY_DETAILS,
                          extra: {"type": type, "day": item.day},
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                        child: Row(
                          children: [
                            Text(
                              l10n.view_details,
                              style: AppTextFonts.poppinsRegular.copyWith(
                                fontSize: 12,
                                color: AppColors.color_E11B,
                              ),
                            ),
                            const SizedBox(width: 2),
                            SvgPicture.asset(
                              AppImages.icArrowRight,
                              colorFilter: const ColorFilter.mode(
                                AppColors.color_E11B,
                                BlendMode.srcIn,
                              ),
                              width: 18,
                              height: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.fromLTRB(12, 4, 0, 0),
            child: Text(
              item.day ?? "",
              style: AppTextFonts.poppinsRegular.copyWith(
                fontSize: 12,
                color: AppColors.color_8588,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(12, 12, 12, 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      SvgPicture.asset(AppImages.icHistoryCall),
                      const SizedBox(height: 8),
                      Text(
                        l10n.call,
                        style: AppTextFonts.poppinsMedium.copyWith(
                          fontSize: 12,
                          color: AppColors.color_1618,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        callDurationText,
                        style: AppTextFonts.poppinsRegular.copyWith(
                          fontSize: 10,
                          color: AppColors.color_8588,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "-\$${Constant.formatNumber(item.valuesChild?.firstWhere((e) => e.subType == Constant.HISTORY_CALL, orElse: () => ValueChildChargingHistoryModel(duration: 0, amount: 0)).amount ?? 0.0)}",
                        style: AppTextFonts.poppinsMedium.copyWith(
                          fontSize: 12,
                          color: AppColors.color_43B6,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 13.5),
                if (_selectedType == Constant.HISTORY_ROAMING) ...[
                  Expanded(
                    child: Column(
                      children: [
                        SvgPicture.asset(AppImages.icHistoryData),
                        const SizedBox(height: 8),
                        Text(
                          l10n.data,
                          style: AppTextFonts.poppinsMedium.copyWith(
                            fontSize: 12,
                            color: AppColors.color_1618,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          dataDurationText,
                          style: AppTextFonts.poppinsRegular.copyWith(
                            fontSize: 10,
                            color: AppColors.color_8588,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "-\$${Constant.formatNumber(item.valuesChild?.firstWhere((e) => e.subType == Constant.HISTORY_DATA, orElse: () => ValueChildChargingHistoryModel(duration: 0, amount: 0)).amount ?? 0.0)}",
                          style: AppTextFonts.poppinsMedium.copyWith(
                            fontSize: 12,
                            color: AppColors.color_43B6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 13.5),
                ],
                Expanded(
                  child: Column(
                    children: [
                      SvgPicture.asset(AppImages.icHistorySMS),
                      const SizedBox(height: 8),
                      Text(
                        l10n.sms,
                        style: AppTextFonts.poppinsMedium.copyWith(
                          fontSize: 12,
                          color: AppColors.color_1618,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        smsDurationText,
                        style: AppTextFonts.poppinsRegular.copyWith(
                          fontSize: 10,
                          color: AppColors.color_8588,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "-\$${Constant.formatNumber(item.valuesChild?.firstWhere((e) => e.subType == Constant.HISTORY_SMS, orElse: () => ValueChildChargingHistoryModel(duration: 0, amount: 0)).amount ?? 0.0)}",
                        style: AppTextFonts.poppinsMedium.copyWith(
                          fontSize: 12,
                          color: AppColors.color_43B6,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_selectedType == Constant.HISTORY_BASIC) ...[
                  SizedBox(width: 13.5),
                  Expanded(
                    child: Column(
                      children: [
                        SvgPicture.asset(AppImages.icHistoryService),
                        const SizedBox(height: 8),
                        Text(
                          l10n.service,
                          style: AppTextFonts.poppinsMedium.copyWith(
                            fontSize: 12,
                            color: AppColors.color_1618,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          serviceDurationText,
                          style: AppTextFonts.poppinsRegular.copyWith(
                            fontSize: 10,
                            color: AppColors.color_8588,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "-\$${Constant.formatNumber(item.valuesChild?.firstWhere((e) => e.subType == Constant.HISTORY_OTHER, orElse: () => ValueChildChargingHistoryModel(duration: 0, amount: 0)).amount ?? 0.0)}",
                          style: AppTextFonts.poppinsMedium.copyWith(
                            fontSize: 12,
                            color: AppColors.color_43B6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItemOne(ValueChargingHistoryModel item, String type) {
    final call = item.valuesChild?.firstWhere(
      (e) => e.subType == Constant.HISTORY_CALL,
      orElse: () => ValueChildChargingHistoryModel(duration: 0, amount: 0),
    );

    final callDuration = call?.duration ?? 0;
    final callDurationText =
        "$callDuration ${callDuration > 1 ? l10n.seconds : l10n.second}";
    final sms = item.valuesChild?.firstWhere(
      (e) => e.subType == Constant.HISTORY_SMS,
      orElse: () => ValueChildChargingHistoryModel(duration: 0, amount: 0),
    );
    final smsDuration = sms?.duration ?? 0;
    final smsDurationText =
        "$smsDuration ${smsDuration > 1 ? l10n.messages : l10n.message}";
    final data = item.valuesChild?.firstWhere(
      (e) => e.subType == Constant.HISTORY_DATA,
      orElse: () => ValueChildChargingHistoryModel(duration: 0, amount: 0),
    );
    final dataDuration = data?.duration ?? 0;
    final dataDurationText = "$dataDuration ${Constant.MB}";

    String durationText;
    String titleText;
    String amountText;
    String unit;
    String iconPath;
    switch (_selectedIndex) {
      case 1:
        titleText = l10n.data;
        durationText = dataDurationText;
        iconPath = AppImages.icHistoryData;
        break;
      case 2:
        titleText = l10n.call;
        durationText = callDurationText;
        iconPath = AppImages.icHistoryCall;

        break;
      case 3:
        titleText = l10n.sms;
        durationText = smsDurationText;
        iconPath = AppImages.icHistorySMS;
        break;
      default:
        titleText = "";
        durationText = "";
        iconPath = "";
    }

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(iconPath),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titleText,
                    style: AppTextFonts.poppinsRegular.copyWith(
                      color: AppColors.color_8588,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    durationText,
                    style: AppTextFonts.poppinsMedium.copyWith(
                      color: AppColors.color_1618,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${l10n.total} \$${item.total}",
                    style: AppTextFonts.poppinsRegular.copyWith(
                      color: AppColors.color_8588,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "\$${Constant.formatNumber(item.valuesChild?.firstWhere((e) => e.subType == Constant.HISTORY_DATA, orElse: () => ValueChildChargingHistoryModel(duration: 0, amount: 0)).amount ?? 0.0)}",
                    style: AppTextFonts.poppinsSemiBold.copyWith(
                      color: AppColors.color_E11B,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.color_F7F7,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text(
                  item.day ?? "",
                  style: AppTextFonts.poppinsRegular.copyWith(
                    fontSize: 12,
                    color: AppColors.color_464B,
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    context.push(
                      PATH_CHARGE_HISTORY_DETAILS,
                      extra: {"type": type, "day": item.day},
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        l10n.view_details,
                        style: AppTextFonts.poppinsRegular.copyWith(
                          fontSize: 12,
                          color: AppColors.color_1618,
                        ),
                      ),
                      SizedBox(width: 2),
                      SvgPicture.asset(
                        AppImages.icArrowRight,
                        colorFilter: ColorFilter.mode(
                          AppColors.color_1618,
                          BlendMode.srcIn,
                        ),
                        width: 18,
                        height: 18,
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
  }

  Widget _buildTabType() {
    return SizedBox(
      height: 105,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: listChargingHistory?.length ?? 0,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = listChargingHistory![index];
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 12 : 0,
              right: index == listChargingHistory!.length - 1 ? 12 : 0,
            ),
            child: _buildTabItem(item, _selectedIndex == index, index),
          );
        },
      ),
    );
  }

  Widget _buildTabItem(ChargeHistoryModel item, bool selected, int index) {
    return InkWell(
      onTap: () {
        final type = item.type ?? "";
        setState(() {
          _selectedIndex = index;
          _selectedType = type;
          viewState = _viewStates[type]!;
          AppLogger().logInfo("Charge History: $_selectedType");
        });
        if (!_calledTypes.contains(type)) {
          _viewStates[_selectedType] = LoadingWidgetState.loading;
          _bloc.add(GetChargeHistoryEvent(startTime, type));
          _calledTypes.add(type);
        }
      },
      child: Container(
        width: 90,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.color_E11B : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(_getIcon(item.type, selected)),
            const SizedBox(height: 8),
            Text(
              item.type ?? "",
              style: AppTextFonts.poppinsRegular.copyWith(
                fontSize: 10,
                color: selected ? AppColors.color_FFFF : AppColors.color_8588,
              ),
            ),
            const SizedBox(height: 2),
            _formatValueText(item.type, item.value, selected),
          ],
        ),
      ),
    );
  }

  String _getIcon(String? type, bool selected) {
    switch (type) {
      case Constant.HISTORY_BASIC:
        return selected
            ? AppImages.icTabBasicSelected
            : AppImages.icTabBasicUnSelected;
      case Constant.HISTORY_DATA:
        return selected
            ? AppImages.icTabDataSelected
            : AppImages.icTabDataUnSelected;
      case Constant.HISTORY_CALL:
        return selected
            ? AppImages.icTabCallSelected
            : AppImages.icTabCallUnSelected;
      case Constant.HISTORY_ROAMING:
        return selected
            ? AppImages.icTabRoamingSelected
            : AppImages.icTabRoamingUnSelected;
      case Constant.HISTORY_SMS:
        return selected
            ? AppImages.icTabSMSSelected
            : AppImages.icTabSMSUnSelected;
      default:
        return AppImages.icTabBasicUnSelected;
    }
  }

  List<ValueChargingHistoryModel>? get _currentList {
    switch (_selectedType) {
      case Constant.HISTORY_BASIC:
        return listBasic;
      case Constant.HISTORY_DATA:
        return listData;
      case Constant.HISTORY_CALL:
        return listCall;
      case Constant.HISTORY_SMS:
        return listSMS;
      case Constant.HISTORY_ROAMING:
        return listRoaming;
      default:
        return [];
    }
  }

  Widget _formatValueText(String? type, double? value, bool selected) {
    final v = value ?? 0;
    final number = Constant.formatNumber(v);

    final unit = switch (type) {
      Constant.HISTORY_BASIC => "\$",
      Constant.HISTORY_DATA || Constant.HISTORY_ROAMING => Constant.MB,
      Constant.HISTORY_CALL => Constant.MINS,
      Constant.HISTORY_SMS => Constant.SMS,
      _ => "",
    };

    return RichText(
      text: TextSpan(
        children: [
          if (type == Constant.HISTORY_BASIC)
            TextSpan(
              text: unit,
              style: AppTextFonts.poppinsRegular.copyWith(
                fontSize: 12,
                color: selected ? AppColors.color_FFFF : AppColors.color_1618,
              ),
            ),
          TextSpan(
            text: number,
            style: AppTextFonts.poppinsSemiBold.copyWith(
              fontSize: 14,
              color: selected ? AppColors.color_FFFF : AppColors.color_1618,
            ),
          ),
          if (type != Constant.HISTORY_BASIC && unit.isNotEmpty)
            TextSpan(
              text: " $unit",
              style: AppTextFonts.poppinsRegular.copyWith(
                fontSize: 12,
                color: selected ? AppColors.color_FFFF : AppColors.color_1618,
              ),
            ),
        ],
      ),
    );
  }

  void _updateFilter(String filter) {
    final now = DateTime.now();

    int newStartTime;
    int newEndTime = now.millisecondsSinceEpoch;

    switch (filter) {
      case "today":
        newStartTime = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
        break;
      case "last7days":
        newStartTime = now.subtract(const Duration(days: 7)).millisecondsSinceEpoch;
        break;
      case "last30days":
        newStartTime = now.subtract(const Duration(days: 30)).millisecondsSinceEpoch;
        break;
      case "custom":
        newStartTime = startTime;
        break;
      default:
        newStartTime = now.subtract(const Duration(days: 7)).millisecondsSinceEpoch;
    }

    setState(() {
      selectedFilter = filter;
      startTime = newStartTime;
      endTime = newEndTime;
      _calledTypes.clear();
      _viewStates[_selectedType] = LoadingWidgetState.loading;
      _bloc.add(GetChargeHistoryEvent(startTime, _selectedType));
    });
  }

}
