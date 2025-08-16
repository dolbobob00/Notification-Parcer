import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notification_handler/src/app.dart';
import 'package:notification_handler/src/configuration/dependency_inj/service_locator.dart';
import 'package:notification_handler/src/domain/entities/notification.dart';
import 'package:talker_flutter/talker_flutter.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Hive.initFlutter();
    Hive.registerAdapter(NotificationEntityAdapter());

    await ServiceLocator.setupGetIt();

    FlutterError.onError = (error) => getIt.get<Talker>().handle(error);

    runApp(const MainApp());
  }, (error, stack) => getIt.get<Talker>().handle(error, stack));
}
