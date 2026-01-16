import 'package:cam_id/main/base/base_response.dart';
import 'package:cam_id/main/base/base_response_v2.dart';
import 'package:cam_id/main/base/base_result.dart';
import 'package:cam_id/main/data/api/api_end_point.dart';
import 'package:cam_id/main/data/api/api_util.dart';
import 'package:cam_id/main/data/model/province_model.dart';
import 'package:cam_id/main/data/model/user_info_model.dart';
import 'package:cam_id/main/data/share_preference/share_preference.dart';
import 'package:cam_id/main/ui/register_ftth/register_ftth_event.dart';
import 'package:cam_id/main/ui/register_ftth/register_ftth_state.dart';
import 'package:cam_id/main/utils/device_utils.dart';
import 'package:cam_id/main/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterFTTHBloc extends Bloc<RegisterFtthEvent, RegisterFtthState> {
  RegisterFTTHBloc() : super(RegisterFtthInitial()) {
    on<GetListProvinceEvent>(_onGetListProvince);
    on<GenerateOTPFTTHEvent>(_onGenerateOTPFTTH);
  }

  Future<void> _onGetListProvince(
    GetListProvinceEvent event,
    Emitter<RegisterFtthState> emit,
  ) async {
    emit(RegisterFtthLoading());
    final language = await SharePreferenceUtil.getLanguageCode();
    final body = {
      "language": language,
      "versionApp": DeviceUtils.getVersion(),
      "wsCode": WSCode.getListProvince,
      "wsRequest": {"language": language},
    };

    try {
      final result = await ApiUtil.getInstance()!
          .postParsed<BaseResponseV2<BaseResult<List<ProvinceModel>>>>(
            url: ApiEndPoint.API_USER_ROUTING,
            body: body,
            fromJson: (json) => BaseResponseV2.fromJson(
              json,
              (data) => BaseResult<List<ProvinceModel>>.fromJson(
                data,
                (list) => (list as List)
                    .map((e) => ProvinceModel.fromJson(e))
                    .toList(),
              ),
            ),
          );

      if (result.isSuccess &&
          result.result?.wsResponse != null &&
          result.result?.wsResponse!.isNotEmpty == true) {
        emit(GetListProvinceSuccess(result.result!.wsResponse!));
      } else {
        emit(GetListProvinceFailure(result.result!.message ?? ""));
      }
    } catch (e) {
      AppLogger().logError(e.toString());
      emit(GetListProvinceFailure(""));
    }
  }

  Future<void> _onGenerateOTPFTTH(
    GenerateOTPFTTHEvent event,
    Emitter<RegisterFtthState> emit,
  ) async {
    emit(RegisterFtthLoading());
    final language = await SharePreferenceUtil.getLanguageCode();
    final token = await SharePreferenceUtil.getString(
      ShareKey.KEY_ACCESS_TOKEN,
    );
    final headers = {
      "Authorization": token,
    };

    final body = {
      "apiKey" : "string",
      "sessionId" : "string",
      "username" : "string",
      "wsCode" : "string",
      "wsRequest" : {
        "phone_number" : event.phoneNumber
      }
    };


    try {
      final result = await ApiUtil.getInstance()!.postParsed<BaseResponse>(
        url: ApiEndPoint.API_GENERATE_OTP_FTTH,
        headers: headers,
        body: body,
        fromJson: (json) => BaseResponse.fromJson(json)
      );
      AppLogger().logInfo(result.code??"11");
      if (result.isSuccess) {
        emit(GenerateOTPFTTHSuccess());
      } else {
        emit(GenerateOTPFTTHFailure(result.message ?? ""));
      }
    } catch (e) {
      AppLogger().logError(e.toString());
      emit(GenerateOTPFTTHFailure(""));
    }
  }
}
