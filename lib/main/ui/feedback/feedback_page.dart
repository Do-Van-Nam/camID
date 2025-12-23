import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cam_id/generated/app_localizations.dart';

import 'feedback_bloc.dart';
import 'feedback_event.dart';
import 'feedback_state.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy AppLocalizations
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => FeedbackBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.feedbackPageTitle),
        ), // "Phản hồi & Đánh giá"
        body: BlocConsumer<FeedbackBloc, FeedbackState>(
          listener: (context, state) {
            if (state.submitSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.feedbackThankYou),
                ), // "Cảm ơn phản hồi của bạn!"
              );
            }
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.feedbackRatingQuestion, // "Bạn đánh giá ứng dụng bao nhiêu sao?"
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: RatingBar.builder(
                      initialRating: state.rating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemSize: 50,
                      itemBuilder:
                          (context, _) =>
                              const Icon(Icons.star, color: Colors.amber),
                      onRatingUpdate: (rating) {
                        context.read<FeedbackBloc>().add(RatingChanged(rating));
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    decoration: InputDecoration(
                      labelText: l10n.feedbackTitleLabel, // "Tiêu đề phản hồi"
                      border: const OutlineInputBorder(),
                    ),
                    onChanged:
                        (value) => context.read<FeedbackBloc>().add(
                          TitleChanged(value),
                        ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    maxLines: 6,
                    decoration: InputDecoration(
                      labelText:
                          l10n.feedbackContentLabel, // "Nội dung chi tiết"
                      border: const OutlineInputBorder(),
                    ),
                    onChanged:
                        (value) => context.read<FeedbackBloc>().add(
                          ContentChanged(value),
                        ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed:
                          state.isSubmitting
                              ? null
                              : () {
                                context.read<FeedbackBloc>().add(
                                  SubmitFeedback(),
                                );
                              },
                      child:
                          state.isSubmitting
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : Text(
                                l10n.feedbackSubmitButton, // "Gửi phản hồi"
                                style: const TextStyle(fontSize: 18),
                              ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        context.read<FeedbackBloc>().add(OpenUpdateApp());
                      },
                      child: Text(
                        l10n.feedbackUpdateAppButton, // "Cập nhật ứng dụng"
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      // Code KYC giữ nguyên
                    },
                    child: Text(l10n.feedbackStartKycButton), // "Bắt đầu KYC"
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
