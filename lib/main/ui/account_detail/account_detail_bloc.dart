import 'package:cam_id/main/base/base_response_v2.dart';
import 'package:cam_id/main/base/base_result.dart';
import 'package:cam_id/main/data/api/api_end_point.dart';
import 'package:cam_id/main/data/api/api_util.dart';
import 'package:cam_id/main/data/model/account_ocs_detail.dart';
import 'package:cam_id/main/data/model/banner_model.dart';
import 'package:cam_id/main/data/model/charge_history_model.dart';
import 'package:cam_id/main/data/model/value_child_charging_history_model.dart';
import 'package:cam_id/main/data/repository/all_app_repository.dart';
import 'package:cam_id/main/data/share_preference/share_preference.dart';
import 'package:cam_id/main/ui/account_detail/account_detail_event.dart';
import 'package:cam_id/main/ui/account_detail/account_detail_state.dart';
import 'package:cam_id/main/ui/charge_history_detail/charge_history_detail_event.dart';
import 'package:cam_id/main/ui/charge_history_detail/charge_history_detail_state.dart';
import 'package:cam_id/main/utils/constant.dart';
import 'package:cam_id/main/utils/device_utils.dart';
import 'package:cam_id/main/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountDetailBloc extends Bloc<AccountDetailEvent, AccountDetailState> {
  final AppRepository appRepo;

  AccountDetailBloc(this.appRepo) : super(AccountDetailInitial()) {
    on<GetAccountsOcsDetailEvent>(_onGetAccountsOcsDetail);
    on<GetAllAppsEvent>(_onGetAllApp);
  }

  Future<void> _onGetAccountsOcsDetail(
    GetAccountsOcsDetailEvent event,
    Emitter<AccountDetailState> emit,
  ) async {
    emit(AccountDetailLoading());
    final language = await SharePreferenceUtil.getLanguageCode();
    final isdn = await SharePreferenceUtil.getString(ShareKey.KEY_PHONE_NUMBER);

    final body = {
      "language": language,
      "sessionId": "",
      "token": "",
      "versionApp": DeviceUtils.getVersion(),
      "wsCode": WSCode.wsGetAccountsOcsDetail,
      "wsRequest": {"isdn": isdn, "language": language, "subType": 1},
    };

    try {
      final result = await ApiUtil.getInstance()!
          .postParsed<BaseResponseV2<BaseResult<List<AccountOcsDetail>>>>(
            url: ApiEndPoint.API_USER_ROUTING,
            body: body,
            fromJson: (json) => BaseResponseV2.fromJson(
              json,
              (data) => BaseResult<List<AccountOcsDetail>>.fromJson(
                data,
                (list) => (list as List)
                    .map((e) => AccountOcsDetail.fromJson(e))
                    .toList(),
              ),
            ),
          );

      if (result.isSuccess && result.result?.wsResponse != null) {
        final wsResponse = result.result?.wsResponse ?? [];
        String status = "";
        String activeDue = "";
        String expiredDue = "";
        String suspendedDue = "";

        wsResponse
            .where((e) => e.title == "GENERAL INFO")
            .toList()
            .firstOrNull
            ?.values
            ?.forEach((item) {
              switch (item.title) {
                case "Status":
                  status = item.value ?? "";
                  break;
                case "Block One Way Date":
                  activeDue = Constant.formatDate(item.value);
                  break;
                case "Block Two Ways Date":
                  expiredDue = Constant.formatDate(item.value);
                  break;
                case "Deleted Date":
                  suspendedDue = Constant.formatDate(item.value);
                  break;
              }
            });

        emit(
          GetAccountsOcsDetailSuccess(
            status,
            activeDue,
            expiredDue,
            suspendedDue,
          ),
        );
      } else {
        emit(GetAccountsOcsDetailFailure(result.result?.message ?? ""));
      }
    } catch (e) {
      AppLogger().logError(e.toString());
      emit(GetAccountsOcsDetailFailure(e.toString()));
    }
  }

  Future<void> _onGetAllApp(
    GetAllAppsEvent event,
    Emitter<AccountDetailState> emit,
  ) async {
    final language = await SharePreferenceUtil.getLanguageCode();

    try {
      final response = await appRepo.getAllApps(force: event.isCallAPI);
      final ads = response.adBanner ?? [];

      List<String> buildList(int type) {
        final filtered = ads
            .where((e) => e.type == type && e.objData1 == language)
            .toList();

        filtered.sort((a, b) {
          final oa = int.tryParse(a.orderBy ?? '0') ?? 0;
          final ob = int.tryParse(b.orderBy ?? '0') ?? 0;
          return oa.compareTo(ob);
        });

        return filtered.map((e) => e.des ?? "").toList();
      }

      final lstActiveText = buildList(111);
      final lstExpired = buildList(112);
      final lstSuspended = buildList(113);

      emit(GetAllAppSuccess(lstActiveText, lstExpired, lstSuspended));
    } catch (e) {
      emit(GetAllAppFailure(""));
    }
  }
}
