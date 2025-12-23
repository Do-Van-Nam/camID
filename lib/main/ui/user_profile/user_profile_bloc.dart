import 'package:cam_id/main/base/base_response.dart';
import 'package:cam_id/main/data/api/api_end_point.dart';
import 'package:cam_id/main/data/api/api_util.dart';
import 'package:cam_id/main/ui/user_profile/user_profile_event.dart';
import 'package:cam_id/main/ui/user_profile/user_profile_state.dart';
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
  }

  Future<void> _onInitLinkedPayment(InitLinkedPaymentEvent event, Emitter<UserProfileState> emit) async {
    Map<String, dynamic> body = {
      "apiKey": "",
      "sessionId": "",
      "username": "",
      "token":"",
      "language":"",
      "versionApp":"",
      "wsCode": "wsInitLinkedPayment",
      "wsRequest": {
        "camId":"",
        "isdn":"",
        "partnerCode":"",
        "language":""
      }
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
  Future<void> _onCheckLinkedPaymentEmoney(CheckLinkedPaymentEmoneyEvent event, Emitter<UserProfileState> emit) async {
    Map<String, dynamic> body = {
      "apiKey": "",
      "sessionId": "",
      "username": "",
      "wsCode": "wsCheckLinkedPaymentEmoney",
      "wsRequest": {
        "camId":"",
        "isdn":"",
        "language":""
      }
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
  Future<void> _onGetListPaymentMethod(GetListPaymentMethodEvent event, Emitter<UserProfileState> emit) async {
    Map<String, dynamic> body = {
      "apiKey": "",
      "sessionId": "",
      "username": "",
      "wsCode": "wsGetListPaymentMethod",
      "wsRequest": {
        "camId":"",
        "service":"",
        "language":""
      }
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
  Future<void> _onUpdateAvatar(UpdateAvatarEvent event, Emitter<UserProfileState> emit) async {
    Map<String, dynamic> headers = {
      "Authorization": "",
    };

    Map<String, dynamic> body = {
      "apiKey": "",
      "sessionId": "",
      "username": "",
      "wsCode": "",
      "wsRequest": {

      }
    };

    try {
      BaseResponse result = await ApiUtil.getInstance()!.post(
        url: ApiEndPoint.API_UPDATE_AVATAR,
        headers: headers,
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
  Future<void> _onGenerateQRCodeFTTHCommission(GenerateQRCodeFTTHCommissionEvent event, Emitter<UserProfileState> emit) async {
    Map<String, dynamic> body = {
      "apiKey": "6CB8FC45D491D87CECB53428D79423BD",
      "sessionId": "",
      "username": "",
      "wsCode": "wsGenerateQRCodeFTTHCommission",
      "wsRequest": {
        "camID":"",
        "eventCode": "FTTH",
        "phoneNumber":""
      }
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
  Future<void> _onAbaCheckAbaCard(AbaCheckAbaCardEvent event, Emitter<UserProfileState> emit) async {
    Map<String, dynamic> body = {
      "apiKey": "",
      "sessionId": "",
      "username": "",
      "wsCode": "wsAbaCheckAbaCard",
      "wsRequest": {
        "linkedPaymentId":"",
        "camId":"",
        "language":""
      }
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

}