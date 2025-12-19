import 'package:equatable/equatable.dart';

class FeedbackState extends Equatable {
  final double rating;
  final String title;
  final String content;
  final bool isSubmitting;
  final bool submitSuccess;
  final String? errorMessage;

  const FeedbackState({
    this.rating = 0,
    this.title = '',
    this.content = '',
    this.isSubmitting = false,
    this.submitSuccess = false,
    this.errorMessage,
  });

  FeedbackState copyWith({
    double? rating,
    String? title,
    String? content,
    bool? isSubmitting,
    bool? submitSuccess,
    String? errorMessage,
  }) {
    return FeedbackState(
      rating: rating ?? this.rating,
      title: title ?? this.title,
      content: content ?? this.content,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitSuccess: submitSuccess ?? this.submitSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [rating, title, content, isSubmitting, submitSuccess, errorMessage];
}