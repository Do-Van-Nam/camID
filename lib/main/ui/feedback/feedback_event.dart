import 'package:equatable/equatable.dart';

abstract class FeedbackEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RatingChanged extends FeedbackEvent {
  final double rating;
  RatingChanged(this.rating);
  @override
  List<Object?> get props => [rating];
}

class TitleChanged extends FeedbackEvent {
  final String title;
  TitleChanged(this.title);
  @override
  List<Object?> get props => [title];
}

class ContentChanged extends FeedbackEvent {
  final String content;
  ContentChanged(this.content);
  @override
  List<Object?> get props => [content];
}

class SubmitFeedback extends FeedbackEvent {}

class OpenUpdateApp extends FeedbackEvent {}