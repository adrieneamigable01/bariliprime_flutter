import 'package:hive/hive.dart';
import 'package:barili_prime/controllers/hivedb_helper.dart';
part 'borrowerinfo.g.dart';

@HiveType(typeId : 0)
class BorrowerInfo {
  @HiveField(0)
  String borrowerId;
  @HiveField(1)
  String firstName;
  @HiveField(2)
  String lastName;
  @HiveField(3)
  String middleName;
  @HiveField(4)
  String fullName;
  @HiveField(5)
  String image;
  @HiveField(6)
  String gender;
  @HiveField(7)
  String mobile;
  @HiveField(8)
  String present_address;
  @HiveField(9)
  String position;
  @HiveField(10)
  String net;
  @HiveField(11)
  String district;
  @HiveField(12)
  String totalBalance;

}

class BorrowerList{

  Box get sessionBox {
    final borrowerInfoBox = Hive.box(Boxes.borrowerInfoList);
    return borrowerInfoBox;
  }

  void clearSessionBox({key,value}) async {
    sessionBox.put(key, value);
  }

  dynamic getSingleBox(key) {
    String name = sessionBox.get(key);
    return name;
  }

  Future<void> putSingleBox({key,value}) async {
    sessionBox.put(key,value);
  }

  void putSessionBox(BorrowerInfo borrowerInfo)  {
    sessionBox.put(borrowerInfo.borrowerId,borrowerInfo);
  }

  List<BorrowerInfo> getSessionData() {
    return sessionBox.values.cast<BorrowerInfo>().toList();
  }
}