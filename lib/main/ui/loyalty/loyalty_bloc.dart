import 'package:cam_id/main/data/model/reward_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'loyalty_event.dart';
part 'loyalty_state.dart';

class LoyaltyBloc extends Bloc<LoyaltyEvent, LoyaltyState> {
  LoyaltyBloc() : super(LoyaltyState.initial()) {
    on<LoadLoyaltyData>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      // Giả lập dữ liệu
      await Future.delayed(const Duration(seconds: 1));

      final coupons = [
        RewardCoupon(
          title: "Voucher Loyalty Food",
          imageUrl:
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSYF6gfCVV13NoMGylzHt5mA_1qTdWgiF7huQ&s",
          points: 300,
          exchanged: 100,
          total: 1000,
        ),
        RewardCoupon(
          title: "Voucher Loyalty Food",
          imageUrl:
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSYF6gfCVV13NoMGylzHt5mA_1qTdWgiF7huQ&s",
          points: 300,
          exchanged: 100,
          total: 1000,
        ),
        RewardCoupon(
          title: "Voucher Loyalty Food",
          imageUrl:
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSYF6gfCVV13NoMGylzHt5mA_1qTdWgiF7huQ&s",
          points: 300,
          exchanged: 100,
          total: 1000,
        ),
        RewardCoupon(
          title: "Voucher Loyalty Food",
          imageUrl:
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSYF6gfCVV13NoMGylzHt5mA_1qTdWgiF7huQ&s",
          points: 300,
          exchanged: 100,
          total: 1000,
        ),
        RewardCoupon(
          title: "Voucher Loyalty Food",
          imageUrl:
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSYF6gfCVV13NoMGylzHt5mA_1qTdWgiF7huQ&s",
          points: 300,
          exchanged: 100,
          total: 1000,
        ),
        RewardCoupon(
          title: "Voucher Loyalty Food",
          imageUrl:
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSYF6gfCVV13NoMGylzHt5mA_1qTdWgiF7huQ&s",
          points: 300,
          exchanged: 100,
          total: 1000,
        ),
        RewardCoupon(
          title: "Voucher Loyalty Food",
          imageUrl:
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSYF6gfCVV13NoMGylzHt5mA_1qTdWgiF7huQ&s",
          points: 300,
          exchanged: 100,
          total: 1000,
        ),
      ];

      emit(
        state.copyWith(
          isLoading: false,
          points: 999,
          nextTierPoints: 100,
          tierName: "Bronze",
          coupons: coupons,
        ),
      );
    });
  }
}
