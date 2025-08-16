import 'dart:isolate';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:notification_handler/src/repository/local_db/local_db.dart';
import 'package:notification_handler/src/domain/icon_service/app_icon_sevice.dart';
import 'package:notification_handler/src/domain/notification_listener/bloc/notf_handler_bloc.dart';
import 'package:notification_handler/src/domain/notification_listener/notification_listener.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

final GetIt getIt = GetIt.I;

class ServiceLocator {
  static Future<void> setupGetIt() async {
    _setupLogger();
    _setupDb();
    await _setupNotificationReceiver();
    await _setupNotfBloc();
    _setupIconGetterService();
  }

  static void _setupIconGetterService() {
    if (!getIt.isRegistered<AppIconService>()) {
      final AppIconService appIconService = AppIconService();
      getIt.registerSingleton<AppIconService>(appIconService);
    }
  }

  static void _setupDb() {
    if (!getIt.isRegistered<ILocalDataBase>()) {
      final ILocalDataBase db = HiveDataBase();
      getIt.registerSingleton<ILocalDataBase>(db);
    }
  }

  static Future<void> _setupNotificationReceiver() async {
    ReceivePort port = ReceivePort();
    getIt.registerSingleton<ReceivePort>(port);
    if (!getIt.isRegistered<ConfiguratorNotificationListener>()) {
      final config = ConfiguratorNotificationListener();
      await config.initPlatformState(port);
      getIt.registerSingleton<ConfiguratorNotificationListener>(config);
    
    }
  }

  static Future<void> _setupNotfBloc() async {
    if (!getIt.isRegistered<NotfHandlerBloc>()) {
      // Registring bloc for ui changes outside context (check configurator onData method)
      NotfHandlerBloc bloc = NotfHandlerBloc(
        talker: getIt.get<Talker>(),
        db: getIt.get<ILocalDataBase>(),
        notificationsListener: getIt.get<ConfiguratorNotificationListener>(),
      );
      getIt.registerSingleton<NotfHandlerBloc>(bloc);
    }
  }

  static void _setupLogger() {
    if (!getIt.isRegistered<Talker>()) {
      final talker = TalkerFlutter.init();

      Bloc.observer = TalkerBlocObserver(
        talker: talker,
        settings: TalkerBlocLoggerSettings(printStateFullData: false),
      );

      getIt.registerSingleton<Talker>(talker);
    }
  }
}
