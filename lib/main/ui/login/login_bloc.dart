import 'package:cam_id/main/base/base_response.dart';
import 'package:cam_id/main/data/api/api_end_point.dart';
import 'package:cam_id/main/data/api/api_util.dart';
import 'package:cam_id/main/data/response/sign_in_response.dart';
import 'package:cam_id/main/data/response/user_info_response.dart';
import 'package:cam_id/main/ui/login/login_event.dart';
import 'package:cam_id/main/ui/login/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState>{
  LoginBloc() : super(LoginInitial()){
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
      BaseResponse result = await ApiUtil.getInstance()!.post<BaseResponse>(
        url: ApiEndPoint.API_SIGN_UP,
        body: body,
        fromJson: (json) => SignInResponse.fromJson(json),
      );

      if(result.isSuccess){
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
      BaseResponse result = await ApiUtil.getInstance()!.post<BaseResponse>(
        url: ApiEndPoint.API_GET_OTP,
        body: body,
        fromJson: (json) => SignInResponse.fromJson(json),
      );

      if(result.isSuccess){
        emit(GenerateOTPSuccess(result.message ?? ""));
      } else {
        emit(GenerateOTPFailure(result.message ?? "Fail"));
      }
    } catch (e) {
      emit(GenerateOTPFailure("Network error: ${e.toString()}"));
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
      SignInResponse result = await ApiUtil.getInstance()!.post<SignInResponse>(
        url: ApiEndPoint.API_SIGN_IN,
        body: body,
        fromJson: (json) => SignInResponse.fromJson(json),
      );

      if (result.isSuccess && result.signInData != null) {
        emit(SignInSuccess(result.message ?? "", result.signInData!));
      } else {
        emit(SignInFailure(result.message ?? "Failed"));
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
      UserInfoResponse result = await ApiUtil.getInstance()!.get<UserInfoResponse>(
        url: ApiEndPoint.API_GET_USER_INFO,
        headers: headers,
        fromJson: (json) => UserInfoResponse.fromJson(json),
      );

      if (result.isSuccess && result.user != null) {
        emit(GetUserInfoSuccess(result.message ?? "", result.user, result.services, result.imageKyc));
      } else {
        emit(GetUserInfoFailure(result.message ?? "Fail"));
      }
    } catch (e) {
      emit(GetUserInfoFailure("Network error: ${e.toString()}"));
    }
  }

}