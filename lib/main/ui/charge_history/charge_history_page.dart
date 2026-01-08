import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/data/model/charge_history_model.dart';
import 'package:cam_id/main/data/model/value_charging_history_model.dart';
import 'package:cam_id/main/data/share_preference/share_preference.dart';
import 'package:cam_id/main/ui/charge_history/charge_history_bloc.dart';
import 'package:cam_id/main/ui/charge_history/charge_history_event.dart';
import 'package:cam_id/main/ui/charge_history/charge_history_state.dart';
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

class ChargeHistoryPage extends StatefulWidget {
  const ChargeHistoryPage({super.key});
  @override
  State<ChargeHistoryPage> createState() => _ChargeHistoryPageState();
}

class _ChargeHistoryPageState extends State<ChargeHistoryPage> {
  late final ChargeHistoryBloc _bloc;

  late final l10n = AppLocalizations.of(context)!;
  List<ChargeHistoryModel>? listChargingHistory;
  final startTime = DateTime.now().millisecondsSinceEpoch;
  final sevenDaysAgoTime = DateTime.now()
      .subtract(const Duration(days: 7))
      .millisecondsSinceEpoch;
  LoadingWidgetState viewState = LoadingWidgetState.loading;
  LoadingWidgetState viewStateChild = LoadingWidgetState.success;

  String _selectedType = Constant.HISTORY_BASIC;
  int _selectedIndex = 0;
  List<ValueChargingHistoryModel>? listBasic = [];
  List<ValueChargingHistoryModel>? listData = [];
  List<ValueChargingHistoryModel>? listCall = [];
  List<ValueChargingHistoryModel>? listSMS = [];
  List<ValueChargingHistoryModel>? listRoaming = [];
  final Set<String> _calledTypes = {};

  @override
  void initState() {
    super.initState();
    _bloc = ChargeHistoryBloc();
    _bloc.add(GetChargeHistoryEvent(sevenDaysAgoTime, Constant.HISTORY_BASIC));
    _calledTypes.add(_selectedType);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocListener<ChargeHistoryBloc, ChargeHistoryState>(
        listener: (context, state) {
          if (state is ChargeHistoryLoading) {
            viewState = LoadingWidgetState.loading;
          }
          if (state is GetChargeHistorySuccess) {
            setState(() {
              listChargingHistory = state.listChargingHistory;
              listBasic = state.listBasic;
              listData = state.listData;
              listCall = state.listCall;
              listSMS = state.listSMS;
              listRoaming = state.listRoaming;
            });
            viewState = LoadingWidgetState.success;
          }
          if (state is GetChargeHistoryFailure) {
            viewState = LoadingWidgetState.empty;
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
            title: Text(l10n.charge_history, style: AppStyles.headerBlack),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: InkWell(
                  onTap: () {},
                  child: Row(
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
              ),
            ],
          ),
          body: BlocBuilder<ChargeHistoryBloc, ChargeHistoryState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  _buildTabType(),
                  Expanded(
                    child: LoadingWidget(
                      state: viewState,
                      // onRetry: _initData,
                      child: _buildBody(context),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // Widget _buildBody(BuildContext context) {
  //   List<ValueChargingHistoryModel>? items;
  //   items = _currentList;
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const SizedBox(height: 16),
  //       if (items != null && items.isNotEmpty)
  //         Container(
  //           padding: const EdgeInsets.symmetric(horizontal: 16),
  //           child: Text(
  //             l10n.loyaltyHistory,
  //             style: AppTextFonts.poppinsRegular.copyWith(
  //               fontSize: 14,
  //               color: AppColors.color_464B,
  //             ),
  //           ),
  //         ),
  //       const SizedBox(height: 12),
  //       _buildListByType(),
  //     ],
  //   );
  // }
  Widget _buildBody(BuildContext context) {
    final items = _currentList;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        if (items != null && items.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              l10n.loyaltyHistory,
              style: AppTextFonts.poppinsRegular.copyWith(
                fontSize: 14,
                color: AppColors.color_464B,
              ),
            ),
          ),
        const SizedBox(height: 12),
        Expanded(
          child: LoadingWidget(
            state: (items?.isEmpty ?? true)
                ? LoadingWidgetState.empty
                : LoadingWidgetState.success,
            child: (items?.isEmpty ?? true)
                ? Container()
                : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: items!.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, index) {
                final item = items[index];
                return _buildListItem(item);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(ValueChargingHistoryModel item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.day ?? '',
            style: AppTextFonts.poppinsSemiBold.copyWith(
              fontSize: 14,
              color: AppColors.color_1618,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "${item.total ?? 0} - ${item.duration ?? 0}",
            style: AppTextFonts.poppinsRegular.copyWith(
              fontSize: 12,
              color: AppColors.color_464B,
            ),
          ),
          if (item.valuesChild != null)
            Column(
              children: item.valuesChild!.map((e) {
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    "${e.subType} - ${e.amount} - ${e.duration}",
                    style: AppTextFonts.poppinsRegular.copyWith(
                      fontSize: 12,
                      color: AppColors.color_8588,
                    ),
                  ),
                );
              }).toList(),
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
        setState(() {
          _selectedIndex = index;
          _selectedType = item.type ?? "";
        });
        if (!_calledTypes.contains(_selectedType)) {
          _bloc.add(GetChargeHistoryEvent(sevenDaysAgoTime, _selectedType));
          _calledTypes.add(_selectedType);
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
      case Constant.HISTORY_SMS:
        return selected
            ? AppImages.icTabRoamingSelected
            : AppImages.icTabRoamingUnSelected;
      case Constant.HISTORY_ROAMING:
        return selected
            ? AppImages.icTabSMSSelected
            : AppImages.icTabSMSUnSelected;
      default:
        return AppImages.icTabBasicUnSelected;
    }
  }

  List<ValueChargingHistoryModel>? get _currentList {
    switch (_selectedType) {
      case Constant.HISTORY_BASIC: return listBasic;
      case Constant.HISTORY_DATA: return listData;
      case Constant.HISTORY_CALL: return listCall;
      case Constant.HISTORY_SMS: return listSMS;
      case Constant.HISTORY_ROAMING: return listRoaming;
      default: return [];
    }
  }

  Widget _formatValueText(String? type, double? value, bool selected) {
    final v = value ?? 0;
    final number = Constant.formatNumber(v);

    final unit = switch(type) {
      Constant.HISTORY_BASIC => "\$",
      Constant.HISTORY_DATA || Constant.HISTORY_ROAMING => Constant.MB,
      Constant.HISTORY_CALL => Constant.MINS,
      Constant.HISTORY_SMS => Constant.SMS,
      _ => ""
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
}
