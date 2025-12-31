import 'package:equatable/equatable.dart';

abstract class IdentityVerificationEvent extends Equatable{
  @override
  List<Object?> get props => [];
}
enum PaperType {
  front,
  back,
  selfie,
}

class DetectOCRFromImageEvent extends IdentityVerificationEvent {
  final String image;
  final String language;
  final String type;

  DetectOCRFromImageEvent(this.image, this.language, this.type);
}

class SelectImageEvent extends IdentityVerificationEvent {
  final PaperType type;

  SelectImageEvent(this.type);

  @override
  List<Object?> get props => [type];
}

class ContinueEvent extends IdentityVerificationEvent {
  final String language;
  final String idType;

  ContinueEvent(this.language, this.idType);

  @override
  List<Object?> get props => [language, idType];
}

class ResetNavigationEvent extends IdentityVerificationEvent {}

