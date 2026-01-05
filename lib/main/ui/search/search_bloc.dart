import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final List<String> allItems = [
    'Apple',
    'Banana',
    'Cherry',
    'Date',
    'Elderberry',
    'Fig',
    'Grape',
    'Honeydew',
    'Kiwi',
    'Lemon',
    'Mango',
    'Orange',
    'Papaya',
    'Quince',
    'Raspberry',
  ];

  SearchBloc() : super(SearchInitial()) {
    on<SearchTextChanged>((event, emit) {
      final query = event.query.toLowerCase().trim();

      if (query.isEmpty) {
        emit(SearchInitial());
        return;
      }

      final filtered = allItems
          .where((item) => item.toLowerCase().contains(query))
          .toList();

      emit(SearchLoaded(filtered));
    });
  }
}
