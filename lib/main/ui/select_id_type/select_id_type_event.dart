import 'package:equatable/equatable.dart';

abstract class SelectIDTypeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetListPaperTypeEvent extends SelectIDTypeEvent {
  final String language;

  GetListPaperTypeEvent(this.language);
}