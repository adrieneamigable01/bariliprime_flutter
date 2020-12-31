import 'package:hive/hive.dart';
import 'package:barili_prime/controllers/hivedb_helper.dart';
part 'session_login.g.dart';

@HiveType(typeId : 1)
class SessionLogin {
  @HiveField(0)
  String userId;
  @HiveField(1)
  String firstName;
  @HiveField(2)
  String lastName;
  @HiveField(3)
  String middleName;
  @HiveField(4)
  String position;
  @HiveField(5)
  String moduleId;
  @HiveField(6)
  String email;
  @HiveField(7)
  String userName;
  @HiveField(8)
  String userType;
}

class SessionList{

  Box get sessionBox {
    final sessionListBox = Hive.box(Boxes.signInSessionList);
    return sessionListBox;
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

  void putSessionBox(SessionLogin session)  {
    sessionBox.put(session.userId,session);
  }

  List<SessionLogin> getSessionData() {
    return sessionBox.values.cast<SessionLogin>().toList();
  }
}