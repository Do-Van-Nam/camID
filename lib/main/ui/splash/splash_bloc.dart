import 'package:cam_id/main/data/model/user_info_model.dart';
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

      // 🔹 Giả lập load app
      await Future.wait([
        Future.delayed(const Duration(seconds: 1)),
        _loadConfig(),
        _checkLogin(),
      ]);

      final isLogin = await _isLoggedIn();

      if (isLogin) {
        emit(SplashAuthenticated());
      } else {
        emit(SplashUnauthenticated());
      }
    } catch (e) {
      emit(SplashError(e.toString()));
    }
  }

  Future<void> _loadConfig() async {
    // gọi API config
  }

  Future<void> _checkLogin() async {
    // đọc token, refresh token
  }

  Future<bool> _isLoggedIn() async {
    final isLoggedIn = UserInfoModel.instance.username.isNotEmpty;

    return isLoggedIn; // demo
  }
}
