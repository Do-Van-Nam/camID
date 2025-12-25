part of 'loyalty_bloc.dart';

class LoyaltyState {
  final int currentCouponIndex;

  LoyaltyState({required this.currentCouponIndex});

  factory LoyaltyState.initial() => LoyaltyState(currentCouponIndex: 0);

  LoyaltyState copyWith({int? currentCouponIndex}) {
    return LoyaltyState(
      currentCouponIndex: currentCouponIndex ?? this.currentCouponIndex,
    );
  }
}