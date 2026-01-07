import 'package:cam_id/main/data/model/banner_model.dart';
import 'package:cam_id/main/data/model/user_info_model.dart';
import 'package:cam_id/main/data/repository/all_app_repository.dart';
import 'package:cam_id/main/data/repository/service_by_group_repository.dart';
import 'package:cam_id/main/data/share_preference/share_preference.dart';
import 'package:cam_id/main/ui/home/home_event.dart';
import 'package:cam_id/main/ui/home/home_state.dart';
import 'package:cam_id/main/utils/app_config.dart';
import 'package:cam_id/main/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/constant.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AppRepository appRepo;
  final ServiceRepository serviceRepo;
  HomeBloc(this.appRepo, this.serviceRepo) : super(HomeState.initial()) {
    on<HomeStarted>(_onStarted);
    on<BannerChanged>(_onBannerChanged);
    on<LoginTapped>(_onLoginTapped);
    on<GetAllAppsEvent>(_onGetAllApp);
    on<GetServiceByGroupAppsEvent>(_onGetServiceByGroup);
  }

  void _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    final user = await SharePreferenceUtil.getUser();
    AppLogger().logInfo("USER: ${user?.userId}");
    AppLogger().logInfo("USER: ${user?.username}");

    AppLogger().logInfo("USER: ${UserInfoModel.instance.userId}");
    AppLogger().logInfo("USER: ${UserInfoModel.instance.username}");
    emit(state.copyWith(
      isLoggedIn: UserInfoModel.instance.username.isNotEmpty == true,
    ));
  }

  void _onBannerChanged(
      BannerChanged event,
      Emitter<HomeState> emit,
      ) {
    emit(state.copyWith(bannerIndex: event.index));
  }

  Future<void> _onLoginTapped(
      LoginTapped event,
      Emitter<HomeState> emit,
      ) async {
    await SharePreferenceUtil.setBool(ShareKey.KEY_FIRST_OPEN_APP, false);
    await SharePreferenceUtil.setBool(ShareKey.KEY_CHANGE_OPEN_APP, true);
    AppConfig.instance.isFirstOpenApp = false;

    emit(state.copyWith(navigateToLogin: true));
  }

  Future<void> _onGetAllApp(
      GetAllAppsEvent event,
      Emitter<HomeState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, error: null));

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


      emit(
        state.copyWith(
          isLoading: false,
          listBannerFooter: bannerFooterList,
          listVasService: vasServiceList,
        )
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onGetServiceByGroup(
      GetServiceByGroupAppsEvent event,
      Emitter<HomeState> emit,
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

}
