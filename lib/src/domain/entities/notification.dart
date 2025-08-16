import 'dart:typed_data';

import 'package:hive_flutter/hive_flutter.dart';
part 'notification.g.dart';

@HiveType(typeId: 0)
class NotificationEntity extends HiveObject {
  @HiveField(0)
  final String? title;

  @HiveField(1)
  final String? text;

  @HiveField(2)
  final String? packageName;

  @HiveField(3)
  final DateTime? createAt;

  @HiveField(4)
  final Uint8List? icon;

  NotificationEntity({
    this.title,
    this.text,
    this.packageName,
    this.createAt,
    this.icon,
  });
}
