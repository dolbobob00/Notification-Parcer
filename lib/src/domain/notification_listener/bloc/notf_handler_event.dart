part of 'notf_handler_bloc.dart';

sealed class NotfHandlerEvent extends Equatable {
  const NotfHandlerEvent();

  @override
  List<Object> get props => [];
}

class NotfLoadFromNativeSaved extends NotfHandlerEvent {}

class NotfReceive extends NotfHandlerEvent {
  const NotfReceive({required this.data});
  final NotificationEvent data;
  @override
  List<Object> get props => [data];
}

final class NotfLoadHistory extends NotfHandlerEvent {
  final Completer? completer;
  final String? path;
  const NotfLoadHistory({this.completer, this.path});
}

final class NotfLoadedHistory extends NotfHandlerEvent {
  final List<NotificationEntity> notfEntities;

  const NotfLoadedHistory({required this.notfEntities});
  @override
  List<Object> get props => [notfEntities];
}

final class NotfEnd extends NotfHandlerEvent {}

final class NotfStart extends NotfHandlerEvent {}

class NotfChangeStarted extends NotfHandlerEvent {
  final bool shouldStart;
  const NotfChangeStarted({required this.shouldStart});

  @override
  List<Object> get props => [shouldStart];
}

final class NotfCheckIsStarted extends NotfHandlerEvent {}

final class NotfClearHistory extends NotfHandlerEvent {}
