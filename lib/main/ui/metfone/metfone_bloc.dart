import 'package:cam_id/main/ui/metfone/metfone_event.dart';
import 'package:cam_id/main/ui/metfone/metfone_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MetfoneBloc extends Bloc<MetfoneEvent, MetfoneState> {
  MetfoneBloc() : super(MetfoneState.initial()) {
    on<BannerHeaderChanged>(_onBannerHeaderChanged);
    on<BannerFooterChanged>(_onBannerFooterChanged);
  }

  void _onBannerHeaderChanged(
      BannerHeaderChanged event,
      Emitter<MetfoneState> emit,
      ) {
    emit(state.copyWith(bannerHeaderIndex: event.index));
  }

  void _onBannerFooterChanged(
      BannerFooterChanged event,
      Emitter<MetfoneState> emit,
      ) {
    emit(state.copyWith(bannerFooterIndex: event.index));
  }

}
