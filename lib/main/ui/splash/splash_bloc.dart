import 'package:cam_id/main/data/model/remote_config_model.dart';
import 'package:cam_id/main/data/model/user_info_model.dart';
import 'package:cam_id/main/utils/device_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/service/remote_config_service.dart';
import '../../utils/utility_fuctions.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<SplashStarted>(_onStart);
  }

  Future<void> _onStart(
      SplashStarted event,
      Emitter<SplashState> emit,
      ) async {
    try {
      emit(SplashLoading());

      /// 1️⃣ Load remote config
      final config = RemoteConfigService().config;

      final currentVersion = await DeviceUtils.getVersionName();

      if (compareVersion(currentVersion, config.minVersion) < 0) {
        emit(SplashResolved(next: SplashNext.forceUpdate, content: "force"));
        return;
      }

      if (compareVersion(currentVersion, config.latestVersion) < 0) {
        emit(SplashResolved(next: SplashNext.forceUpdate));
        return;
      }

      if (config.maintenanceMode) {
        emit(SplashResolved(next: SplashNext.maintenance, content: config.maintenanceMessage));
        return;
      }

      /// 3️⃣ Auth
      final isLogin = await _isLoggedIn();
      emit(
        SplashResolved(
          next: isLogin ? SplashNext.home : SplashNext.login,
        ),
      );
    } catch (e) {
      /// 3️⃣ Auth
      final isLogin = await _isLoggedIn();
      emit(
        SplashResolved(
          next: isLogin ? SplashNext.home : SplashNext.login,
        ),
      );
    }
  }

  Future<bool> _isLoggedIn() async {
    final isLoggedIn = UserInfoModel.instance.username.isNotEmpty;

    return isLoggedIn; // demo
  }
}

