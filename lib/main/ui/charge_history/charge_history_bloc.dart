import 'package:cam_id/main/base/base_response_v2.dart';
import 'package:cam_id/main/base/base_result.dart';
import 'package:cam_id/main/data/api/api_end_point.dart';
import 'package:cam_id/main/data/api/api_util.dart';
import 'package:cam_id/main/data/model/charge_history_model.dart';
import 'package:cam_id/main/data/model/value_charging_history_model.dart';
import 'package:cam_id/main/data/share_preference/share_preference.dart';
import 'package:cam_id/main/ui/charge_history/charge_history_event.dart';
import 'package:cam_id/main/ui/charge_history/charge_history_state.dart';
import 'package:cam_id/main/utils/constant.dart';
import 'package:cam_id/main/utils/device_utils.dart';
import 'package:cam_id/main/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChargeHistoryBloc extends Bloc<ChargeHistoryEvent, ChargeHistoryState> {
  ChargeHistoryBloc() : super(ChargeHistoryInitial()) {
    on<GetChargeHistoryEvent>(_onGetChargeHistory);
  }
  final Map<String, List<ValueChargingHistoryModel>> _cache = {};

  Future<void> _onGetChargeHistory(
    GetChargeHistoryEvent event,
    Emitter<ChargeHistoryState> emit,
  ) async {
    emit(ChargeHistoryLoading());
    final language = await SharePreferenceUtil.getLanguageCode();
    final isdn = await SharePreferenceUtil.getString(ShareKey.KEY_PHONE_NUMBER);

    final body = {
      "apiKey": ApiEndPoint.API_KEY,
      "language": language,
      "sessionId": "",
      "token": "",
      "versionApp": DeviceUtils.getVersion(),
      "wsCode": "wsHistoryChargeV2",
      "wsRequest": {
        "isdn": "66200017",
        "language": language,
        "startTime": event.startTime,
        "type": event.type,
      },
    };

    try {
      final result = await ApiUtil.getInstance()!
          .postParsed<BaseResponseV2<BaseResult<List<ChargeHistoryModel>>>>(
            url: ApiEndPoint.API_USER_ROUTING,
            body: body,
            fromJson: (json) => BaseResponseV2.fromJson(
              json,
              (data) => BaseResult<List<ChargeHistoryModel>>.fromJson(
                data,
                (list) => (list as List)
                    .map((e) => ChargeHistoryModel.fromJson(e))
                    .toList(),
              ),
            ),
          );

      if (result.isSuccess && result.result?.wsResponse != null) {
        final list = result.result?.wsResponse ?? [];

        final type = event.type;
        _cache[type] = list
            .expand((e) => e.values ?? [])
            .map((e) => e as ValueChargingHistoryModel)
            .toList();
        final listBasic = _cache[Constant.HISTORY_BASIC] ?? [];
        final listData = _cache[Constant.HISTORY_DATA] ?? [];
        final listCall = _cache[Constant.HISTORY_CALL] ?? [];
        final listSMS = _cache[Constant.HISTORY_SMS] ?? [];
        final listRoaming = _cache[Constant.HISTORY_ROAMING] ?? [];

        emit(
          GetChargeHistorySuccess(
            list,
            listBasic,
            listData,
            listCall,
            listSMS,
            listRoaming,
          ),
        );
      }
    } catch (e) {
      AppLogger().logError(e.toString());
      emit(GetChargeHistoryFailure(e.toString()));
    }
  }
}
