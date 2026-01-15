import 'package:cam_id/main/data/model/province_model.dart';
import 'package:equatable/equatable.dart';

class RegisterFtthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterFtthInitial extends RegisterFtthState {}

class RegisterFtthLoading extends RegisterFtthState {}

class GetListProvinceSuccess extends RegisterFtthState {
  final List<ProvinceModel> listProvince;

  GetListProvinceSuccess(this.listProvince);
}

class GetListProvinceFailure extends RegisterFtthState {
  final String message;

  GetListProvinceFailure(this.message);
}

class GenerateOTPFTTHSuccess extends RegisterFtthState {

}

class GenerateOTPFTTHFailure extends RegisterFtthState {
  final String message;

  GenerateOTPFTTHFailure(this.message);
}
