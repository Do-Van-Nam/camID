part of 'tier_bloc.dart';

abstract class TierEvent {}

class SelectTierEvent extends TierEvent {
  final TierType tier;
  SelectTierEvent(this.tier);
}
