import 'package:cam_id/main/base/base_response_v2.dart';
import 'package:cam_id/main/base/base_result.dart';
import 'package:cam_id/main/data/api/api_end_point.dart';
import 'package:cam_id/main/data/api/api_util.dart';
import 'package:cam_id/main/data/model/charge_history_model.dart';
import 'package:cam_id/main/data/model/value_child_charging_history_model.dart';
import 'package:cam_id/main/data/share_preference/share_preference.dart';
import 'package:cam_id/main/ui/charge_history_detail/charge_history_detail_event.dart';
import 'package:cam_id/main/ui/charge_history_detail/charge_history_detail_state.dart';
import 'package:cam_id/main/utils/constant.dart';
import 'package:cam_id/main/utils/device_utils.dart';
import 'package:cam_id/main/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChargeHistoryDetailBloc extends Bloc<ChargeHistoryDetailEvent, ChargeHistoryDetailState> {
  ChargeHistoryDetailBloc() : super(ChargeHistoryDetailInitial()) {
    on<GetChargeHistoryDetailEvent>(_onGetChargeHistoryDetail);
  }

  Future<void> _onGetChargeHistoryDetail(
      GetChargeHistoryDetailEvent event,
      Emitter<ChargeHistoryDetailState> emit,
      ) async {
    emit(ChargeHistoryDetailLoading());
    final language = await SharePreferenceUtil.getLanguageCode();
    final isdn = await SharePreferenceUtil.getString(ShareKey.KEY_PHONE_NUMBER);

    final body = {
      "apiKey": ApiEndPoint.API_KEY,
      "language": language,
      "sessionId": "",
      "token": "",
      "versionApp": DeviceUtils.getVersion(),
      "wsCode": WSCode.wsHistoryChargeDetailV2,
      "wsRequest": {
        "isdn": "66200017",
        "language": language,
        "startTime": event.startTime,
        "subType": event.subType,
        "type": event.type,
      },
    };

    try {
      final result = await ApiUtil.getInstance()!
          .postParsed<BaseResponseV2<BaseResult<List<ValueChildChargingHistoryModel>>>>(
        url: ApiEndPoint.API_USER_ROUTING,
        body: body,
        fromJson: (json) => BaseResponseV2.fromJson(
          json,
              (data) => BaseResult<List<ValueChildChargingHistoryModel>>.fromJson(
            data,
                (list) => (list as List)
                .map((e) => ValueChildChargingHistoryModel.fromJson(e))
                .toList(),
          ),
        ),
      );

      if (result.isSuccess && result.result?.wsResponse != null) {
        final listAll = result.result!.wsResponse!;

        final listCall = listAll.where((e) => e.subType == Constant.HISTORY_CALL).toList();
        final listData = listAll.where((e) => e.subType == Constant.HISTORY_DATA).toList();
        final listSMS  = listAll.where((e) => e.subType == Constant.HISTORY_SMS).toList();

        final listService = listAll.where((e) =>
        e.subType != Constant.HISTORY_CALL &&
            e.subType != Constant.HISTORY_DATA &&
            e.subType != Constant.HISTORY_SMS
        ).toList();

        emit(GetChargeHistoryDetailSuccess(
          listAll,
          listCall,
          listData,
          listSMS,
          listService,
        ));
      } else {
        emit(GetChargeHistoryDetailFailure(result.result?.message ?? ""));
      }
    } catch (e) {
      AppLogger().logError(e.toString());
      emit(GetChargeHistoryDetailFailure(e.toString()));
    }
  }
}