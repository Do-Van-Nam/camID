import 'package:cam_id/main/data/model/my_service_group_model.dart';
import 'package:cam_id/main/data/model/service_group_model.dart';
import 'package:equatable/equatable.dart';

class MetfoneServiceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MetfoneServiceInitial extends MetfoneServiceState {}

class MetfoneServiceLoading extends MetfoneServiceState {}
class DoActionLoading extends MetfoneServiceState {}

class GetServiceForYouSuccess extends MetfoneServiceState {
  final List<MyServiceGroup>? listService;

  GetServiceForYouSuccess(this.listService);

}

class GetServiceForYouFailure extends MetfoneServiceState {
  final String message;

  GetServiceForYouFailure(this.message);
}

class GetMyServiceSuccess extends MetfoneServiceState {
  final List<ServiceGroup>? listService;

  GetMyServiceSuccess(this.listService);

}

class GetMyServiceFailure extends MetfoneServiceState {
  final String message;

  GetMyServiceFailure(this.message);
}
class StopActionServiceSuccess extends MetfoneServiceState {


}

class StopActionServiceFailure extends MetfoneServiceState {
  final String message;

  StopActionServiceFailure(this.message);
}

class DoActionServiceSuccess extends MetfoneServiceState {
  final String? refId;

  DoActionServiceSuccess(this.refId);

}

class DoActionServiceFailure extends MetfoneServiceState {
  final String message;

  DoActionServiceFailure(this.message);
}