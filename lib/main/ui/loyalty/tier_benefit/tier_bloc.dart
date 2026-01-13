import 'package:flutter_bloc/flutter_bloc.dart';

part 'tier_event.dart';
part 'tier_state.dart';

class TierBloc extends Bloc<TierEvent, TierState> {
  TierBloc() : super(TierState.initial()) {
    on<SelectTierEvent>((event, emit) {
      emit(state.copyWith(selectedTier: event.tier));
    });
  }
}
