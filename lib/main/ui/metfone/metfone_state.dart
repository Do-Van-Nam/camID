import 'package:cam_id/main/data/model/banner_model.dart';
import 'package:cam_id/main/data/model/ftth_package_model.dart';
import 'package:cam_id/main/data/model/mobile_package_model.dart';
import 'package:cam_id/main/data/response/all_app_response.dart';
import 'package:equatable/equatable.dart';

class MetfoneState extends Equatable {
  final int bannerHeaderIndex;
  final int bannerFooterIndex;
  final bool isLoading;
  final List<AdsModel>? listBannerHeader;
  final List<AdsModel>? listBannerFooter;
  final List<AdsModel>? listVasService;
  final List<AdsModel>? listGame;
  final List<AdsModel>? listTV360;

  final List<PackageModel>? listPackageMobile;
  final List<PackageFtthModel>? listPackageFTTH;
  final String? error;

  const MetfoneState({
    required this.bannerHeaderIndex,
    required this.bannerFooterIndex,
    required this.isLoading,
    this.listBannerHeader,
    this.listBannerFooter,
    this.listPackageMobile,
    this.listPackageFTTH,
    this.listVasService,
    this.listGame,
    this.listTV360,
    this.error,
  });

  factory MetfoneState.initial() {
    return const MetfoneState(
      bannerHeaderIndex: 0,
      bannerFooterIndex: 0,
      isLoading: false,
    );
  }

  MetfoneState copyWith({
    int? bannerHeaderIndex,
    int? bannerFooterIndex,
    bool? isLoading,
    List<AdsModel>? listBannerHeader,
    List<AdsModel>? listBannerFooter,
    List<PackageModel>? listPackageMobile,
    List<PackageFtthModel>? listPackageFTTH,
    List<AdsModel>? listVasService,
    List<AdsModel>? listGame,
    List<AdsModel>? listTV360,
    String? error,
  }) {
    return MetfoneState(
      bannerHeaderIndex: bannerHeaderIndex ?? this.bannerHeaderIndex,
      bannerFooterIndex: bannerFooterIndex ?? this.bannerFooterIndex,
      isLoading: isLoading ?? this.isLoading,
      listBannerHeader: listBannerHeader ?? this.listBannerHeader,
      listBannerFooter: listBannerFooter ?? this.listBannerFooter,
      listPackageMobile: listPackageMobile ?? this.listPackageMobile,
      listPackageFTTH: listPackageFTTH ?? this.listPackageFTTH,
      listVasService: listVasService ?? this.listVasService,
      listGame: listGame ?? this.listGame,
      listTV360: listTV360 ?? this.listTV360,

      error: error,
    );
  }

  @override
  List<Object?> get props => [
    bannerHeaderIndex,
    bannerFooterIndex,
    isLoading,
    listBannerHeader,
    listBannerFooter,
    listPackageMobile,
    listPackageFTTH,
    listVasService,
    listGame,
    listTV360,
    error,
  ];
}
