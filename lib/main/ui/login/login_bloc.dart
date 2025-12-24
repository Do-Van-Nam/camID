import 'package:cam_id/main/base/base_response.dart';
import 'package:cam_id/main/data/api/api_end_point.dart';
import 'package:cam_id/main/data/api/api_util.dart';
import 'package:cam_id/main/data/model/sign_in_model.dart';
import 'package:cam_id/main/data/response/sign_in_response.dart';
import 'package:cam_id/main/data/response/user_info_response.dart';
import 'package:cam_id/main/ui/login/login_event.dart';
import 'package:cam_id/main/ui/login/login_state.dart';
import 'package:cam_id/main/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<SignUpEvent>(_onSignUp);
    on<GenerateOTPEvent>(_onGenerateOTP);
    on<SignInEvent>(_onSignIn);
    on<GetUserInfoEvent>(_onGetUserInfo);
  }

  Future<void> _onSignUp(SignUpEvent event, Emitter<LoginState> emit) async {
    emit(SignUpLoading());
    Map<String, dynamic> body = {
      "apiKey": "",
      "sessionId": "",
      "username": "",
      "wsCode": "",
      "wsRequest": {
        "confirmOtp": event.confirmOtp,
        "otp": event.otp,
        "phone_number": event.phoneNumber,
      }
    };
    try {
      BaseResponse result = await ApiUtil.getInstance()!.post(
        url: ApiEndPoint.API_SIGN_UP,
        body: body,
      );

      SignInResponse? signInData;
      if (result.isSuccess && result.data != null) {
        signInData = SignInResponse.fromJson(result.data);
      }
      print("SignUp result: ${result.code} / ${result.message}");
      if (result.isSuccess) {
        emit(SignUpSuccess(result.message ?? ""));
      } else {
        emit(SignUpFailure(result.message ?? "Fail"));
      }
    } catch (e) {
      emit(SignUpFailure("Network error: ${e.toString()}"));
    }
  }

  Future<void> _onGenerateOTP(GenerateOTPEvent event, Emitter<LoginState> emit) async {
    Map<String, dynamic> body = {
      "apiKey": "",
      "sessionId": "",
      "username": "",
      "wsCode": "",
      "wsRequest": {
        "phone_number": event.phoneNumber,
      }
    };

    try {
      BaseResponse result = await ApiUtil.getInstance()!.post(
        url: ApiEndPoint.API_GET_OTP,
        body: body,
      );

      if (result.isSuccess) {
        emit(GenerateOTPSuccess(result.message ?? ""));
      } else {
        emit(GenerateOTPFailure(result.message ?? "Fail"));
      }
    } catch (e) {
      emit(GenerateOTPFailure("Network error: ${e.toString()}"));
      AppLogger().logInfo("Network error: ${e.toString()}");
    }
  }

  Future<void> _onSignIn(SignInEvent event, Emitter<LoginState> emit) async {
    emit(SignInLoading());

    Map<String, dynamic> body = {
      "apiKey": "",
      "sessionId": "",
      "username": "",
      "wsCode": "",
      "wsRequest": {
        "appCode": "MyVTG",
        "device": "000229163ad3286e",
        "otp": event.otp,
        "phone_number": event.phoneNumber,
        "prefix": "855",
        "type": "otp",
      }
    };

    try {
      BaseResponse result = await ApiUtil.getInstance()!.post(
        url: ApiEndPoint.API_SIGN_IN,
        body: body,
      );

      SignInResponse signInResponse = SignInResponse.fromJson(result.data ?? {});

      if (signInResponse.isSuccess && signInResponse.signInData != null) {
        emit(SignInSuccess(signInResponse.message ?? "", signInResponse.signInData!));
      } else {
        emit(SignInFailure(signInResponse.message ?? "Failed"));
      }
    } catch (e) {
      emit(SignInFailure("Network error: ${e.toString()}"));
    }
  }

  Future<void> _onGetUserInfo(GetUserInfoEvent event, Emitter<LoginState> emit) async {
    Map<String, dynamic> headers = {
      "Authorization": event.token,
    };

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
        emit(GetUserInfoSuccess(
          result.message ?? "",
          userInfo.user,
          userInfo.services,
          userInfo.imageKyc,
        ));
      } else {
        emit(GetUserInfoFailure(result.message ?? "Fail"));
      }
    } catch (e) {
      emit(GetUserInfoFailure("Network error: ${e.toString()}"));
    }
  }
}