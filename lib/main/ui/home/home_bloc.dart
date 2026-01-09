import 'package:cam_id/main/base/base_response.dart';
import 'package:cam_id/main/base/base_response_v2.dart';
import 'package:cam_id/main/base/base_result.dart';
import 'package:cam_id/main/data/api/api_end_point.dart';
import 'package:cam_id/main/data/api/api_util.dart';
import 'package:cam_id/main/data/model/accounts_ocs_detail_model.dart';
import 'package:cam_id/main/data/model/banner_model.dart';
import 'package:cam_id/main/data/model/user_info_model.dart';
import 'package:cam_id/main/data/repository/all_app_repository.dart';
import 'package:cam_id/main/data/repository/service_by_group_repository.dart';
import 'package:cam_id/main/data/response/sign_in_response.dart';
import 'package:cam_id/main/data/response/user_info_response.dart';
import 'package:cam_id/main/data/share_preference/share_preference.dart';
import 'package:cam_id/main/ui/home/home_event.dart';
import 'package:cam_id/main/ui/home/home_state.dart';
import 'package:cam_id/main/utils/app_config.dart';
import 'package:cam_id/main/utils/device_utils.dart';
import 'package:cam_id/main/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/constant.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AppRepository appRepo;
  final ServiceRepository serviceRepo;
  HomeBloc(this.appRepo, this.serviceRepo) : super(HomeInitial()) {
    on<HomeStarted>(_onStarted);
    // on<BannerChanged>(_onBannerChanged);
    on<LoginTapped>(_onLoginTapped);
    on<GetAllAppsEvent>(_onGetAllApp);
    on<GetServiceByGroupAppsEvent>(_onGetServiceByGroup);
    on<GetAccountsOcsDetailEvent>(_onGetAccountsOcsDetail);
    on<SignUpEvent>(_onSignUp);
    on<GenerateOTPEvent>(_onGenerateOTP);
    on<SignInEvent>(_onSignIn);
    on<GetUserInfoEvent>(_onGetUserInfo);
  }

  void _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    final user = await SharePreferenceUtil.getUser();
    AppLogger().logInfo("USER: ${user?.userId}");
    AppLogger().logInfo("USER: ${user?.username}");

    AppLogger().logInfo("USER: ${UserInfoModel.instance.userId}");
    AppLogger().logInfo("USER: ${UserInfoModel.instance.username}");
    emit(OnStarted(UserInfoModel.instance.username.isNotEmpty == true));
  }

  // void _onBannerChanged(
  //     BannerChanged event,
  //     Emitter<HomeState> emit,
  //     ) {
  //   emit(state.copyWith(bannerIndex: event.index));
  // }

  Future<void> _onLoginTapped(
    LoginTapped event,
    Emitter<HomeState> emit,
  ) async {
    // await SharePreferenceUtil.setBool(ShareKey.KEY_FIRST_OPEN_APP, false);
    await SharePreferenceUtil.setBool(ShareKey.KEY_CHANGE_OPEN_APP, true);
    AppConfig.instance.isFirstOpenApp = false;

    emit(OnTapLogin());
  }

  Future<void> _onGetAllApp(
    GetAllAppsEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final response = await appRepo.getAllApps(force: event.isCallAPI);
      final ads = response.adBanner;

      final bannerFooterList = <AdsModel>[];
      final vasServiceList = <AdsModel>[];

      for (final item in ads!) {
        switch (item.type) {
          case Constant.SLIDER_METFONE_FOOTER:
            bannerFooterList.add(item);
            break;
          case Constant.VAS_SERVICE:
            vasServiceList.add(item);
            break;
        }
      }

      bannerFooterList.sort((a, b) {
        final oa = int.tryParse(a.orderBy ?? '') ?? 0;
        final ob = int.tryParse(b.orderBy ?? '') ?? 0;
        return oa.compareTo(ob);
      });

      vasServiceList.sort((a, b) {
        final oa = int.tryParse(a.orderBy ?? '') ?? 0;
        final ob = int.tryParse(b.orderBy ?? '') ?? 0;
        return oa.compareTo(ob);
      });

      emit(GetAllAppSuccess(bannerFooterList, vasServiceList));
    } catch (e) {
      emit(GetAllAppFailure("Fail"));
    }
  }

  Future<void> _onGetServiceByGroup(
    GetServiceByGroupAppsEvent event,
    Emitter<HomeState> emit,
  ) async {
    // emit(state.copyWith(isLoading: true, error: null));

    try {
      final data = await serviceRepo.getServiceByGroup(
        event.type,
        force: event.isCallAPI,
      );
      emit(GetServiceByGroupSuccess(data));
    } catch (e) {
      emit(GetServiceByGroupFailure(e.toString()));
    }
  }

  Future<void> _onGetAccountsOcsDetail(
    GetAccountsOcsDetailEvent event,
    Emitter<HomeState> emit,
  ) async {
    // emit(state.copyWith(isLoading: true, error: null));
    final language = await SharePreferenceUtil.getLanguageCode();
    final isdn = await SharePreferenceUtil.getString(ShareKey.KEY_PHONE_NUMBER);

    final body = {
      "wsCode": "wsGetAccountsOcsDetailV2",
      "apiKey": ApiEndPoint.API_KEY,
      "language": language,
      "versionApp": DeviceUtils.getVersion(),
      "wsRequest": {"isdn": isdn, "language": language},
    };

    try {
      final result = await ApiUtil.getInstance()!
          .postParsed<BaseResponseV2<BaseResult<List<AccountsOcsDetailModel>>>>(
            url: ApiEndPoint.API_USER_ROUTING,
            body: body,
            fromJson: (json) => BaseResponseV2.fromJson(
              json,
              (data) => BaseResult<List<AccountsOcsDetailModel>>.fromJson(
                data,
                (list) => (list as List)
                    .map((e) => AccountsOcsDetailModel.fromJson(e))
                    .toList(),
              ),
            ),
          );

      if (result.isSuccess && result.result?.wsResponse != null) {
        final wsResponse = result.result!.wsResponse as List<dynamic>;
        AccountsOcsDetailModel? getOcsByType(String type) {
          for (final e in wsResponse.cast<AccountsOcsDetailModel>()) {
            if (e.type == type) {
              return e;
            }
          }
          return null;
        }

        emit(
          GetAccountsOcsDetailSuccess(
            getOcsByType('basic'),
            getOcsByType('data'),
            getOcsByType('call'),
            getOcsByType('sms'),
            getOcsByType('roaming'),
          ),
        );

        AppLogger().logInfo(
          'AccountsOcsDetailModel success: ${result.result!.wsResponse}',
        );
      } else {
        emit(GetAccountsOcsDetailFailure("Fail"));
      }
    } catch (e) {
      emit(GetAccountsOcsDetailFailure(e.toString()));
      AppLogger().logError(e.toString());
    }
  }

  Future<void> _onSignUp(SignUpEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    Map<String, dynamic> body = {
      "apiKey": "",
      "sessionId": "",
      "username": "",
      "wsCode": "",
      "wsRequest": {
        "confirmOtp": event.confirmOtp,
        "otp": event.otp,
        "phone_number": event.phoneNumber,
      },
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

  Future<void> _onGenerateOTP(
    GenerateOTPEvent event,
    Emitter<HomeState> emit,
  ) async {
    Map<String, dynamic> body = {
      "apiKey": "",
      "sessionId": "",
      "username": "",
      "wsCode": "",
      "wsRequest": {"phone_number": event.phoneNumber},
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

  Future<void> _onSignIn(SignInEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());

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
      },
    };

    try {
      BaseResponse result = await ApiUtil.getInstance()!.post(
        url: ApiEndPoint.API_SIGN_IN,
        body: body,
      );

      SignInResponse signInResponse = SignInResponse.fromJson(
        result.data ?? {},
      );

      if (signInResponse.isSuccess && signInResponse.signInData != null) {
        emit(
          SignInSuccess(
            signInResponse.message ?? "",
            signInResponse.signInData!,
          ),
        );
      } else {
        emit(SignInFailure(signInResponse.message ?? "Failed"));
      }
    } catch (e) {
      emit(SignInFailure("Network error: ${e.toString()}"));
    }
  }

  Future<void> _onGetUserInfo(
    GetUserInfoEvent event,
    Emitter<HomeState> emit,
  ) async {
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
