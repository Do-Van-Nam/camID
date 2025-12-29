import 'package:equatable/equatable.dart';

abstract class IdentityVerificationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class IdentityVerificationInitial extends IdentityVerificationState {}

class IdentityVerificationLoading extends IdentityVerificationState {}

class DetectOCRFromImageSuccess extends IdentityVerificationState {
  final String message;

  DetectOCRFromImageSuccess(this.message);
}

class DetectOCRFromImageFailure extends IdentityVerificationState {
  final String message;

  DetectOCRFromImageFailure(this.message);
}