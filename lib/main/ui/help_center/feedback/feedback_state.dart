part of 'feedback_bloc.dart';

class FeedbackState {
  final List<NotificationItem> newsNotifications;
  final List<NotificationItem> complainNotifications;
  final bool isLoadingNews;
  final bool isLoadingComplain;
  final String phoneNumber;
  final bool isSentOTP;
  final bool isInitial;
  final bool isLoadingRequest;
  final List<String> digits;
  final int remainingSeconds;
  final bool isResendEnabled;
  FeedbackState({
    required this.newsNotifications,
    required this.complainNotifications,
    required this.isLoadingNews,
    required this.isLoadingComplain,
    required this.phoneNumber,
    required this.digits,
    required this.remainingSeconds,
    required this.isResendEnabled,
    required this.isSentOTP,
    required this.isLoadingRequest,
    required this.isInitial,
  });

  factory FeedbackState.initial() => FeedbackState(
    newsNotifications: [],
    complainNotifications: [],
    isLoadingNews: false,
    isLoadingComplain: false,
    phoneNumber: "",
    digits: List.filled(6, ''),
    remainingSeconds: 60,
    isResendEnabled: false,
    isSentOTP: false,
    isLoadingRequest: false,
    isInitial: true,
  );

  FeedbackState copyWith({
    List<NotificationItem>? newsNotifications,
    List<NotificationItem>? complainNotifications,
    bool? isLoadingNews,
    bool? isLoadingComplain,
    String? phoneNumber,
    List<String>? digits,
    int? remainingSeconds,
    bool? isResendEnabled,
    bool? isSentOTP,
    bool? isLoadingRequest,
    bool? isInitial,
  }) {
    return FeedbackState(
      newsNotifications: newsNotifications ?? this.newsNotifications,
      complainNotifications:
          complainNotifications ?? this.complainNotifications,
      isLoadingNews: isLoadingNews ?? this.isLoadingNews,
      isLoadingComplain: isLoadingComplain ?? this.isLoadingComplain,
      isSentOTP: isSentOTP ?? this.isSentOTP,
      isLoadingRequest: isLoadingRequest ?? this.isLoadingRequest,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      digits: digits ?? this.digits,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isResendEnabled: isResendEnabled ?? this.isResendEnabled,
      isInitial: isInitial ?? this.isInitial,
    );
  }
}
