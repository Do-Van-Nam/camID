import 'package:cam_id/main/base/base_response_v2.dart';
import 'package:cam_id/main/base/base_result.dart';
import 'package:cam_id/main/data/api/api_end_point.dart';
import 'package:cam_id/main/data/api/api_util.dart';
import 'package:cam_id/main/data/model/my_service_group_model.dart';
import 'package:cam_id/main/data/model/service_group_model.dart';
import 'package:cam_id/main/data/response/do_action_service_response.dart';
import 'package:cam_id/main/data/share_preference/share_preference.dart';
import 'package:cam_id/main/ui/metfone_service/metfone_service_event.dart';
import 'package:cam_id/main/ui/metfone_service/metfone_service_state.dart';
import 'package:cam_id/main/utils/constant.dart';
import 'package:cam_id/main/utils/device_utils.dart';
import 'package:cam_id/main/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MetfoneServiceBloc extends Bloc<MetfoneServiceEvent, MetfoneServiceState> {
  MetfoneServiceBloc() : super(MetfoneServiceInitial()) {
    on<GetServiceForYouEvent>(_onGetServiceForYou);
    on<GetMyServicesEvent>(_onGetCurrentUsedServices);
    on<StopActionServiceEvent>(_onStopDoActionService);
    on<DoActionServiceEvent>(_onDoActionService);
  }

  Future<void> _onGetCurrentUsedServices(
      GetMyServicesEvent event,
      Emitter<MetfoneServiceState> emit,
      ) async {
    emit(MetfoneServiceLoading());
    final language = await SharePreferenceUtil.getLanguageCode();
    final isdn = await SharePreferenceUtil.getString(ShareKey.KEY_PHONE_NUMBER);

    final body = {
      "apiKey": ApiEndPoint.API_KEY,
      "language": language,
      "sessionId": "",
      "token": "",
      "username": isdn,
      "versionApp": DeviceUtils.getVersion(),
      "wsCode": WSCode.wsGetCurrentUsedServices,
      "wsRequest": {
        "isdn": isdn,
        "language": language
      },
    };

    try {
      final result = await ApiUtil.getInstance()!
          .postParsed<BaseResponseV2<BaseResult<List<ServiceGroup>>>>(
        url: ApiEndPoint.API_USER_ROUTING,
        body: body,
        fromJson: (json) => BaseResponseV2.fromJson(
          json,
              (data) => BaseResult<List<ServiceGroup>>.fromJson(
            data,
                (list) => (list as List)
                .map((e) => ServiceGroup.fromJson(e))
                .toList(),
          ),
        ),
      );
      if (result.isSuccess && result.result?.wsResponse != null) {
        emit(GetMyServiceSuccess(result.result?.wsResponse));
      } else {
        emit(GetMyServiceFailure(result.result?.message??""));
      }
    } catch (e) {
      AppLogger().logError(e.toString());
      emit(GetMyServiceFailure(e.toString()));
    }
  }

  Future<void> _onGetServiceForYou(
      GetServiceForYouEvent event,
      Emitter<MetfoneServiceState> emit,
      ) async {
    emit(MetfoneServiceLoading());
    final language = await SharePreferenceUtil.getLanguageCode();
    final isdn = await SharePreferenceUtil.getString(ShareKey.KEY_PHONE_NUMBER);

    final body = {
      "apiKey": ApiEndPoint.API_KEY,
      "language": language,
      "sessionId": "",
      "token": "",
      "versionApp": DeviceUtils.getVersion(),
      "wsCode": WSCode.wsGetServices,
      "wsRequest": {
        "isdn": isdn,
        "language": language
      },
    };

    try {
      final result = await ApiUtil.getInstance()!
          .postParsed<BaseResponseV2<BaseResult<List<MyServiceGroup>>>>(
        url: ApiEndPoint.API_USER_ROUTING,
        body: body,
        fromJson: (json) => BaseResponseV2.fromJson(
          json,
              (data) => BaseResult<List<MyServiceGroup>>.fromJson(
            data,
                (list) => (list as List)
                .map((e) => MyServiceGroup.fromJson(e))
                .toList(),
          ),
        ),
      );

      if (result.isSuccess && result.result?.wsResponse != null) {
        emit(GetServiceForYouSuccess(result.result?.wsResponse));
      } else {
        emit(GetServiceForYouFailure(result.result?.message??""));
      }
    } catch (e) {
      AppLogger().logError(e.toString());
      emit(GetServiceForYouFailure(e.toString()));
    }
  }

  Future<void> _onStopDoActionService(
      StopActionServiceEvent event,
      Emitter<MetfoneServiceState> emit,
      ) async {
    emit(DoActionLoading());
    final language = await SharePreferenceUtil.getLanguageCode();
    final isdn = await SharePreferenceUtil.getString(ShareKey.KEY_PHONE_NUMBER);

    final body = {
      "language": language,
      "versionApp": DeviceUtils.getVersion(),
      "wsCode": WSCode.wsDoActionService,
      "wsRequest": {
        "isdn": isdn,
        "language": language,
        "actionType": Constant.WS_DO_ACTION_SERVICE_ACTION_TYPE_CANCEL,
        "serviceCode": event.serviceCode
      },
    };

    try {
      final result = await ApiUtil.getInstance()!
          .postParsed<BaseResponseV2<BaseResult<DoActionServiceResponse>>>(
        url: ApiEndPoint.API_USER_ROUTING,
        body: body,
        fromJson: (json) => BaseResponseV2.fromJson(
          json,
              (data) => BaseResult<DoActionServiceResponse>.fromJson(
            data,
                (json) => DoActionServiceResponse.fromJson(json)
          ),
        ),
      );

      if (result.isSuccess && result.result?.wsResponse != null) {
        if(result.result?.errorCode == "0"){
          emit(StopActionServiceSuccess());
        } else {
          emit(StopActionServiceFailure(result.result?.message??""));
        }

      } else {
        emit(StopActionServiceFailure(result.result?.message??""));
      }
    } catch (e) {
      AppLogger().logError(e.toString());
      emit(StopActionServiceFailure(e.toString()));
    }
  }

  Future<void> _onDoActionService(
      DoActionServiceEvent event,
      Emitter<MetfoneServiceState> emit,
      ) async {
    emit(DoActionLoading());
    final language = await SharePreferenceUtil.getLanguageCode();
    final isdn = await SharePreferenceUtil.getString(ShareKey.KEY_PHONE_NUMBER);

    final body = {
      "language": language,
      "versionApp": DeviceUtils.getVersion(),
      "wsCode": WSCode.wsDoActionService,
      "wsRequest": {
        "isdn": isdn,
        "language": language,
        "actionType": Constant.WS_DO_ACTION_SERVICE_ACTION_TYPE_CANCEL,
        "serviceCode": event.serviceCode
      },
    };

    try {
      final result = await ApiUtil.getInstance()!
          .postParsed<BaseResponseV2<BaseResult<DoActionServiceResponse>>>(
        url: ApiEndPoint.API_USER_ROUTING,
        body: body,
        fromJson: (json) => BaseResponseV2.fromJson(
          json,
              (data) => BaseResult<DoActionServiceResponse>.fromJson(
              data,
                  (json) => DoActionServiceResponse.fromJson(json)
          ),
        ),
      );

      if (result.isSuccess && result.result?.wsResponse != null) {
        if(result.result?.errorCode == "0"){
          emit(DoActionServiceSuccess(result.result?.wsResponse?.refId));
        } else {
          emit(DoActionServiceFailure(result.result?.message??""));
        }

      } else {
        emit(DoActionServiceFailure(result.result?.message??""));
      }
    } catch (e) {
      AppLogger().logError(e.toString());
      emit(DoActionServiceFailure(e.toString()));
    }
  }

}