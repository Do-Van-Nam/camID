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
  Map<String, List<ValueChargingHistoryModel>> dataType = {};
  List<ChargeHistoryModel>? listChargingHistory;
  final startTime = DateTime.now().millisecondsSinceEpoch;
  final sevenDaysAgoTime = DateTime.now()
      .subtract(const Duration(days: 7))
      .millisecondsSinceEpoch;

  String _selectedType = "basic";
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _bloc = ChargeHistoryBloc();
    _bloc.add(GetChargeHistoryEvent(sevenDaysAgoTime, "basic"));
    _bloc.add(GetChargeHistoryEvent(sevenDaysAgoTime, "data"));
    _bloc.add(GetChargeHistoryEvent(sevenDaysAgoTime, "call"));
    _bloc.add(GetChargeHistoryEvent(sevenDaysAgoTime, "sms"));
    _bloc.add(GetChargeHistoryEvent(sevenDaysAgoTime, "roaming"));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocListener<ChargeHistoryBloc, ChargeHistoryState>(
        listener: (context, state) {
          if (state is GetChargeHistorySuccess) {
            setState(() {
              listChargingHistory = state.listChargingHistory;
              dataType = state.data;
            });
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
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      l10n.loyaltyHistory,
                      style: AppTextFonts.poppinsRegular.copyWith(
                        fontSize: 14,
                        color: AppColors.color_464B,
                      ),
                    ),
                  ),

                  SizedBox(height: 12),
                  _buildListByType(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTabType() {
    final list = listChargingHistory ?? [];

    return SizedBox(
      height: 105,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = list[index];

          EdgeInsetsGeometry padding = EdgeInsets.zero;
          if (index == 0) padding = const EdgeInsets.only(left: 12);
          if (index == list.length - 1) {
            padding = padding.add(const EdgeInsets.only(right: 12));
          }

          return Padding(
            padding: padding,
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                  _selectedType = item.type ?? "";
                });
              },
              child: Container(
                width: 90,
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                decoration: BoxDecoration(
                  color: _selectedIndex == index
                      ? AppColors.color_E11B
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                SvgPicture.asset(_getIcon(item.type, _selectedIndex == index)),
                    const SizedBox(height: 8),
                    Text(
                      item.type ?? "",
                      style: AppTextFonts.poppinsRegular.copyWith(
                        fontSize: 10,
                        color: AppColors.color_8588,
                      ),
                    ),
                    const SizedBox(height: 2),
                    _formatValueText(item.type, item.value),
                  ],
                ),
              ),
            ),
          );

        },
      ),
    );
  }

  Widget _buildListByType() {
    final items = dataType[_selectedType] ?? [];

    if (items.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            l10n.no_data,
            style: AppTextFonts.poppinsRegular.copyWith(
              fontSize: 12,
              color: AppColors.color_8588,
            ),
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(height: 12),
        itemBuilder: (_, index) {
          final item = items[index];
          return Container(
            padding: EdgeInsets.all(12),
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
        },
      ),
    );
  }

  String _getIcon(String? type, bool selected) {
    switch (type) {
      case 'basic':
        return selected ? AppImages.icTabBasicSelected : AppImages.icTabBasicUnSelected;
      case 'data':
        return selected ? AppImages.icTabDataSelected : AppImages.icTabDataUnSelected;
      case 'call':
        return selected ? AppImages.icTabCallSelected : AppImages.icTabCallUnSelected;
      case 'roaming':
        return selected ? AppImages.icTabRoamingSelected : AppImages.icTabRoamingUnSelected;
      case 'sms':
        return selected ? AppImages.icTabSMSSelected : AppImages.icTabSMSUnSelected;
      default:
        return AppImages.icTabBasicUnSelected;
    }
  }

  Widget _formatValueText(String? type, double? value) {
    final v = value ?? 0;
    final number = Constant.formatNumber(v);

    late final String unit;
    switch (type) {
      case 'basic':
        unit = "\$";
        break;
      case 'data':
      case 'roaming':
        unit = Constant.MB;
        break;
      case 'call':
        unit = Constant.MINS;
        break;
      case 'sms':
        unit = Constant.SMS;
        break;
      default:
        unit = "";
    }

    if (type == 'basic') {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: unit,
              style: AppTextFonts.poppinsRegular.copyWith(
                fontSize: 12,
                color: AppColors.color_1618,
              ),
            ),
            TextSpan(
              text: number,
              style: AppTextFonts.poppinsSemiBold.copyWith(
                fontSize: 14,
                color: AppColors.color_1618,
              ),
            ),
          ],
        ),
      );
    }

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: number,
            style: AppTextFonts.poppinsSemiBold.copyWith(
              fontSize: 14,
              color: AppColors.color_1618,
            ),
          ),
          if (unit.isNotEmpty)
            TextSpan(
              text: " $unit",
              style: AppTextFonts.poppinsRegular.copyWith(
                fontSize: 12,
                color: AppColors.color_1618,
              ),
            ),
        ],
      ),
    );
  }
}
