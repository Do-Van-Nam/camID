import 'package:equatable/equatable.dart';

class FeedbackState extends Equatable {
  final double rating;
  final double satisLv;
  final double speedRate;
  final double priceRate;
  final double customerServiceRate;
  final double technicalRate;
  final String title;
  final String content;
  final bool isSubmitting;
  final bool submitSuccess;
  final String? errorMessage;

  const FeedbackState({
    this.rating = 0,
    this.satisLv = 0,
    this.speedRate = 0,
    this.priceRate = 0,
    this.customerServiceRate = 0,
    this.technicalRate = 0,
    this.title = '',
    this.content = '',
    this.isSubmitting = false,
    this.submitSuccess = false,
    this.errorMessage,
  });

  FeedbackState copyWith({
    double? rating,
    double? satisLv,
    double? speedRate,
    double? priceRate,
    double? customerServiceRate,
    double? technicalRate,
    String? title,
    String? content,
    bool? isSubmitting,
    bool? submitSuccess,
    String? errorMessage,
  }) {
    return FeedbackState(
      rating: rating ?? this.rating,
      satisLv: satisLv ?? this.satisLv,
      speedRate: speedRate ?? this.speedRate,
      priceRate: priceRate ?? this.priceRate,
      customerServiceRate: customerServiceRate ?? this.customerServiceRate,
      technicalRate: technicalRate ?? this.technicalRate,
      title: title ?? this.title,
      content: content ?? this.content,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitSuccess: submitSuccess ?? this.submitSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    rating,
    satisLv,
    speedRate,
    priceRate,
    customerServiceRate,
    technicalRate,
    title,
    content,
    isSubmitting,
    submitSuccess,
    errorMessage,
  ];
}
