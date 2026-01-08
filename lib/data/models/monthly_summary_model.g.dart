// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_summary_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MonthlySummaryAdapter extends TypeAdapter<MonthlySummary> {
  @override
  final int typeId = 2;

  @override
  MonthlySummary read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MonthlySummary(
      yearMonth: fields[0] as String,
      budget: fields[1] as double,
      totalSpent: fields[2] as double,
      savedAmount: fields[3] as double,
      debtAmount: fields[4] as double,
      isLocked: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MonthlySummary obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.yearMonth)
      ..writeByte(1)
      ..write(obj.budget)
      ..writeByte(2)
      ..write(obj.totalSpent)
      ..writeByte(3)
      ..write(obj.savedAmount)
      ..writeByte(4)
      ..write(obj.debtAmount)
      ..writeByte(5)
      ..write(obj.isLocked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonthlySummaryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
