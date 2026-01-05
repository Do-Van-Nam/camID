import 'package:cam_id/main/data/model/user_info_model.dart';
import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final bool isLoggedIn;
  final int bannerIndex;
  final bool navigateToLogin;

  const HomeState({
    required this.isLoggedIn,
    required this.bannerIndex,
    this.navigateToLogin = false,
  });

  factory HomeState.initial() {
    return HomeState(
      isLoggedIn: UserInfoModel.instance.username.isNotEmpty,
      bannerIndex: 0,
    );
  }

  HomeState copyWith({
    bool? isLoggedIn,
    int? bannerIndex,
    bool? navigateToLogin,
  }) {
    return HomeState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      bannerIndex: bannerIndex ?? this.bannerIndex,
      navigateToLogin: navigateToLogin ?? false,
    );
  }

  @override
  List<Object?> get props => [isLoggedIn, bannerIndex, navigateToLogin];
}
