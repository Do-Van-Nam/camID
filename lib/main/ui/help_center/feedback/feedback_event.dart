// notification_event.dart
part of 'feedback_bloc.dart';

abstract class FeedbackEvent {}

class LoadNewsNotifications extends FeedbackEvent {}

class LoadComplainNotifications extends FeedbackEvent {}

class MarkAsReadEvent extends FeedbackEvent {
  final int id;
  MarkAsReadEvent(this.id);
}

class ReadAllEvent extends FeedbackEvent {
  final bool isNewsTab;
  ReadAllEvent(this.isNewsTab);
}

class ClearAllEvent extends FeedbackEvent {
  final bool isNewsTab;
  ClearAllEvent(this.isNewsTab);
}

class OtpDigitChanged extends FeedbackEvent {
  final int index;
  final String digit;
  OtpDigitChanged(this.index, this.digit);
}

class OtpDigitDeleted extends FeedbackEvent {
  final int index;
  OtpDigitDeleted(this.index);
}

class OtpPaste extends FeedbackEvent {
  final String text;
  OtpPaste(this.text);
}

class OtpClear extends FeedbackEvent {} // giữ nguyên

class StartTimer extends FeedbackEvent {}

class TickTimer extends FeedbackEvent {
  final int seconds;
  TickTimer(this.seconds);
}

class ResendOtp extends FeedbackEvent {}

class SendOtp extends FeedbackEvent {}

class ChangeAcc extends FeedbackEvent {}

class SubmitOtp extends FeedbackEvent {}

class PhoneChanged extends FeedbackEvent {
  final String phone;
  PhoneChanged(this.phone);
}

class FilterServiceTypeChanged extends FeedbackEvent {
  final String type;
  FilterServiceTypeChanged(this.type);
}

class DateFilterChanged extends FeedbackEvent {
  final DateTime date;
  final String type;
  DateFilterChanged(this.date, this.type);
}
