import 'package:cam_id/main/base/base_response_v2.dart';
import 'package:cam_id/main/data/api/api_end_point.dart';
import 'package:cam_id/main/data/api/api_util.dart';
import 'package:cam_id/main/ui/verify/verify_event.dart';
import 'package:cam_id/main/ui/verify/verify_state.dart';
import 'package:cam_id/main/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyBloc extends Bloc<VerifyEvent, VerifyState> {
  VerifyBloc() : super(VerifyInitial()) {
    on<GetOTPByServiceEvent>(_onGetOTPByService);
    on<ConfirmOTPEvent>(_onConfirmOTP);
  }

  Future<void> _onGetOTPByService(
    GetOTPByServiceEvent event,
    Emitter<VerifyState> emit,
  ) async {
    Map<String, dynamic> body = {
      "apiKey": ApiEndPoint.API_KEY_V2,
      "sessionId": "",
      "username": event.phone,
      "token": "",
      "language": "",
      "versionApp": "",
      "wsCode": "wsGetOTPByService",
      "wsRequest": {
        "isdn": event.phone,
        "service": event.service,
        "language": event.language,
      },
    };

    try {
      final result = await ApiUtil.getInstance()!.postParsed<BaseResponseV2>(
        url: ApiEndPoint.API_USER_ROUTING,
        body: body,
        fromJson: (json) => BaseResponseV2.fromJson(
          json,
              (data) => BaseResponseV2.fromJson(data, null),
        ),
      );

      if (result.isSuccess) {
        emit(GetOTPByServiceSuccess(result.errorMessage ?? ""));
      } else {
        emit(GetOTPByServiceFailure(result.errorMessage ?? "Fail"));
      }
    } catch (e) {
      emit(GetOTPByServiceFailure("Network error: ${e.toString()}"));
      AppLogger().logInfo("Network error: ${e.toString()}");
    }
  }

  Future<void> _onConfirmOTP(
    ConfirmOTPEvent event,
    Emitter<VerifyState> emit,
  ) async {
    Map<String, dynamic> body = {
      "apiKey": ApiEndPoint.API_KEY_V2,
      "sessionId": "",
      "username": event.phone,
      "token": "",
      "language": "",
      "versionApp": "",
      "wsCode": "wsConfirmOTP",
      "wsRequest": {
        "isdn": event.phone,
        "service": event.service,
        "language": event.language,
        "otp": event.otp,
      },
    };

    try {
      final result = await ApiUtil.getInstance()!.postParsed<BaseResponseV2>(
        url: ApiEndPoint.API_USER_ROUTING,
        body: body,
        fromJson: (json) => BaseResponseV2.fromJson(
          json,
              (data) => BaseResponseV2.fromJson(data, null),
        ),
      );

      if (result.isSuccess) {
        emit(ConfirmOTPSuccess(result.errorMessage ?? ""));
      } else {
        emit(ConfirmOTPFailure(result.errorMessage ?? "Fail"));
      }
    } catch (e) {
      emit(ConfirmOTPFailure("Network error: ${e.toString()}"));
      AppLogger().logInfo("Network error: ${e.toString()}");
    }
  }
}
