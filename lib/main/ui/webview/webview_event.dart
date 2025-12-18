import 'package:equatable/equatable.dart';

abstract class WebviewEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUrl extends WebviewEvent {
  final String url;
  LoadUrl(this.url);
  @override
  List<Object?> get props => [url];
}

class ReloadPage extends WebviewEvent {}

class GoBack extends WebviewEvent {}

class GoForward extends WebviewEvent {}

class CloseWebview extends WebviewEvent {}
