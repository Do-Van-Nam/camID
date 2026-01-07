part of 'feedback_bloc.dart';

class FeedbackState {
  final List<NotificationItem> newsNotifications;
  final List<NotificationItem> complainNotifications;
  final bool isLoadingNews;
  final bool isLoadingComplain;

  FeedbackState({
    required this.newsNotifications,
    required this.complainNotifications,
    required this.isLoadingNews,
    required this.isLoadingComplain,
  });

  factory FeedbackState.initial() => FeedbackState(
    newsNotifications: [],
    complainNotifications: [],
    isLoadingNews: false,
    isLoadingComplain: false,
  );

  FeedbackState copyWith({
    List<NotificationItem>? newsNotifications,
    List<NotificationItem>? complainNotifications,
    bool? isLoadingNews,
    bool? isLoadingComplain,
  }) {
    return FeedbackState(
      newsNotifications: newsNotifications ?? this.newsNotifications,
      complainNotifications:
          complainNotifications ?? this.complainNotifications,
      isLoadingNews: isLoadingNews ?? this.isLoadingNews,
      isLoadingComplain: isLoadingComplain ?? this.isLoadingComplain,
    );
  }
}
