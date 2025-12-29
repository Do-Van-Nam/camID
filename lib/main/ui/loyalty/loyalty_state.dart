// loyalty_state.dart
part of 'loyalty_bloc.dart';

class LoyaltyState {
  final bool isLoading;
  final int points;
  final int nextTierPoints;
  final String tierName;
  final List<RewardCoupon> coupons;

  LoyaltyState({
    required this.isLoading,
    required this.points,
    required this.nextTierPoints,
    required this.tierName,
    required this.coupons,
  });

  factory LoyaltyState.initial() => LoyaltyState(
    isLoading: true,
    points: 0,
    nextTierPoints: 0,
    tierName: "",
    coupons: [],
  );

  LoyaltyState copyWith({
    bool? isLoading,
    int? points,
    int? nextTierPoints,
    String? tierName,
    List<RewardCoupon>? coupons,
  }) {
    return LoyaltyState(
      isLoading: isLoading ?? this.isLoading,
      points: points ?? this.points,
      nextTierPoints: nextTierPoints ?? this.nextTierPoints,
      tierName: tierName ?? this.tierName,
      coupons: coupons ?? this.coupons,
    );
  }
}
