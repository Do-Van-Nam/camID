import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/data/repository/all_app_repository.dart';
import 'package:cam_id/main/data/share_preference/share_preference.dart';
import 'package:cam_id/main/ui/account_detail/account_detail_bloc.dart';
import 'package:cam_id/main/ui/account_detail/account_detail_event.dart';
import 'package:cam_id/main/ui/account_detail/account_detail_state.dart';
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

class AccountDetailPage extends StatefulWidget {
  const AccountDetailPage({super.key});
  @override
  State<AccountDetailPage> createState() => _AccountDetailPageState();
}

class _AccountDetailPageState extends State<AccountDetailPage> {
  late final AccountDetailBloc _bloc;
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  LoadingWidgetState viewState = LoadingWidgetState.success;

  String status = "";
  String activeDue = "";
  String expiredDue = "";
  String suspendedDue = "";
  List<String>? listActiveText;
  List<String>? listExpired;
  List<String>? listSuspended;
  @override
  void initState() {
    super.initState();
    _bloc = AccountDetailBloc(AppRepository());
    _bloc.add(GetAccountsOcsDetailEvent());
    _bloc.add(GetAllAppsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocListener<AccountDetailBloc, AccountDetailState>(
        listener: (context, state) {
          if (state is AccountDetailLoading) {
            setState(() {
              viewState = LoadingWidgetState.loading;
            });
          }
          if (state is GetAccountsOcsDetailSuccess) {
            setState(() {
              status = state.status;
              activeDue = state.activeDue;
              expiredDue = state.expiredDue;
              suspendedDue = state.suspendedDue;
              viewState = LoadingWidgetState.success;
            });
          }
          if (state is GetAccountsOcsDetailFailure) {
            setState(() {
              viewState = LoadingWidgetState.empty;
            });
          }
          if (state is GetAllAppSuccess) {
            setState(() {
              listActiveText = state.listActiveText;
              listExpired = state.listExpired;
              listSuspended = state.listSuspended;
            });
          }
          if (state is GetAllAppFailure) {
            setState(() {
              viewState = LoadingWidgetState.empty;
            });
          }
        },
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Scaffold(
            backgroundColor: AppColors.color_F7F7,
            body: _buildBody(context),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          width: double.infinity,
          child: Image.asset(AppImages.imgHeaderProfile, fit: BoxFit.cover),
        ),

        Column(
          children: [
            _buildHeader(context),

            Expanded(
              child: LoadingWidget(
                state: viewState,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(16, 24, 16, 0),
                        padding: EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: AppColors.color_FFFF,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(getStatusIcon()),
                                SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.account_status,
                                      style: AppTextFonts.poppinsRegular
                                          .copyWith(
                                            fontSize: 12,
                                            color: AppColors.color_8588,
                                          ),
                                    ),
                                    Text(
                                      getStatusText(),
                                      style: AppTextFonts.poppinsMedium
                                          .copyWith(
                                            fontSize: 16,
                                            color: getStatusColor(),
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.colorMain,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  // padding: const EdgeInsets.symmetric(vertical: 14),
                                  elevation: 0,
                                ),
                                child: Text(
                                  l10n.top_up,
                                  style: AppTextFonts.poppinsMedium.copyWith(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              getStatusDateText(),
                              style: AppTextFonts.poppinsRegular.copyWith(
                                fontSize: 12,
                                color: AppColors.color_1618,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                        // padding: EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: AppColors.color_43B6,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 3),
                            Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: AppColors.color_FFFF,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.fromLTRB(
                                        12,
                                        10,
                                        10,
                                        10,
                                      ),
                                      decoration: const BoxDecoration(
                                        color: AppColors.color_43B6_8,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(12),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            AppImages.icTickCircle,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            l10n.active,
                                            style: AppTextFonts.poppinsMedium
                                                .copyWith(
                                                  fontSize: 14,
                                                  color: AppColors.color_43B6,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            AppImages.icCalendar,
                                            colorFilter: const ColorFilter.mode(
                                              AppColors.color_464B,
                                              BlendMode.srcIn,
                                            ),
                                            height: 24,
                                            width: 24,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            (listActiveText != null &&
                                                    listActiveText!.length >= 3)
                                                ? replacePlaceholders(
                                                    listActiveText?[0] ?? "",
                                                    [activeDue],
                                                  )
                                                : "${l10n.until_date}: $activeDue",
                                            style: AppTextFonts.poppinsRegular
                                                .copyWith(
                                                  fontSize: 12,
                                                  color: AppColors.color_1E0D,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(AppImages.icCheckV2),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              (listActiveText != null &&
                                                      listActiveText!.length >=
                                                          3)
                                                  ? listActiveText![1]
                                                  : l10n.text_active_1,
                                              style: AppTextFonts.poppinsRegular
                                                  .copyWith(
                                                    fontSize: 12,
                                                    color: AppColors.color_1E0D,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: 12),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(AppImages.icCheckV2),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              (listActiveText != null &&
                                                      listActiveText!.length >=
                                                          3)
                                                  ? listActiveText![2]
                                                  : l10n.text_active_2,
                                              style: AppTextFonts.poppinsRegular
                                                  .copyWith(
                                                    fontSize: 12,
                                                    color: AppColors.color_1E0D,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                        // padding: EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: AppColors.color_F26F,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 3),
                            Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: AppColors.color_FFFF,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.fromLTRB(
                                        12,
                                        10,
                                        10,
                                        10,
                                      ),
                                      decoration: const BoxDecoration(
                                        color: AppColors.color_F26F_8,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(12),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(AppImages.icExpired),
                                          SizedBox(width: 8),
                                          Text(
                                            l10n.expired_validity,
                                            style: AppTextFonts.poppinsMedium
                                                .copyWith(
                                                  fontSize: 14,
                                                  color: AppColors.color_F26F,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            AppImages.icCalendar,
                                            colorFilter: const ColorFilter.mode(
                                              AppColors.color_464B,
                                              BlendMode.srcIn,
                                            ),
                                            height: 24,
                                            width: 24,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            (listExpired != null &&
                                                    listExpired!.length >= 4)
                                                ? replacePlaceholders(
                                                    listExpired?[0] ?? "",
                                                    [activeDue, expiredDue],
                                                  )
                                                : "${l10n.from_date}: $activeDue ${l10n.until} $expiredDue",
                                            style: AppTextFonts.poppinsRegular
                                                .copyWith(
                                                  fontSize: 12,
                                                  color: AppColors.color_1E0D,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(AppImages.icCheckV2),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              (listExpired != null &&
                                                      listExpired!.length >= 4)
                                                  ? listExpired![1]
                                                  : l10n.text_expired_1,
                                              style: AppTextFonts.poppinsRegular
                                                  .copyWith(
                                                    fontSize: 12,
                                                    color: AppColors.color_1E0D,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: 12),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(AppImages.icCloseV2),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              (listExpired != null &&
                                                      listExpired!.length >= 4)
                                                  ? listExpired![2]
                                                  : l10n.text_expired_2,
                                              style: AppTextFonts.poppinsRegular
                                                  .copyWith(
                                                    fontSize: 12,
                                                    color: AppColors.color_1E0D,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(AppImages.icCloseV2),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              (listExpired != null &&
                                                      listExpired!.length >= 4)
                                                  ? listExpired![3]
                                                  : l10n.text_expired_3,
                                              style: AppTextFonts.poppinsRegular
                                                  .copyWith(
                                                    fontSize: 12,
                                                    color: AppColors.color_1E0D,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                        // padding: EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: AppColors.color_E11B,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 3),
                            Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: AppColors.color_FFFF,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.fromLTRB(
                                        12,
                                        10,
                                        10,
                                        10,
                                      ),
                                      decoration: const BoxDecoration(
                                        color: AppColors.color_E11B_8,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(12),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            AppImages.icCloseCircle,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            l10n.temporarily_suspended,
                                            style: AppTextFonts.poppinsMedium
                                                .copyWith(
                                                  fontSize: 14,
                                                  color: AppColors.color_E11B,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            AppImages.icCalendar,
                                            colorFilter: const ColorFilter.mode(
                                              AppColors.color_464B,
                                              BlendMode.srcIn,
                                            ),
                                            height: 24,
                                            width: 24,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            (listSuspended != null &&
                                                    listSuspended!.length >= 3)
                                                ? replacePlaceholders(
                                                    listSuspended?[0] ?? "",
                                                    [expiredDue, suspendedDue],
                                                  )
                                                : "${l10n.from_date}: $expiredDue ${l10n.until} $suspendedDue",
                                            style: AppTextFonts.poppinsRegular
                                                .copyWith(
                                                  fontSize: 12,
                                                  color: AppColors.color_1E0D,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(AppImages.icCloseV2),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              (listSuspended != null &&
                                                      listSuspended!.length >=
                                                          3)
                                                  ? listSuspended![1]
                                                  : l10n.text_suspended_1,
                                              style: AppTextFonts.poppinsRegular
                                                  .copyWith(
                                                    fontSize: 12,
                                                    color: AppColors.color_1E0D,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: 12),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(AppImages.icCloseV2),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              (listSuspended != null &&
                                                      listSuspended!.length >=
                                                          3)
                                                  ? listSuspended![2]
                                                  : l10n.text_suspended_2,
                                              style: AppTextFonts.poppinsRegular
                                                  .copyWith(
                                                    fontSize: 12,
                                                    color: AppColors.color_1E0D,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(16, 16, 16, 24),
                        padding: EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: AppColors.color_FFFF,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(AppImages.icHotline),
                                SizedBox(width: 8),
                                Text(
                                  l10n.free_call_to_hotline,
                                  style: AppTextFonts.poppinsSemiBold.copyWith(
                                    fontSize: 14,
                                    color: AppColors.color_1618,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      SizedBox(height: 6),
                                      Text(
                                        l10n.police,
                                        style: AppTextFonts.poppinsRegular
                                            .copyWith(
                                              fontSize: 12,
                                              color: AppColors.color_464B,
                                            ),
                                      ),
                                      Text(
                                        "117",
                                        style: AppTextFonts.poppinsSemiBold
                                            .copyWith(
                                              fontSize: 14,
                                              color: AppColors.color_E11B,
                                            ),
                                      ),
                                      SizedBox(height: 6),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      SizedBox(height: 6),
                                      Text(
                                        l10n.fire_truck,
                                        style: AppTextFonts.poppinsRegular
                                            .copyWith(
                                              fontSize: 12,
                                              color: AppColors.color_464B,
                                            ),
                                      ),
                                      Text(
                                        "118",
                                        style: AppTextFonts.poppinsSemiBold
                                            .copyWith(
                                              fontSize: 14,
                                              color: AppColors.color_E11B,
                                            ),
                                      ),
                                      SizedBox(height: 6),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      SizedBox(height: 6),
                                      Text(
                                        l10n.ambulance,
                                        style: AppTextFonts.poppinsRegular
                                            .copyWith(
                                              fontSize: 12,
                                              color: AppColors.color_464B,
                                            ),
                                      ),
                                      Text(
                                        "119",
                                        style: AppTextFonts.poppinsSemiBold
                                            .copyWith(
                                              fontSize: 14,
                                              color: AppColors.color_E11B,
                                            ),
                                      ),
                                      SizedBox(height: 6),
                                    ],
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
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        // height: 100,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => {context.pop()},
              ),
            ),
            Text(l10n.account_detail, style: AppStyles.headerWhite),
          ],
        ),
      ),
    );
  }

  String replacePlaceholders(String text, List<String> values) {
    int index = 0;
    final regex = RegExp(r'%[^%]+%');

    return text.replaceAllMapped(regex, (match) {
      return index < values.length ? values[index++] : match.group(0)!;
    });
  }

  String getStatusText() {
    switch (status) {
      case Constant.ACTIVATED:
        return l10n.active;
      case Constant.EXPIRED:
        return l10n.expired_validity;
      case Constant.SUSPENEDE:
        return l10n.temporarily_suspended;
      default:
        return l10n.active;
    }
  }

  String getStatusIcon() {
    switch (status) {
      case Constant.ACTIVATED:
        return AppImages.icAccountActive;
      case Constant.EXPIRED:
        return AppImages.icAccountExpired;
      case Constant.SUSPENEDE:
        return AppImages.icAccountSuspended;
      default:
        return AppImages.icAccountActive;
    }
  }

  Color getStatusColor() {
    switch (status) {
      case Constant.ACTIVATED:
        return AppColors.color_43B6;
      case Constant.EXPIRED:
        return AppColors.color_F26F;
      case Constant.SUSPENEDE:
        return AppColors.color_E11B;
      default:
        return AppColors.color_43B6;
    }
  }

  String getStatusDateText() {
    switch (status) {
      case Constant.ACTIVATED:
        return "${l10n.until_date}: $activeDue";

      case Constant.EXPIRED:
        return "${l10n.from_date}: $expiredDue";

      case Constant.SUSPENEDE:
        return "${l10n.until_date}: $suspendedDue";

      default:
        return "${l10n.until_date}: $activeDue";
    }
  }
}
