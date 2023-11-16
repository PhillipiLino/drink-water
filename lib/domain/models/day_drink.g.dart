// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_drink.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DayDrinkAdapter extends TypeAdapter<DayDrink> {
  @override
  final int typeId = 0;

  @override
  DayDrink read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DayDrink(
      fields[0] as String,
      fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, DayDrink obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.drinkedMls);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayDrinkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
