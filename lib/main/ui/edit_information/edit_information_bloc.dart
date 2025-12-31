import 'package:cam_id/main/base/base_response.dart';
import 'package:cam_id/main/data/api/api_end_point.dart';
import 'package:cam_id/main/data/api/api_util.dart';
import 'package:cam_id/main/data/model/sign_in_model.dart';
import 'package:cam_id/main/data/response/sign_in_response.dart';
import 'package:cam_id/main/data/response/user_info_response.dart';
import 'package:cam_id/main/ui/edit_information/edit_information_event.dart';
import 'package:cam_id/main/ui/edit_information/edit_information_state.dart';
import 'package:cam_id/main/ui/login/login_event.dart';
import 'package:cam_id/main/ui/login/login_state.dart';
import 'package:cam_id/main/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditInformationBloc extends Bloc<EditInformationEvent, EditInformationState> {
  EditInformationBloc() : super(EditInformationInitial()) {
    on<UpdateUserEvent>(_onUpdateUser);
  }

  Future<void> _onUpdateUser(UpdateUserEvent event, Emitter<EditInformationState> emit) async {
    emit(EditInformationLoading());
    Map<String, dynamic> body = {
      "apiKey": "",
      "sessionId": "",
      "username": "",
      "wsCode": "",
      "wsRequest": {

      }
    };
    try {
      BaseResponse result = await ApiUtil.getInstance()!.post(
        url: ApiEndPoint.API_SIGN_UP,
        body: body,
      );

      SignInResponse? signInData;
      if (result.isSuccess && result.data != null) {
        signInData = SignInResponse.fromJson(result.data);
      }
      if (result.isSuccess) {
        emit(UpdateUserSuccess(result.message ?? ""));
      } else {
        emit(UpdateUserFailure(result.message ?? "Fail"));
      }
    } catch (e) {
      emit(UpdateUserFailure("Network error: ${e.toString()}"));
    }
  }
}