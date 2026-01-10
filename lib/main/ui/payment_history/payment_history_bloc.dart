import 'package:cam_id/main/base/base_response_v2.dart';
import 'package:cam_id/main/base/base_result.dart';
import 'package:cam_id/main/data/api/api_end_point.dart';
import 'package:cam_id/main/data/api/api_util.dart';
import 'package:cam_id/main/data/model/charge_history_model.dart';
import 'package:cam_id/main/data/share_preference/share_preference.dart';
import 'package:cam_id/main/ui/payment_history/payment_history_event.dart';
import 'package:cam_id/main/ui/payment_history/payment_history_state.dart';
import 'package:cam_id/main/utils/device_utils.dart';
import 'package:cam_id/main/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentHistoryBloc extends Bloc<PaymentHistoryEvent, PaymentHistoryState> {
  PaymentHistoryBloc() : super(PaymentHistoryInitial()) {
    on<GetPaymentHistoryEvent>(_onGetPaymentHistory);
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
      "wsCode": WSCode.wsHistoryChargeV2,
      "wsRequest": {
        "isdn": "66200017",
        "language": language
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

    } catch (e) {
      AppLogger().logError(e.toString());
      // emit(GetChargeHistoryFailure(e.toString(), event.type));
    }
  }

}