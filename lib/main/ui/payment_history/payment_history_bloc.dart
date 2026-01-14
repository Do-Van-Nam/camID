import 'package:cam_id/main/base/base_response_v2.dart';
import 'package:cam_id/main/base/base_result.dart';
import 'package:cam_id/main/data/api/api_end_point.dart';
import 'package:cam_id/main/data/api/api_util.dart';
import 'package:cam_id/main/data/model/auto_renew_model.dart';
import 'package:cam_id/main/data/model/charge_history_model.dart';
import 'package:cam_id/main/data/model/payment_history_model.dart';
import 'package:cam_id/main/data/model/user_info_model.dart';
import 'package:cam_id/main/data/share_preference/share_preference.dart';
import 'package:cam_id/main/ui/payment_history/payment_history_event.dart';
import 'package:cam_id/main/ui/payment_history/payment_history_state.dart';
import 'package:cam_id/main/utils/constant.dart';
import 'package:cam_id/main/utils/device_utils.dart';
import 'package:cam_id/main/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentHistoryBloc
    extends Bloc<PaymentHistoryEvent, PaymentHistoryState> {
  PaymentHistoryBloc() : super(PaymentHistoryInitial()) {
    on<GetPaymentHistoryEvent>(_onGetPaymentHistory);
    on<GetAutoRenewHistoryEvent>(_onGetAutoRenewHistory);
    on<CancelAutoRenewEvent>(_onCancelAutoRenew);
    on<SaveAutoRenewEvent>(_onSaveAutoRenew);
  }

  Future<void> _onGetPaymentHistory(
    GetPaymentHistoryEvent event,
    Emitter<PaymentHistoryState> emit,
  ) async {
    emit(PaymentHistoryLoading());
    final language = await SharePreferenceUtil.getLanguageCode();
    final isdn = await SharePreferenceUtil.getString(ShareKey.KEY_PHONE_NUMBER);

    final body = {
      "apiKey": ApiEndPoint.API_KEY,
      "language": language,
      "sessionId": "",
      "token": "",
      "versionApp": DeviceUtils.getVersion(),
      "wsCode": WSCode.wsPaymentHistory,
      "wsRequest": {
        "camId": UserInfoModel.instance.userId,
        "fromDate": event.fromDate,
        "toDate": event.toDate,
        "language": language,
        "page": event.page,
        "pageSize": event.pageSize,
      },
    };

    try {
      final result = await ApiUtil.getInstance()!
          .postParsed<BaseResponseV2<BaseResult<List<PaymentHistoryModel>>>>(
            url: ApiEndPoint.API_USER_ROUTING,
            body: body,
            fromJson: (json) => BaseResponseV2.fromJson(
              json,
              (data) => BaseResult<List<PaymentHistoryModel>>.fromJson(
                data,
                (list) => (list as List)
                    .map((e) => PaymentHistoryModel.fromJson(e))
                    .toList(),
              ),
            ),
          );

      if (result.isSuccess &&
          result.result?.wsResponse != null &&
          result.result?.wsResponse!.isNotEmpty == true) {
        emit(GetPaymentHistorySuccess(result.result?.wsResponse));
      } else {
        emit(GetPaymentHistoryFailure(result.result?.message ?? ""));
      }
    } catch (e) {
      AppLogger().logError(e.toString());
      emit(GetPaymentHistoryFailure(""));
    }
  }

  Future<void> _onGetAutoRenewHistory(
    GetAutoRenewHistoryEvent event,
    Emitter<PaymentHistoryState> emit,
  ) async {
    emit(AutoRenewHistoryLoading());
    final language = await SharePreferenceUtil.getLanguageCode();
    final isdn = await SharePreferenceUtil.getString(ShareKey.KEY_PHONE_NUMBER);

    final body = {
      "apiKey": ApiEndPoint.API_KEY,
      "language": language,
      "sessionId": "",
      "token": "",
      "versionApp": DeviceUtils.getVersion(),
      "wsCode": WSCode.wsGetListAutoRenew,
      "wsRequest": {
        "camId": UserInfoModel.instance.userId,
        "filter": event.filter,
        "fromDate": event.fromDate,
        "toDate": event.toDate,
        "language": language,
        "page": event.page,
        "pageSize": event.pageSize,
      },
    };

    try {
      final result = await ApiUtil.getInstance()!
          .postParsed<BaseResponseV2<BaseResult<List<AutoRenewModel>>>>(
            url: ApiEndPoint.API_USER_ROUTING,
            body: body,
            fromJson: (json) => BaseResponseV2.fromJson(
              json,
              (data) => BaseResult<List<AutoRenewModel>>.fromJson(
                data,
                (list) => (list as List)
                    .map((e) => AutoRenewModel.fromJson(e))
                    .toList(),
              ),
            ),
          );
      if (result.isSuccess &&
          result.result?.wsResponse != null &&
          result.result?.wsResponse!.isNotEmpty == true) {
        emit(GetAutoRenewSuccess(result.result?.wsResponse));
      } else {
        emit(GetAutoRenewFailure(result.result?.message ?? ""));
      }
    } catch (e) {
      AppLogger().logError(e.toString());
      emit(GetAutoRenewFailure(""));
    }
  }

  Future<void> _onCancelAutoRenew(
    CancelAutoRenewEvent event,
    Emitter<PaymentHistoryState> emit,
  ) async {
    emit(AutoRenewHistoryLoading());
    final language = await SharePreferenceUtil.getLanguageCode();
    final isdn = await SharePreferenceUtil.getString(ShareKey.KEY_PHONE_NUMBER);

    final body = {
      "apiKey": ApiEndPoint.API_KEY,
      "language": language,
      "sessionId": "",
      "token": "",
      "versionApp": DeviceUtils.getVersion(),
      "wsCode": WSCode.wsCancelAutoRenew,
      "wsRequest": {"language": language, "autoRenewId": event.autoRenewId},
    };

    try {
      final result = await ApiUtil.getInstance()!
          .postParsed<BaseResponseV2<BaseResult<dynamic>>>(
            url: ApiEndPoint.API_USER_ROUTING,
            body: body,
        fromJson: (json) => BaseResponseV2.fromJson(
          json,
              (data) => BaseResult<dynamic>.fromJson(data,null),
        ),

      );
      if (result.result?.errorCode == "0") {
        emit(CancelAutoRenewSuccess(result.result?.userMsg ?? ""));
      } else {
        emit(CancelAutoRenewFailure(result.result?.userMsg ?? ""));
      }
    } catch (e) {
      AppLogger().logError(e.toString());
      emit(CancelAutoRenewFailure(""));
    }
  }

  Future<void> _onSaveAutoRenew(
    SaveAutoRenewEvent event,
    Emitter<PaymentHistoryState> emit,
  ) async {
    emit(AutoRenewHistoryLoading());
    final language = await SharePreferenceUtil.getLanguageCode();
    final isdn = await SharePreferenceUtil.getString(ShareKey.KEY_PHONE_NUMBER);

    final body = {
      "apiKey": ApiEndPoint.API_KEY,
      "language": language,
      "sessionId": "",
      "token": "",
      "versionApp": DeviceUtils.getVersion(),
      "wsCode": WSCode.wsSaveAutoRenew,
      "wsRequest": {
        "language": language,
        "type": Constant.UPDATE,
        "renewId": event.autoRenewId,
      },
    };

    try {
      final result = await ApiUtil.getInstance()!
          .postParsed<BaseResponseV2<BaseResult<dynamic>>>(
            url: ApiEndPoint.API_USER_ROUTING,
            body: body,
            fromJson: (json) => BaseResponseV2.fromJson(
              json,
              (data) => BaseResult<List<AutoRenewModel>>.fromJson(
                data,
                (list) => (list as List)
                    .map((e) => AutoRenewModel.fromJson(e))
                    .toList(),
              ),
            ),
          );
      if (result.result?.errorCode == "0") {
        emit(SaveAutoRenewSuccess(result.result?.userMsg ?? ""));
      } else {
        emit(SaveAutoRenewFailure(result.result?.userMsg ?? ""));
      }
    } catch (e) {
      AppLogger().logError(e.toString());
      emit(SaveAutoRenewFailure(""));
    }
  }
}
