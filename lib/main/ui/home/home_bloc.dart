import 'package:cam_id/main/data/share_preference/share_preference.dart';
import 'package:cam_id/main/ui/home/home_event.dart';
import 'package:cam_id/main/ui/home/home_state.dart';
import 'package:cam_id/main/utils/app_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState.initial()) {
    on<HomeStarted>(_onStarted);
    on<BannerChanged>(_onBannerChanged);
    on<LoginTapped>(_onLoginTapped);
  }

  void _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    final user = await SharePreferenceUtil.getUser();
    emit(state.copyWith(
      isLoggedIn: user?.username.isNotEmpty == true,
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
}
