import 'package:cam_id/main/data/response/paper_response.dart';
import 'package:equatable/equatable.dart';

abstract class SelectIDTypeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SelectIDTypeInitial extends SelectIDTypeState {}

class SelectIDTypeLoading extends SelectIDTypeState {}

class GetListPaperTypeSuccess extends SelectIDTypeState {
  final String message;
  final List<PaperResponse>? listPaper;

  GetListPaperTypeSuccess(this.message, this.listPaper);
}

class GetListPaperTypeFailure extends SelectIDTypeState {
  final String message;

  GetListPaperTypeFailure(this.message);
}