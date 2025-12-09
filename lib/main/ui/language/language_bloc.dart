import 'dart:ui';

import 'package:cam_id/main/data/share_preference/share_preference.dart';
import 'package:cam_id/main/ui/language/language_event.dart';
import 'package:cam_id/main/ui/language/languge_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState>{

  LanguageBloc(): super(const LanguageState(Locale('en','US'))){
    on<ChangeLanguageEvent>(_onChangeLanguage);
    on<LoadLanguageEvent>(_onLoadLanguage);
  }

  void _onChangeLanguage(ChangeLanguageEvent event, Emitter<LanguageState> emit) async {
    SharePreferenceUtil.saveLanguage(event.locale.languageCode);
    emit(LanguageState(event.locale));
  }

  void _onLoadLanguage(LoadLanguageEvent event, Emitter<LanguageState> emit) async {
    Locale locale = Locale(await SharePreferenceUtil.getLanguageCode());
    emit(LanguageState(locale));
  }

}