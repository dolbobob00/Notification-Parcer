import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notification_handler/src/configuration/dependency_inj/service_locator.dart';
import 'package:notification_handler/src/domain/entities/notification.dart';
import 'package:notification_handler/src/domain/notification_listener/bloc/notf_handler_bloc.dart';

abstract class ILocalDataBase {
  Future<T?> get<T>({required String boxName, String? key});
  Future<void> put<T>({required String boxName, String? key, required T value});
  Future<void> remove({required String boxName, required String? key});
  Future<void> setup({required String path});
  Future<void> getAllValues({required String path});
  Future<void> clear({String? path});
}

class HiveDataBase implements ILocalDataBase {
  @override
  Future<void> setup({required String path}) async {
    // Hive.initFlutter(path);
  }

  @override
  Future<T?> get<T>({required String boxName, String? key}) async {
    final box = await _openBox<T>(boxName);
    return box.get(key);
  }

  @override
  Future<void> put<T>({
    required String boxName,
    String? key,
    required T value,
  }) async {
    final box = await _openBox<T>(boxName);
    box.add(value);
  }

  @override
  Future<void> remove({required String boxName, required String? key}) async {
    final box = await _openBox(boxName);
    await box.delete(key);
  }

  Future<Box<T>> _openBox<T>(String name) async {
    if (!Hive.isBoxOpen(name)) {
      return await Hive.openBox<T>(name);
    }
    return Hive.box<T>(name);
  }

  @override
  Future<void> getAllValues({required String path}) async {
    final box = await _openBox<NotificationEntity>(path);
    final bloc = getIt.get<NotfHandlerBloc>();
    bloc.add(
      NotfLoadedHistory(notfEntities: box.values.toList().reversed.toList()),
    );
  }

  @override
  Future<void> clear({String? path}) async {
    final box = await _openBox<NotificationEntity>(path ?? '');
    await box.clear();
  }
}
