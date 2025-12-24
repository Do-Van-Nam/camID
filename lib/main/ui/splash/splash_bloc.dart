import 'package:flutter_bloc/flutter_bloc.dart';
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
      final config = await _loadRemoteConfig();

      if (config.forceUpdate) {
        emit(SplashResolved(next: SplashNext.forceUpdate));
        return;
      }

      if (config.maintenance) {
        emit(SplashResolved(next: SplashNext.maintenance));
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
      emit(SplashError(e.toString()));
    }
  }

  Future<_RemoteConfig> _loadRemoteConfig() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _RemoteConfig(
      forceUpdate: false,
      maintenance: false,
    );
  }

  Future<bool> _isLoggedIn() async {
    final isLoggedIn = UserInfoModel.instance.username.isNotEmpty;

    return isLoggedIn; // demo
  }
}

class _RemoteConfig {
  final bool forceUpdate;
  final bool maintenance;

  _RemoteConfig({
    required this.forceUpdate,
    required this.maintenance,
  });
}
