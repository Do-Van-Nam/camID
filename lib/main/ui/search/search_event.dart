import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchTextChanged extends SearchEvent {
  final String query;

  SearchTextChanged(this.query);

  @override
  List<Object> get props => [query];
}