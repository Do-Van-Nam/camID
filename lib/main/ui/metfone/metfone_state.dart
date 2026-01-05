import 'package:equatable/equatable.dart';

class MetfoneState extends Equatable {
  // final bool isLoggedIn;
  final int bannerHeaderIndex;
  final int bannerFooterIndex;

  const MetfoneState({
    required this.bannerHeaderIndex,
    required this.bannerFooterIndex,
  });

  factory MetfoneState.initial() {
    return MetfoneState(
      bannerHeaderIndex: 0,
      bannerFooterIndex: 0
    );
  }

  MetfoneState copyWith({
    int? bannerHeaderIndex,
    int? bannerFooterIndex,
  }) {
    return MetfoneState(
      bannerHeaderIndex: bannerHeaderIndex ?? this.bannerHeaderIndex,
      bannerFooterIndex: bannerFooterIndex ?? this.bannerFooterIndex,
    );
  }

  @override
  List<Object?> get props => [bannerHeaderIndex, bannerHeaderIndex];
}
