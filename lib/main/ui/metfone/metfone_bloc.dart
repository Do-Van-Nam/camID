import 'package:cam_id/main/base/base_response_v2.dart';
import 'package:cam_id/main/base/base_result.dart';
import 'package:cam_id/main/data/api/api_end_point.dart';
import 'package:cam_id/main/data/api/api_util.dart';
import 'package:cam_id/main/data/model/banner_model.dart';
import 'package:cam_id/main/data/model/ftth_package_model.dart';
import 'package:cam_id/main/data/model/mobile_package_model.dart';
import 'package:cam_id/main/data/repository/all_app_repository.dart';
import 'package:cam_id/main/data/repository/service_by_group_repository.dart';
import 'package:cam_id/main/data/response/all_app_response.dart';
import 'package:cam_id/main/data/share_preference/share_preference.dart';
import 'package:cam_id/main/ui/metfone/metfone_event.dart';
import 'package:cam_id/main/ui/metfone/metfone_state.dart';
import 'package:cam_id/main/utils/constant.dart';
import 'package:cam_id/main/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MetfoneBloc extends Bloc<MetfoneEvent, MetfoneState> {
  final AppRepository appRepo;
  final ServiceRepository serviceRepo;

  MetfoneBloc(this.appRepo, this.serviceRepo) : super(MetfoneState.initial()) {
    on<BannerHeaderChanged>(_onBannerHeaderChanged);
    on<BannerFooterChanged>(_onBannerFooterChanged);
    on<GetAllAppsEvent>(_onGetAllApp);
    on<GetServiceByGroupAppsEvent>(_onGetServiceByGroup);
    on<GetFTTHPackageAppsEvent>(_onGetFTTHPackage);
  }


  void _onBannerHeaderChanged(
    BannerHeaderChanged event,
    Emitter<MetfoneState> emit,
  ) {
    emit(state.copyWith(bannerHeaderIndex: event.index));
  }

  void _onBannerFooterChanged(
    BannerFooterChanged event,
    Emitter<MetfoneState> emit,
  ) {
    emit(state.copyWith(bannerFooterIndex: event.index));
  }

  Future<void> _onGetAllApp(
      GetAllAppsEvent event,
      Emitter<MetfoneState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final response = await appRepo.getAllApps(force: event.isCallAPI);
      final ads = response.adBanner;

      final bannerHeaderList = <AdsModel>[];
      final bannerFooterList = <AdsModel>[];
      final tv360List = <AdsModel>[];
      final vasServiceList = <AdsModel>[];
      final gameList = <AdsModel>[];

      for (final item in ads!) {
        switch (item.type) {
          case Constant.SLIDER_METFONE_HEADER: bannerHeaderList.add(item); break;
          case Constant.SLIDER_METFONE_FOOTER: bannerFooterList.add(item); break;
          case Constant.TAB_GAME_MF: gameList.add(item); break;
          case Constant.TV360_TYPE: tv360List.add(item); break;
          case Constant.VAS_SERVICE: vasServiceList.add(item); break;
        }
      }
      bannerHeaderList.sort((a, b) {
        final oa = int.tryParse(a.orderBy ?? '') ?? 0;
        final ob = int.tryParse(b.orderBy ?? '') ?? 0;
        return oa.compareTo(ob);
      });

      bannerFooterList.sort((a, b) {
        final oa = int.tryParse(a.orderBy ?? '') ?? 0;
        final ob = int.tryParse(b.orderBy ?? '') ?? 0;
        return oa.compareTo(ob);
      });

      gameList.sort((a, b) {
        final oa = int.tryParse(a.orderBy ?? '') ?? 0;
        final ob = int.tryParse(b.orderBy ?? '') ?? 0;
        return oa.compareTo(ob);
      });

      tv360List.sort((a, b) {
        final oa = int.tryParse(a.orderBy ?? '') ?? 0;
        final ob = int.tryParse(b.orderBy ?? '') ?? 0;
        return oa.compareTo(ob);
      });
      vasServiceList.sort((a, b) {
        final oa = int.tryParse(a.orderBy ?? '') ?? 0;
        final ob = int.tryParse(b.orderBy ?? '') ?? 0;
        return oa.compareTo(ob);
      });

      emit(
        state.copyWith(
          isLoading: false,
          listBannerHeader: bannerHeaderList,
          listBannerFooter: bannerFooterList,
          listGame: gameList,
          listTV360: tv360List,
          listVasService: vasServiceList,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onGetServiceByGroup(
      GetServiceByGroupAppsEvent event,
      Emitter<MetfoneState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final data = await serviceRepo.getServiceByGroup(event.type, force: event.isCallAPI);

      emit(
        state.copyWith(
          isLoading: false,
          listPackageMobile: data,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onGetFTTHPackage(
      GetFTTHPackageAppsEvent event,
      Emitter<MetfoneState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, error: null));
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
        emit(
          state.copyWith(
              isLoading: false,
              listPackageFTTH: result.result?.wsResponse
          ),
        );

        AppLogger().logInfo('GetFTTHPackage success: ${result.result!.wsResponse}');
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            error: result.errorMessage ?? 'GetFTTHPackage failed',
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
      AppLogger().logError(e.toString());
    }
  }
}
