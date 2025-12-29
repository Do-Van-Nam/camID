import 'package:cam_id/main/base/base_response_v2.dart';
import 'package:cam_id/main/base/base_result.dart';
import 'package:cam_id/main/data/api/api_end_point.dart';
import 'package:cam_id/main/data/api/api_util.dart';
import 'package:cam_id/main/data/response/paper_response.dart';
import 'package:cam_id/main/ui/select_id_type/select_id_type_event.dart';
import 'package:cam_id/main/ui/select_id_type/select_id_type_state.dart';
import 'package:cam_id/main/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectIdTypeBloc extends Bloc<SelectIDTypeEvent, SelectIDTypeState> {
  SelectIdTypeBloc() : super(SelectIDTypeInitial()) {
    on<GetListPaperTypeEvent>(_onGetListPaperType);
  }

  Future<void> _onGetListPaperType(
    GetListPaperTypeEvent event,
    Emitter<SelectIDTypeState> emit,
  ) async {
    Map<String, dynamic> body = {
      "apiKey": ApiEndPoint.API_KEY_V2,
      "sessionId": "",
      "username": "",
      "token": "",
      "language": event.language,
      "versionApp": "",
      "wsCode": "getListPaperType",
      "wsRequest": {"language": event.language},
    };

    try {
      final baseResponse = await ApiUtil.getInstance()!
          .postParsed<BaseResponseV2<BaseResult<List<PaperResponse>>>>(
        url: ApiEndPoint.API_USER_ROUTING,
        body: body,
        fromJson: (json) => BaseResponseV2.fromJson(
          json,
              (data) => BaseResult<List<PaperResponse>>.fromJson(
            data,
                (list) => (list as List)
                .map((e) => PaperResponse.fromJson(e))
                .toList(),
          ),
        ),
      );

      if (baseResponse.isSuccess) {
        emit(GetListPaperTypeSuccess(baseResponse.errorMessage ?? "", baseResponse.result?.wsResponse));
      } else {
        emit(GetListPaperTypeFailure(baseResponse.errorMessage ?? "Fail"));
      }
    } catch (e) {
      emit(GetListPaperTypeFailure("Network error: ${e.toString()}"));
      AppLogger().logInfo("Network error: ${e.toString()}");
    }
  }
}
