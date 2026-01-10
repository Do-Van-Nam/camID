import 'package:cam_id/main/base/base_response.dart';
import 'package:cam_id/main/base/base_response_v2.dart';
import 'package:cam_id/main/base/base_result.dart';
import 'package:cam_id/main/data/api/api_end_point.dart';
import 'package:cam_id/main/data/api/api_util.dart';
import 'package:cam_id/main/data/response/linked_emoney_response.dart';
import 'package:cam_id/main/data/response/payment_method_response.dart';
import 'package:cam_id/main/data/response/user_info_response.dart';
import 'package:cam_id/main/ui/user_profile/user_profile_event.dart';
import 'package:cam_id/main/ui/user_profile/user_profile_state.dart';
import 'package:cam_id/main/utils/device_utils.dart';
import 'package:cam_id/main/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserProfileBloc() : super(UserProfileInitial()) {
    on<InitLinkedPaymentEvent>(_onInitLinkedPayment);
    on<CheckLinkedPaymentEmoneyEvent>(_onCheckLinkedPaymentEmoney);
    on<GetListPaymentMethodEvent>(_onGetListPaymentMethod);
    on<UpdateAvatarEvent>(_onUpdateAvatar);
    on<GenerateQRCodeFTTHCommissionEvent>(_onGenerateQRCodeFTTHCommission);
    on<AbaCheckAbaCardEvent>(_onAbaCheckAbaCard);
    on<GetUserInfoEvent>(_onGetUserInfo);
  }

  Future<void> _onInitLinkedPayment(
    InitLinkedPaymentEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    Map<String, dynamic> body = {
      "apiKey": "",
      "sessionId": "",
      "username": "",
      "token": "",
      "language": "",
      "versionApp": "",
      "wsCode": WSCode.wsInitLinkedPayment,
      "wsRequest": {"camId": "", "isdn": "", "partnerCode": "", "language": ""},
    };

    try {
      BaseResponse result = await ApiUtil.getInstance()!.post(
        url: ApiEndPoint.API_USER_ROUTING,
        body: body,
      );

      if (result.isSuccess) {
        emit(InitLinkedPaymentSuccess(result.message ?? ""));
      } else {
        emit(InitLinkedPaymentFailure(result.message ?? "Fail"));
      }
    } catch (e) {
      emit(InitLinkedPaymentFailure("Network error: ${e.toString()}"));
      AppLogger().logInfo("Network error: ${e.toString()}");
    }
  }

  Future<void> _onCheckLinkedPaymentEmoney(
    CheckLinkedPaymentEmoneyEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    final body = {
      "apiKey": ApiEndPoint.API_KEY,
      "sessionId": "",
      "username": "",
      "language": "",
      "versionApp": DeviceUtils.getVersion(),
      "wsCode": WSCode.wsCheckLinkedPaymentEmoney,
      "wsRequest": {
        "camId": event.camId,
        "isdn": event.isdn,
        "language": event.language,
      },
    };

    try {
      final baseResponse = await ApiUtil.getInstance()!
          .postParsed<BaseResponseV2<CheckLinkResult>>(
            url: ApiEndPoint.API_USER_ROUTING,
            body: body,
            fromJson: (json) => BaseResponseV2.fromJson(
              json,
              (data) => CheckLinkResult.fromJson(data),
            ),
          );

      if (baseResponse.isSuccess) {
        emit(
          CheckLinkedPaymentEmoneySuccess(
            baseResponse.errorMessage ?? "",
            baseResponse.result,
          ),
        );
      } else {
        emit(CheckLinkedPaymentEmoneyFailure(baseResponse.errorMessage ?? "Fail"));
      }
    } catch (e) {
      emit(CheckLinkedPaymentEmoneyFailure("Network error: ${e.toString()}"));
    }
  }

  Future<void> _onGetListPaymentMethod(
    GetListPaymentMethodEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(UserProfileLoading());
    Map<String, dynamic> body = {
      "apiKey": ApiEndPoint.API_KEY,
      "sessionId": "",
      "username": "",
      "versionApp": DeviceUtils.getVersion(),
      "language": event.language,
      "wsCode": WSCode.wsGetListPaymentMethod,
      "wsRequest": {
        "camId": event.camId,
        "service": event.service,
        "language": event.language,
      },
    };

    try {
      final baseResponse = await ApiUtil.getInstance()!
          .postParsed<BaseResponseV2<BaseResult<PaymentMethodResponse>>>(
        url: ApiEndPoint.API_USER_ROUTING,
        body: body,
        fromJson: (json) => BaseResponseV2.fromJson(
          json,
              (data) => BaseResult<PaymentMethodResponse>.fromJson(
            data,
                (ws) => PaymentMethodResponse.fromJson(ws),
          ),
        ),
      );

      if (baseResponse.isSuccess) {
        emit(GetListPaymentMethodSuccess(baseResponse.errorMessage ?? "", baseResponse.result?.wsResponse));
      } else {
        emit(GetListPaymentMethodFailure(baseResponse.errorMessage ?? "Fail"));
      }
    } catch (e) {
      emit(GetListPaymentMethodFailure("Network error: ${e.toString()}"));
      AppLogger().logInfo("Network error: ${e.toString()}");
    }
  }

  Future<void> _onUpdateAvatar(
    UpdateAvatarEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    Map<String, dynamic> headers = {"Authorization": ""};

    Map<String, dynamic> body = {
      "apiKey": "",
      "sessionId": "",
      "username": "",
      "wsCode": "",
      "wsRequest": {},
    };

    try {
      BaseResponse result = await ApiUtil.getInstance()!.post(
        url: ApiEndPoint.API_UPDATE_AVATAR,
        headers: headers,
        body: body,
      );

      if (result.isSuccess) {
        emit(UpdateAvatarSuccess(result.message ?? ""));
      } else {
        emit(UpdateAvatarFailure(result.message ?? "Fail"));
      }
    } catch (e) {
      emit(UpdateAvatarFailure("Network error: ${e.toString()}"));
      AppLogger().logInfo("Network error: ${e.toString()}");
    }
  }

  Future<void> _onGenerateQRCodeFTTHCommission(
    GenerateQRCodeFTTHCommissionEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    Map<String, dynamic> body = {
      "apiKey": "6CB8FC45D491D87CECB53428D79423BD",
      "sessionId": "",
      "username": "",
      "wsCode": WSCode.wsGenerateQRCodeFTTHCommission,
      "wsRequest": {"camID": "", "eventCode": "FTTH", "phoneNumber": ""},
    };

    try {
      BaseResponse result = await ApiUtil.getInstance()!.post(
        url: ApiEndPoint.API_USER_ROUTING,
        body: body,
      );

      if (result.isSuccess) {
        emit(GenerateQRCodeFTTHCommissionSuccess(result.message ?? ""));
      } else {
        emit(GenerateQRCodeFTTHCommissionFailure(result.message ?? "Fail"));
      }
    } catch (e) {
      emit(
        GenerateQRCodeFTTHCommissionFailure("Network error: ${e.toString()}"),
      );
      AppLogger().logInfo("Network error: ${e.toString()}");
    }
  }

  Future<void> _onAbaCheckAbaCard(
    AbaCheckAbaCardEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    Map<String, dynamic> body = {
      "apiKey": "",
      "sessionId": "",
      "username": "",
      "wsCode": WSCode.wsAbaCheckAbaCard,
      "wsRequest": {"linkedPaymentId": "", "camId": "", "language": ""},
    };

    try {
      BaseResponse result = await ApiUtil.getInstance()!.post(
        url: ApiEndPoint.API_USER_ROUTING,
        body: body,
      );

      if (result.isSuccess) {
        emit(AbaCheckAbaCardSuccess(result.message ?? ""));
      } else {
        emit(AbaCheckAbaCardFailure(result.message ?? "Fail"));
      }
    } catch (e) {
      emit(AbaCheckAbaCardFailure("Network error: ${e.toString()}"));
      AppLogger().logInfo("Network error: ${e.toString()}");
    }
  }

  Future<void> _onGetUserInfo(
    GetUserInfoEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(UserProfileLoading());
    Map<String, dynamic> headers = {"Authorization": event.token};

    try {
      BaseResponse result = await ApiUtil.getInstance()!.get(
        url: ApiEndPoint.API_GET_USER_INFO,
        headers: headers,
      );

      UserInfoResponse? userInfo;
      if (result.isSuccess && result.data != null) {
        userInfo = UserInfoResponse.fromJson(result.data);
      }

      if (result.isSuccess && userInfo != null) {
        emit(
          GetUserInfoSuccess(
            result.message ?? "",
            userInfo.user,
            userInfo.services,
            userInfo.imageKyc,
          ),
        );
      } else {
        emit(GetUserInfoFailure(result.message ?? "Fail"));
      }
    } catch (e) {
      emit(GetUserInfoFailure("Network error: ${e.toString()}"));
    }
  }
}
