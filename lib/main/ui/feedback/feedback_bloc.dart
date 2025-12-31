import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'feedback_event.dart';
import 'feedback_state.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  FeedbackBloc() : super(const FeedbackState()) {
    on<RatingChanged>((event, emit) {
      emit(state.copyWith(rating: event.rating));
    });
    on<RateChanged>((event, emit) {
      emit(
        state.copyWith(
          speedRate: event.type == 'speed' ? event.rating : state.speedRate,
          priceRate: event.type == 'price' ? event.rating : state.priceRate,
          customerServiceRate: event.type == 'customerService'
              ? event.rating
              : state.customerServiceRate,
          technicalRate: event.type == 'technical'
              ? event.rating
              : state.technicalRate,
        ),
      );
    });
    on<SatisficationLevelChanged>((event, emit) {
      emit(state.copyWith(satisLv: event.satisLv));
    });
    on<TitleChanged>((event, emit) {
      emit(state.copyWith(title: event.title));
    });

    on<ContentChanged>((event, emit) {
      emit(state.copyWith(content: event.content));
    });

    on<SubmitFeedback>((event, emit) async {
      if (state.rating == 0) {
        emit(state.copyWith(errorMessage: 'Vui lòng chọn số sao đánh giá'));
        return;
      }
      emit(state.copyWith(isSubmitting: true, errorMessage: null));

      // Giả lập gửi phản hồi (thay bằng API thật nếu có)
      await Future.delayed(const Duration(seconds: 2));

      // Thành công
      emit(state.copyWith(isSubmitting: false, submitSuccess: true));

      // Reset sau 3 giây
      await Future.delayed(const Duration(seconds: 3));
      emit(const FeedbackState());
    });

    on<OpenUpdateApp>((event, emit) async {
      // Thay bằng link app của bạn (Google Play hoặc App Store)
      final url = Uri.parse(
        'https://play.google.com/store/apps/details?id=com.example.yourapp',
      );
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    });
  }
}
