part of 'notf_handler_bloc.dart';

sealed class NotfHandlerState extends Equatable {
  const NotfHandlerState();

  @override
  List<Object> get props => [];
}

final class NotfHandlerInitial extends NotfHandlerState {}

final class NotfLoading extends NotfHandlerState {}


class NotfLoaded extends NotfHandlerState {
  final List<NotificationEntity> notifications;

  const NotfLoaded({required this.notifications});
  @override
  List<Object> get props => [notifications];
}

class NotfError extends NotfHandlerState {
  final String error;
  const NotfError({required this.error});
  @override
  List<Object> get props => [error];
}
