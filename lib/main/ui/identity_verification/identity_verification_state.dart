import 'package:cam_id/main/data/model/detect_info_model.dart';
import 'package:equatable/equatable.dart';

class IdentityVerificationState extends Equatable {
  final String? paperFrontImage;
  final String? paperBackImage;
  final String? paperSelfieImage;

  final bool isLoading;
  final String? errorMessage;

  final DetectInfoModel? detectInfo;
  final bool ocrFailed;
  final bool skipOcr;

  const IdentityVerificationState({
    this.paperFrontImage,
    this.paperBackImage,
    this.paperSelfieImage,
    this.isLoading = false,
    this.errorMessage,
    this.detectInfo,
    this.ocrFailed = false,
    this.skipOcr = false,
  });

  IdentityVerificationState copyWith({
    String? paperFrontImage,
    String? paperBackImage,
    String? paperSelfieImage,
    bool? isLoading,
    String? errorMessage,
    DetectInfoModel? detectInfo,
    bool? ocrFailed,
    bool? skipOcr,
  }) {
    return IdentityVerificationState(
      paperFrontImage: paperFrontImage ?? this.paperFrontImage,
      paperBackImage: paperBackImage ?? this.paperBackImage,
      paperSelfieImage: paperSelfieImage ?? this.paperSelfieImage,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      detectInfo: detectInfo ?? this.detectInfo,
      ocrFailed: ocrFailed ?? this.ocrFailed,
      skipOcr: skipOcr ?? this.skipOcr,
    );
  }

  @override
  List<Object?> get props => [
    paperFrontImage,
    paperBackImage,
    paperSelfieImage,
    isLoading,
    errorMessage,
    detectInfo,
    ocrFailed,
    skipOcr,
  ];
}
