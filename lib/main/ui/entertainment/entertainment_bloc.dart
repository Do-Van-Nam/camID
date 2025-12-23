import 'package:flutter_bloc/flutter_bloc.dart';

part 'entertainment_event.dart';
part 'entertainment_state.dart';

class EntertainmentBloc extends Bloc<EntertainmentEvent, EntertainmentState> {
  EntertainmentBloc() : super(EntertainmentState.initial()) {
    on<ChangeBannerEvent>((event, emit) {
      emit(state.copyWith(currentBannerIndex: event.index));
    });
  }
}
