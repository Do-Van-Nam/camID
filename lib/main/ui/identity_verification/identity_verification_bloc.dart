import 'package:cam_id/main/base/base_response_v2.dart';
import 'package:cam_id/main/data/api/api_end_point.dart';
import 'package:cam_id/main/data/api/api_util.dart';
import 'package:cam_id/main/data/response/detect_ocr_from_image_response.dart';
import 'package:cam_id/main/ui/identity_verification/identity_verification_event.dart';
import 'package:cam_id/main/ui/identity_verification/identity_verification_state.dart';
import 'package:cam_id/main/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IdentityVerificationBloc
    extends Bloc<IdentityVerificationEvent, IdentityVerificationState> {
  IdentityVerificationBloc() : super(IdentityVerificationInitial()) {
    on<DetectOCRFromImageEvent>(_onDetectOCRFromImageEvent);
  }

  Future<void> _onDetectOCRFromImageEvent(
    DetectOCRFromImageEvent event,
    Emitter<IdentityVerificationState> emit,
  ) async {
    Map<String, dynamic> body = {
      "apiKey": "",
      "sessionId": "",
      "username": "",
      "token": "",
      "language": "",
      "versionApp": "",
      "wsCode": "wsDetectOCRFromImage",
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

      if (result.isSuccess) {
        emit(DetectOCRFromImageSuccess(result.errorMessage ?? ""));
      } else {
        emit(DetectOCRFromImageFailure(result.errorMessage ?? "Fail"));
      }
    } catch (e) {
      emit(DetectOCRFromImageFailure("Network error: ${e.toString()}"));
      AppLogger().logInfo("Network error: ${e.toString()}");
    }
  }
}
