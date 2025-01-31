// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todoapp_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodoAppModelAdapter extends TypeAdapter<TodoAppModel> {
  @override
  final int typeId = 0;

  @override
  TodoAppModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TodoAppModel(
      title: fields[0] as String,
      description: fields[1] as String,
      isCompelete: fields[2] as bool,
      createdAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TodoAppModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.isCompelete)
      ..writeByte(3)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoAppModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
