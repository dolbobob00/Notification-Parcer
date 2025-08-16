import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_notification_listener/flutter_notification_listener.dart';
import 'package:notification_handler/src/configuration/dependency_inj/service_locator.dart';
import 'package:notification_handler/src/repository/local_db/local_db.dart';
import 'package:notification_handler/src/domain/entities/notification.dart';
import 'package:notification_handler/src/domain/notification_listener/notification_listener.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'notf_handler_event.dart';
part 'notf_handler_state.dart';

class NotfHandlerBloc extends Bloc<NotfHandlerEvent, NotfHandlerState> {
  final Talker talker;
  final ConfiguratorNotificationListener notificationsListener;
  final ILocalDataBase db;

  final boxPath = 'notifications';

  NotfHandlerBloc({
    required this.talker,
    required this.notificationsListener,
    required this.db,
  }) : super(NotfHandlerInitial()) {
    on<NotfChangeStarted>((event, emit) {
      if (event.shouldStart == false) {
        add(NotfEnd());
      } else {
        add(NotfStart());
      }
    });
    on<NotfStart>((event, emit) async {
      try {
        var hasPermission =
            (await NotificationsListener.hasPermission) ?? false;
        if (!hasPermission) {
          emit(NotfError(error: 'Provide permissions for using notifications'));
          await notificationsListener.openPermissionSettings();
          return;
        }

        final bool isR = await notificationsListener.isStarted();
        if (isR == false) {
          bool success = (await notificationsListener.startService() ?? false);
          if (success == true) {
            add(NotfLoadHistory());
          } else {
            emit(NotfError(error: 'Some error with canceling idk wth'));
          }
        } else {
          add(NotfLoadHistory());
          return;
        }
      } catch (e) {
        emit(NotfError(error: e.toString()));
        talker.error(e);
      }
    });
    on<NotfEnd>((event, emit) async {
      emit(NotfLoading());
      try {
        final bool? success = await notificationsListener.endService();
        if (success == true) {
          emit(NotfError(error: 'Well. Service is offed.'));
        } else {
          emit(NotfError(error: 'Some error with canceling idk wth'));
        }
      } catch (e) {
        emit(NotfError(error: e.toString()));
        talker.error(e);
      }
    });
    // Can be used in flutter manually (ui upd)
    on<NotfLoadHistory>((event, emit) async {
      emit(NotfLoading());
      try {
        await db.getAllValues(path: event.path ?? boxPath);
        event.completer?.complete();
      } catch (e) {
        emit(NotfError(error: e.toString()));
        talker.error(e);
      }
    });
    on<NotfClearHistory>((event, emit) async {
      await db.clear();
      emit(NotfError(error: 'Waiting for notifications'));
    });

    // For receiving, dont use in flutter manually, its used in notf_listener
    on<NotfReceive>((event, emit) async {
      final data = event.data;
      getIt.get<Talker>().debug(data);
      // if (data.title == null && data.text == null) return;
      final entity = NotificationEntity(
        packageName: data.packageName,
        text: data.text,
        icon: data.largeIcon,
        createAt: data.createAt,
        title: data.title,
      );
      await db.put<NotificationEntity>(boxName: boxPath, value: entity);
      try {
        getIt.get<NotfHandlerBloc>().add(NotfLoadHistory());
      } catch (e) {
        emit(NotfError(error: 'Error with uploading from receiver.'));
      }

      talker.debug(entity);
    });

    // Changer for notf_listener. Dont use manually
    on<NotfLoadedHistory>((event, emit) {
      try {
        emit(NotfLoaded(notifications: event.notfEntities));
      } catch (e) {
        emit(NotfError(error: e.toString()));
      }
    });
  }
}
