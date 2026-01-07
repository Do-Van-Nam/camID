import 'package:cam_id/main/data/model/banner_model.dart';
import 'package:cam_id/main/data/model/mobile_package_model.dart';
import 'package:cam_id/main/data/model/user_info_model.dart';
import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final bool isLoading;
  final bool isLoggedIn;
  final int bannerIndex;
  final bool navigateToLogin;
  final List<AdsModel>? listBannerFooter;
  final List<AdsModel>? listVasService;
  final List<PackageModel>? listPackageMobile;
  final String? error;

  const HomeState({
    required this.isLoggedIn,
    required this.bannerIndex,
    this.navigateToLogin = false,
    this.listBannerFooter,
    this.listVasService,
    this.listPackageMobile, required this.isLoading,
    this.error,
  });

  factory HomeState.initial() {
    return HomeState(
      isLoggedIn: UserInfoModel.instance.username.isNotEmpty,
      bannerIndex: 0, isLoading: false,
    );
  }

  HomeState copyWith({
    bool? isLoggedIn,
    int? bannerIndex,
    bool? isLoading,
    bool? navigateToLogin,
    List<AdsModel>? listBannerFooter,
    List<AdsModel>? listVasService,
    List<PackageModel>? listPackageMobile,
    String? error,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      bannerIndex: bannerIndex ?? this.bannerIndex,
      navigateToLogin: navigateToLogin ?? false,
      listBannerFooter: listBannerFooter ?? this.listBannerFooter,
      listVasService: listVasService ?? this.listVasService,
      listPackageMobile: listPackageMobile ?? this.listPackageMobile,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isLoggedIn,
    bannerIndex,
    navigateToLogin,
    listBannerFooter,
    listVasService,
    listPackageMobile,
    error
  ];
}
