// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_login.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SessionLoginAdapter extends TypeAdapter<SessionLogin> {
  @override
  final int typeId = 1;

  @override
  SessionLogin read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SessionLogin()
      ..userId = fields[0] as String
      ..firstName = fields[1] as String
      ..lastName = fields[2] as String
      ..middleName = fields[3] as String
      ..position = fields[4] as String
      ..moduleId = fields[5] as String
      ..email = fields[6] as String
      ..userName = fields[7] as String
      ..userType = fields[8] as String;
  }

  @override
  void write(BinaryWriter writer, SessionLogin obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.firstName)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.middleName)
      ..writeByte(4)
      ..write(obj.position)
      ..writeByte(5)
      ..write(obj.moduleId)
      ..writeByte(6)
      ..write(obj.email)
      ..writeByte(7)
      ..write(obj.userName)
      ..writeByte(8)
      ..write(obj.userType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionLoginAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
