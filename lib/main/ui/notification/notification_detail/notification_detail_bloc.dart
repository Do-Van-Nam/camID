import 'package:cam_id/main/data/model/notify/notify_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notification_detail_event.dart';
part 'notification_detail_state.dart';

class NotificationDetailBloc
    extends Bloc<NotificationDetailEvent, NotificationDetailState> {
  NotificationDetailBloc() : super(NotificationDetailState.initial()) {
    // Load News Notifications
    on<LoadNewsNotifications>((event, emit) async {
      emit(state.copyWith(isLoadingNews: true));
      await Future.delayed(const Duration(seconds: 1)); // Giả lập API
      final fakeNews = List.generate(
        16,
        (i) => NotificationItem(
          id: i + 1,
          title: "Tin tức mới $i",
          message: "Đây là nội dung thông báo tin tức số $i từ hệ thống.",
          date: DateTime.now().subtract(Duration(days: i)),
          isRead: i % 2 == 0,
        ),
      );
      emit(state.copyWith(newsNotifications: fakeNews, isLoadingNews: false));
    });

    // Load Complain Notifications
    on<LoadComplainNotifications>((event, emit) async {
      emit(state.copyWith(isLoadingComplain: true));
      await Future.delayed(const Duration(seconds: 1)); // Giả lập API
      final fakeComplain = List.generate(
        12,
        (i) => NotificationItem(
          id: 100 + i,
          title: "Khiếu nại #$i",
          message: "Khách hàng đã gửi khiếu nại về dịch vụ số $i.",
          date: DateTime.now().subtract(Duration(hours: i * 5)),
          isRead: false,
        ),
      );
      emit(
        state.copyWith(
          complainNotifications: fakeComplain,
          isLoadingComplain: false,
        ),
      );
    });

    // Mark single as read
    on<MarkAsReadEvent>((event, emit) {
      final updatedNews = state.newsNotifications.map((n) {
        return n.id == event.id ? (n..isRead = true) : n;
      }).toList();
      final updatedComplain = state.complainNotifications.map((n) {
        return n.id == event.id ? (n..isRead = true) : n;
      }).toList();
      emit(
        state.copyWith(
          newsNotifications: updatedNews,
          complainNotifications: updatedComplain,
        ),
      );
      // Giả lập gọi API wsUpdateIsReadCamIDNotificationDetail hoặc tương tự
    });

    // Read All
    on<ReadAllEvent>((event, emit) {
      if (event.isNewsTab) {
        final allRead = state.newsNotifications
            .map((n) => n..isRead = true)
            .toList();
        emit(state.copyWith(newsNotifications: allRead));
      } else {
        final allRead = state.complainNotifications
            .map((n) => n..isRead = true)
            .toList();
        emit(state.copyWith(complainNotifications: allRead));
      }
      // Giả lập gọi API wsReadAllCamIDNotificationDetail hoặc wsReadAllComplainNotificationDetail
    });

    // Clear All (xóa hết)
    on<ClearAllEvent>((event, emit) {
      if (event.isNewsTab) {
        emit(state.copyWith(newsNotifications: []));
        // Giả lập wsClearAllCamIdNotificationDetail
      } else {
        emit(state.copyWith(complainNotifications: []));
        // Giả lập wsClearAllComplainNotificationDetail
      }
    });
  }
}
