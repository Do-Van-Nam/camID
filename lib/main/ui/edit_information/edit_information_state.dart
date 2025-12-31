import 'package:equatable/equatable.dart';

abstract class EditInformationState extends Equatable{
  @override
  List<Object?> get props => [];
}

class EditInformationInitial extends EditInformationState {}

class EditInformationLoading extends EditInformationState {}

class UpdateUserSuccess extends EditInformationState {
  final String message;

  UpdateUserSuccess(this.message);
}

class UpdateUserFailure extends EditInformationState {
  final String message;

  UpdateUserFailure(this.message);
}