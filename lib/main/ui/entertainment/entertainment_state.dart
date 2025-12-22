part of 'entertainment_bloc.dart';

class EntertainmentState {
  final int currentBannerIndex;

  EntertainmentState({required this.currentBannerIndex});

  factory EntertainmentState.initial() {
    return EntertainmentState(currentBannerIndex: 0);
  }

  EntertainmentState copyWith({int? currentBannerIndex}) {
    return EntertainmentState(
      currentBannerIndex: currentBannerIndex ?? this.currentBannerIndex,
    );
  }
}
