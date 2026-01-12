import 'dart:convert';
import 'dart:io';

import 'package:cam_id/main/base/base_response_v2.dart';
import 'package:cam_id/main/data/api/api_end_point.dart';
import 'package:cam_id/main/data/api/api_util.dart';
import 'package:cam_id/main/data/model/detect_info_model.dart';
import 'package:cam_id/main/data/response/detect_ocr_from_image_response.dart';
import 'package:cam_id/main/ui/identity_verification/identity_verification_event.dart';
import 'package:cam_id/main/ui/identity_verification/identity_verification_state.dart';
import 'package:cam_id/main/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class IdentityVerificationBloc
    extends Bloc<IdentityVerificationEvent, IdentityVerificationState> {
  IdentityVerificationBloc() : super(const IdentityVerificationState()) {
    on<DetectOCRFromImageEvent>(_onDetectOCRFromImageEvent);
    on<SelectImageEvent>(_onSelectImage);
    on<ContinueEvent>(_onContinue);
    on<ResetNavigationEvent>((event, emit) {
      emit(state.copyWith(
        skipOcr: false,
        detectInfo: null,
        ocrFailed: false,
      ));
    });

  }

  Future<void> _onDetectOCRFromImageEvent(
      DetectOCRFromImageEvent event,
      Emitter<IdentityVerificationState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, ocrFailed: false));

    final body = {
      "wsCode": WSCode.wsDetectOCRFromImage,
      "wsRequest": {
        "image": event.image,
        "type": event.type,
        "language": event.language,
      },
    };

    try {
      final result = await ApiUtil.getInstance()!
          .postParsed<BaseResponseV2<DetectORCResponse>>(
        url: ApiEndPoint.API_USER_ROUTING,
        body: body,
        fromJson: (json) => BaseResponseV2.fromJson(
          json,
              (data) => DetectORCResponse.fromJson(data),
        ),
      );

      if (result.isSuccess && result.result != null) {
        emit(state.copyWith(
          isLoading: false,
          detectInfo: DetectInfoModel.fromOcrResponse(result.result!),
        ));
      } else {
        // OCR fail nhưng vẫn cho tiếp tục
        emit(state.copyWith(
          isLoading: false,
          ocrFailed: true,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        ocrFailed: true,
      ));
      AppLogger().logInfo(e.toString());
    }
  }

  Future<void> _onSelectImage(
      SelectImageEvent event,
      Emitter<IdentityVerificationState> emit,
      ) async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (pickedFile == null) return;

    final imagePath = pickedFile.path;

    switch (event.type) {
      case PaperType.front:
        emit(state.copyWith(paperFrontImage: imagePath));
        break;

      case PaperType.back:
        emit(state.copyWith(paperBackImage: imagePath));
        break;

      case PaperType.selfie:
        emit(state.copyWith(paperSelfieImage: imagePath));
        break;
    }
  }

  Future<void> _onContinue(
      ContinueEvent event,
      Emitter<IdentityVerificationState> emit,
      ) async {
    if (state.paperFrontImage == null) {
      emit(state.copyWith(errorMessage: "Front image required"));
      return;
    }

    if (event.idType == "ARMY_ID" ||
        event.idType == "MONK_ID" ||
        event.idType == "POLICE_ID") {
      emit(state.copyWith(skipOcr: true));
      return;
    }

    add(
      DetectOCRFromImageEvent(
        await fileImageToBase64(state.paperFrontImage!),
        event.language,
        event.idType,
      ),
    );
  }

  Future<String> fileImageToBase64(String imagePath) async {
    final File file = File(imagePath);
    final List<int> imageBytes = await file.readAsBytes();
    return base64Encode(imageBytes);
  }

}
