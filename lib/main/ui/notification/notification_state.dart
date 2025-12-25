part of 'notification_bloc.dart';

class NotificationState {
  final List<NotificationItem> newsNotifications;
  final List<NotificationItem> complainNotifications;
  final bool isLoadingNews;
  final bool isLoadingComplain;

  NotificationState({
    required this.newsNotifications,
    required this.complainNotifications,
    required this.isLoadingNews,
    required this.isLoadingComplain,
  });

  factory NotificationState.initial() => NotificationState(
    newsNotifications: [],
    complainNotifications: [],
    isLoadingNews: false,
    isLoadingComplain: false,
  );

  NotificationState copyWith({
    List<NotificationItem>? newsNotifications,
    List<NotificationItem>? complainNotifications,
    bool? isLoadingNews,
    bool? isLoadingComplain,
  }) {
    return NotificationState(
      newsNotifications: newsNotifications ?? this.newsNotifications,
      complainNotifications: complainNotifications ?? this.complainNotifications,
      isLoadingNews: isLoadingNews ?? this.isLoadingNews,
      isLoadingComplain: isLoadingComplain ?? this.isLoadingComplain,
    );
  }
}