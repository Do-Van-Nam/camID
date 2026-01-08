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
  final DateTime fromDate;
  final DateTime toDate;
  final String filterServiceType;
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
    required this.fromDate,
    required this.toDate,
    required this.filterServiceType,
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
    fromDate: DateTime.now(),
    toDate: DateTime.now(),
    filterServiceType: 'e-money',
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
    DateTime? fromDate,
    DateTime? toDate,
    String? filterServiceType,
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
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      filterServiceType: filterServiceType ?? this.filterServiceType,
    );
  }
}
