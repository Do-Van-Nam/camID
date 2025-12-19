import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'feedback_bloc.dart';
import 'feedback_event.dart';
import 'feedback_state.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FeedbackBloc(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Phản hồi & Đánh giá')),
        body: BlocConsumer<FeedbackBloc, FeedbackState>(
          listener: (context, state) {
            if (state.submitSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cảm ơn phản hồi của bạn!')),
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
                  const Text(
                    'Bạn đánh giá ứng dụng bao nhiêu sao?',
                    style: TextStyle(fontSize: 18),
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
                    decoration: const InputDecoration(
                      labelText: 'Tiêu đề phản hồi',
                      border: OutlineInputBorder(),
                    ),
                    onChanged:
                        (value) => context.read<FeedbackBloc>().add(
                          TitleChanged(value),
                        ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    maxLines: 6,
                    decoration: const InputDecoration(
                      labelText: 'Nội dung chi tiết',
                      border: OutlineInputBorder(),
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
                              : const Text(
                                'Gửi phản hồi',
                                style: TextStyle(fontSize: 18),
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
                      child: const Text(
                        'Cập nhật ứng dụng',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
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
