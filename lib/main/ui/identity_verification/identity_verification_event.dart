import 'package:equatable/equatable.dart';

abstract class IdentityVerificationEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class DetectOCRFromImageEvent extends IdentityVerificationEvent {
  final String image;
  final String language;
  final String type;

  DetectOCRFromImageEvent(this.image, this.language, this.type);
}