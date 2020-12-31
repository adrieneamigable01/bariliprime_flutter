// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'borrowerinfo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BorrowerInfoAdapter extends TypeAdapter<BorrowerInfo> {
  @override
  final int typeId = 0;

  @override
  BorrowerInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BorrowerInfo()
      ..borrowerId = fields[0] as String
      ..firstName = fields[1] as String
      ..lastName = fields[2] as String
      ..middleName = fields[3] as String
      ..fullName = fields[4] as String
      ..image = fields[5] as String
      ..gender = fields[6] as String
      ..mobile = fields[7] as String
      ..present_address = fields[8] as String
      ..position = fields[9] as String
      ..net = fields[10] as String
      ..district = fields[11] as String
      ..totalBalance = fields[12] as String;
  }

  @override
  void write(BinaryWriter writer, BorrowerInfo obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.borrowerId)
      ..writeByte(1)
      ..write(obj.firstName)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.middleName)
      ..writeByte(4)
      ..write(obj.fullName)
      ..writeByte(5)
      ..write(obj.image)
      ..writeByte(6)
      ..write(obj.gender)
      ..writeByte(7)
      ..write(obj.mobile)
      ..writeByte(8)
      ..write(obj.present_address)
      ..writeByte(9)
      ..write(obj.position)
      ..writeByte(10)
      ..write(obj.net)
      ..writeByte(11)
      ..write(obj.district)
      ..writeByte(12)
      ..write(obj.totalBalance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BorrowerInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
