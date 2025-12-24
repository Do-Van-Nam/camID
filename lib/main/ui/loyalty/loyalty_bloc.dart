import 'package:flutter_bloc/flutter_bloc.dart';

part 'loyalty_event.dart';
part 'loyalty_state.dart';

class LoyaltyBloc extends Bloc<LoyaltyEvent, LoyaltyState> {
  LoyaltyBloc() : super(LoyaltyState.initial()) {
    on<ChangeCouponIndexEvent>((event, emit) {
      emit(state.copyWith(currentCouponIndex: event.index));
    });
  }
}
