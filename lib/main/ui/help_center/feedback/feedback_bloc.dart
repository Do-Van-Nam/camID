import 'dart:async';

import 'package:cam_id/main/data/model/notify/notify_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'feedback_event.dart';
part 'feedback_state.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  Timer? _timer;
  static const int _initialSeconds = 90;
  FeedbackBloc() : super(FeedbackState.initial()) {
    // Load News Notifications
    on<LoadNewsNotifications>((event, emit) async {
      emit(state.copyWith(isLoadingNews: true));
      await Future.delayed(const Duration(seconds: 1)); // Giả lập API
      final fakeNews = List.generate(
        10,
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
      // Giả lập gọi API wsUpdateIsReadCamIDNotification hoặc tương tự
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
      // Giả lập gọi API wsReadAllCamIDNotification hoặc wsReadAllComplainNotification
    });

    // Clear All (xóa hết)
    on<ClearAllEvent>((event, emit) {
      if (event.isNewsTab) {
        emit(state.copyWith(newsNotifications: []));
        // Giả lập wsClearAllCamIdNotification
      } else {
        emit(state.copyWith(complainNotifications: []));
        // Giả lập wsClearAllComplainNotification
      }
    });
    on<PhoneChanged>((event, emit) {
      emit(state.copyWith(phoneNumber: event.phone));
    });
    on<OtpDigitChanged>((event, emit) {
      final digits = List<String>.from(state.digits);
      digits[event.index] = event.digit;
      emit(state.copyWith(digits: digits));
    });

    on<OtpDigitDeleted>((event, emit) {
      final digits = List<String>.from(state.digits);
      if (event.index >= 0 && event.index < 6) digits[event.index] = '';
      emit(state.copyWith(digits: digits));
    });

    on<OtpPaste>((event, emit) {
      final pasted = event.text.replaceAll(RegExp(r'\D'), '').split('');
      if (pasted.length == 6) {
        emit(state.copyWith(digits: pasted));
      }
    });

    on<OtpClear>((event, emit) {
      emit(state.copyWith(digits: List.filled(6, '')));
    });

    // Thêm event cho timer
    on<StartTimer>((event, emit) {
      _startTimer(emit);
    });

    on<TickTimer>((event, emit) {
      if (event.seconds > 0) {
        emit(state.copyWith(remainingSeconds: event.seconds - 1));
      } else {
        emit(state.copyWith(remainingSeconds: 0, isResendEnabled: true));
        _timer?.cancel();
      }
    });

    on<ResendOtp>((event, emit) {
      emit(
        state.copyWith(
          digits: List.filled(6, ''),
          remainingSeconds: _initialSeconds,
          isResendEnabled: false,
        ),
      );
      _startTimer(emit);
      // Ở đây bạn sẽ gọi API resend OTP thật
    });
    on<ChangeAcc>((event, emit) {
      emit(state.copyWith(isInitial: true, phoneNumber: ""));
    });
    on<SendOtp>((event, emit) {
      emit(
        state.copyWith(
          isSentOTP: true,
          isInitial: false,
          digits: List.filled(6, ''),
          remainingSeconds: _initialSeconds,
          isResendEnabled: false,
        ),
      );
      _startTimer(emit);
      // Ở đây bạn sẽ gọi API resend OTP thật
    });
    // gui otp di
    on<SubmitOtp>((event, emit) {
      emit(
        state.copyWith(
          isSentOTP: false,
          digits: List.filled(6, ''),
          remainingSeconds: _initialSeconds,
          isResendEnabled: false,
        ),
      );
      add(LoadNewsNotifications());
      // gọi API submit OTP thật
    });
    // Tự động bắt đầu timer khi khởi tạo
    // add(StartTimer());
  }

  void _startTimer(Emitter<FeedbackState> emit) {
    _timer?.cancel();
    emit(
      state.copyWith(remainingSeconds: _initialSeconds, isResendEnabled: false),
    );
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(TickTimer(_initialSeconds - timer.tick));
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  bool get isComplete => state.digits.every((d) => d.isNotEmpty);
  String get otpCode => state.digits.join();
}
