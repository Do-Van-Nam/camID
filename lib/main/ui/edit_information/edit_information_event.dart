import 'package:cam_id/main/data/model/user_info_model.dart';
import 'package:equatable/equatable.dart';

abstract class EditInformationEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class UpdateUserEvent extends EditInformationEvent{
  final String token;
  final UserInfoModel? user;

  UpdateUserEvent(this.token, this.user);
}