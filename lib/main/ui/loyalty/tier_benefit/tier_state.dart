part of 'tier_bloc.dart';

enum TierType { bronze, silver, gold, diamond }

class TierState {
  final TierType selectedTier;
  final TierType currentTier; // Current user's tier
  final int currentPoints;
  final int usedPoints;
  final int pointsNeeded; // Points needed for next tier
  final String userName;

  TierState({
    required this.selectedTier,
    required this.currentTier,
    required this.currentPoints,
    required this.usedPoints,
    required this.pointsNeeded,
    required this.userName,
  });

  factory TierState.initial() => TierState(
    selectedTier: TierType.bronze,
    currentTier: TierType.bronze,
    currentPoints: 910,
    usedPoints: 6,
    pointsNeeded: 1500,
    userName: "Chan chan",
  );

  TierState copyWith({
    TierType? selectedTier,
    TierType? currentTier,
    int? currentPoints,
    int? usedPoints,
    int? pointsNeeded,
    String? userName,
  }) {
    return TierState(
      selectedTier: selectedTier ?? this.selectedTier,
      currentTier: currentTier ?? this.currentTier,
      currentPoints: currentPoints ?? this.currentPoints,
      usedPoints: usedPoints ?? this.usedPoints,
      pointsNeeded: pointsNeeded ?? this.pointsNeeded,
      userName: userName ?? this.userName,
    );
  }
}
