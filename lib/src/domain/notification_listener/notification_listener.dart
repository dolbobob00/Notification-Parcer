import 'dart:io';
import 'dart:ui';
import 'dart:isolate';
import 'package:flutter_notification_listener/flutter_notification_listener.dart';
import 'package:notification_handler/src/configuration/dependency_inj/service_locator.dart';
import 'package:notification_handler/src/domain/notification_listener/bloc/notf_handler_bloc.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

@pragma('vm:entry-point')
class ConfiguratorNotificationListener {
  @pragma('vm:entry-point')
  static Future<void> _callback(NotificationEvent evt) async {
    try {
      final send = IsolateNameServer.lookupPortByName("_listener_");
      if (send != null) send.send(evt);
    } catch (e, st) {
      final dir = await path_provider.getApplicationDocumentsDirectory();
      final logFile = File('${dir.path}/notif_listener.log');
      await logFile.writeAsString(
        '${DateTime.now()} — ERROR: $e\n$st\n',
        mode: FileMode.append,
      );
    }
  }

  Future<bool> isStarted() async {
    return await NotificationsListener.isRunning ?? false;
  }

  void onData(NotificationEvent event) {
    final bloc = getIt.get<NotfHandlerBloc>();
    bloc.add(NotfReceive(data: event));
  }

  Future<void> initPlatformState(ReceivePort port) async {
    NotificationsListener.initialize(callbackHandle: _callback);
    IsolateNameServer.removePortNameMapping("_listener_");
    IsolateNameServer.registerPortWithName(port.sendPort, "_listener_");
    port.listen((message) => onData(message));
  }

  Future<bool?> startService({
    bool foreground = true,
    bool showWhen = false,
    String title = 'Notification Listener is running',
    String description = 'Service to track incoming notifications',
  }) async {
    try {
      bool isRunning = await isStarted();
      if (isRunning) return true;
      final bool? started = await NotificationsListener.startService(
        foreground: foreground,
        showWhen: showWhen,
        title: title,
        description: description,
      );
      return started;
    } catch (e) {
      return false;
    }
  }

  Future<void> openPermissionSettings() async {
    await NotificationsListener.openPermissionSettings();
  }

  Future<bool?> endService() async {
    return await NotificationsListener.stopService();
  }

  Future<bool> getIsRunning() async {
    return await NotificationsListener.isRunning ?? false;
  }
}
