// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppSettingsAdapter extends TypeAdapter<AppSettings> {
  @override
  final int typeId = 1;

  @override
  AppSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSettings(
      monthlyLimit: fields[0] as double,
      monthStartDay: fields[1] as int,
      currentSavings: fields[2] as double,
      currentDebt: fields[3] as double,
      lastOpenedMonth: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AppSettings obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.monthlyLimit)
      ..writeByte(1)
      ..write(obj.monthStartDay)
      ..writeByte(2)
      ..write(obj.currentSavings)
      ..writeByte(3)
      ..write(obj.currentDebt)
      ..writeByte(4)
      ..write(obj.lastOpenedMonth);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
