part of 'feedback_detail_bloc.dart';

class NotificationDetailState {
  final List<NotificationItem> newsNotifications;
  final List<NotificationItem> complainNotifications;
  final bool isLoadingNews;
  final bool isLoadingComplain;

  NotificationDetailState({
    required this.newsNotifications,
    required this.complainNotifications,
    required this.isLoadingNews,
    required this.isLoadingComplain,
  });

  factory NotificationDetailState.initial() => NotificationDetailState(
    newsNotifications: [],
    complainNotifications: [],
    isLoadingNews: false,
    isLoadingComplain: false,
  );

  NotificationDetailState copyWith({
    List<NotificationItem>? newsNotifications,
    List<NotificationItem>? complainNotifications,
    bool? isLoadingNews,
    bool? isLoadingComplain,
  }) {
    return NotificationDetailState(
      newsNotifications: newsNotifications ?? this.newsNotifications,
      complainNotifications:
          complainNotifications ?? this.complainNotifications,
      isLoadingNews: isLoadingNews ?? this.isLoadingNews,
      isLoadingComplain: isLoadingComplain ?? this.isLoadingComplain,
    );
  }
}
