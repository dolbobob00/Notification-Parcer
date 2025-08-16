// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationEntityAdapter extends TypeAdapter<NotificationEntity> {
  @override
  final int typeId = 0;

  @override
  NotificationEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    final rawDate = fields[3];
    DateTime? createAt;

    if (rawDate is int) {
      createAt = DateTime.fromMillisecondsSinceEpoch(rawDate);
    } else if (rawDate is DateTime) {
      createAt = rawDate;
    }

    return NotificationEntity(
      title: fields[0] as String?,
      text: fields[1] as String?,
      packageName: fields[2] as String?,
      createAt: createAt,
      icon: fields[4] as Uint8List?,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationEntity obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.packageName)
      ..writeByte(3)
      ..write(obj.createAt)
      ..writeByte(4)
      ..write(obj.icon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
