import 'package:cam_id/main/base/base_response_v2.dart';
import 'package:cam_id/main/base/base_result.dart';
import 'package:cam_id/main/data/api/api_end_point.dart';
import 'package:cam_id/main/data/api/api_util.dart';
import 'package:cam_id/main/data/model/acount_ftth_model.dart';
import 'package:cam_id/main/data/model/banner_model.dart';
import 'package:cam_id/main/data/model/ftth_package_model.dart';
import 'package:cam_id/main/data/repository/all_app_repository.dart';
import 'package:cam_id/main/data/share_preference/share_preference.dart';
import 'package:cam_id/main/ui/internet_wifi/internet_wifi_event.dart';
import 'package:cam_id/main/ui/internet_wifi/internet_wifi_state.dart';
import 'package:cam_id/main/utils/constant.dart';
import 'package:cam_id/main/utils/device_utils.dart';
import 'package:cam_id/main/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InternetWifiBloc extends Bloc<InternetWifiEvent, InternetWifiState> {
  final AppRepository appRepo;
  InternetWifiBloc(this.appRepo) : super(InternetWifiInitial()) {
    on<GetFTTHAccountEvent>(_onGetFTTHAccount);
    on<GetFTTHPackageAppsEvent>(_onGetFTTHPackage);
    on<GetAllAppsEvent>(_onGetAllApp);

  }
  Future<void> _onGetFTTHAccount(
      GetFTTHAccountEvent event,
      Emitter<InternetWifiState> emit,
      ) async {
    emit(InternetWifiLoading());
    final language = await SharePreferenceUtil.getLanguageCode();
    final isdn = await SharePreferenceUtil.getString(ShareKey.KEY_PHONE_NUMBER);
    final token = await SharePreferenceUtil.getString(
      ShareKey.KEY_ACCESS_TOKEN,
    );
    final headers = {
      "Authorization": token
    };

    try {
      final result = await ApiUtil.getInstance()!
          .getParsed<BaseResponseV2<BaseResult<List<FTTHAccountModel>>>>(
        url: ApiEndPoint.API_GET_FTTH_ACCOUNT,
        // body: body,
        headers: headers,
        fromJson: (json) => BaseResponseV2.fromJson(
          json,
              (data) => BaseResult<List<FTTHAccountModel>>.fromJson(
            data,
                (list) => (list as List)
                .map((e) => FTTHAccountModel.fromJson(e))
                .toList(),
          ),
        ),
      );
      if (result.isSuccess && result.result?.wsResponse != null && result.result?.wsResponse?.isNotEmpty == true) {
        emit(GetFTTHAccountSuccess(result.result!.wsResponse![0]));
      } else {
        emit(GetFTTHAccountFailure(result.result?.message??""));
      }
    } catch (e) {
      AppLogger().logError(e.toString());
      emit(GetFTTHAccountFailure(e.toString()));
    }
  }

  Future<void> _onGetFTTHPackage(
      GetFTTHPackageAppsEvent event,
      Emitter<InternetWifiState> emit,
      ) async {
    final language = await SharePreferenceUtil.getLanguageCode();
    final body = {
      "wsCode": WSCode.getPackageInforV2,
      "wsRequest": {
        "language": language
      },
    };

    try {
      final result = await ApiUtil.getInstance()!
          .postParsed<BaseResponseV2<BaseResult<List<PackageFtthModel>>>>(
        url: ApiEndPoint.API_USER_ROUTING,
        body: body,
        fromJson: (json) => BaseResponseV2.fromJson(
          json,
              (data) => BaseResult<List<PackageFtthModel>>.fromJson(
            data,
                (list) => (list as List)
                .map((e) => PackageFtthModel.fromJson(e))
                .toList(),
          ),
        ),
      );

      if (result.isSuccess && result.result?.wsResponse != null) {
        emit(GetFTTHPackagesSuccess(result.result!.wsResponse));
      } else {
        emit(GetFTTHPackagesFailure(result.result!.message??""));
      }
    } catch (e) {
      AppLogger().logError(e.toString());
      emit(GetFTTHPackagesFailure(""));
    }
  }

  Future<void> _onGetAllApp(
      GetAllAppsEvent event,
      Emitter<InternetWifiState> emit,
      ) async {
    final language = await SharePreferenceUtil.getLanguageCode();

    try {
      final response = await appRepo.getAllApps(force: event.isCallAPI);
      final ads = response.adBanner;

      final bannerFooterList = <AdsModel>[];

      for (final item in ads!) {
        switch (item.type) {
          case Constant.SLIDER_METFONE_FOOTER:
            bannerFooterList.add(item);
            break;
        }
      }

      bannerFooterList.sort((a, b) {
        final oa = int.tryParse(a.orderBy ?? '') ?? 0;
        final ob = int.tryParse(b.orderBy ?? '') ?? 0;
        return oa.compareTo(ob);
      });

      emit(GetAllAppSuccess(bannerFooterList));
    } catch (e) {
      emit(GetAllAppFailure(""));
    }
  }
}