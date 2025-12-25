part of 'loyalty_bloc.dart';

abstract class LoyaltyEvent {}

class ChangeCouponIndexEvent extends LoyaltyEvent {
  final int index;
  ChangeCouponIndexEvent(this.index);
}
