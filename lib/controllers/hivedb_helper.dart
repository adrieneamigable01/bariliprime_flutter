import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:barili_prime/helpers/session_login.dart';
import 'package:barili_prime/helpers/borrowerinfo.dart';

class HiveDBHelper{

  Future initHelper() async {

    if (kIsWeb) {
      await Hive.initFlutter();
    } else {
      final appDocumentDir = await pathProvider.getApplicationDocumentsDirectory();
      Hive.init(appDocumentDir.path);
    }

    Hive.registerAdapter(Adapters.sessionLoginAdapter);
    Hive.registerAdapter(Adapters.borrowerInfoAdapter);

    await Hive.openBox(Boxes.signInSessionList);
    await Hive.openBox(Boxes.borrowerInfoList);
  }

  ///Initializes the box and register its corresponding adapter.
  ///
  ///An optional method to open and register a single box and adapter.
  Future openAndRegisterBox(adapter, box) async {
    final appDocumentDir = await pathProvider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    Hive.registerAdapter(adapter);
    await Hive.openBox(box);
  }

  ///Closes all the boxes used in the app, may be called during app close.
  closeBoxes() {
    Hive.close();
  }

  Future truncateBoxes() async {
    await Hive.deleteFromDisk();
  }

}

///Static box list.
///
/// All box names must be declared here, box name and box variable must be the same.
class Boxes {
  static final String signInSessionList = 'signInSessionList';
  static final String borrowerInfoList  = 'borrowerInfoList';
}

///All adapters name must declare here
class Adapters {
  static final SessionLoginAdapter sessionLoginAdapter = SessionLoginAdapter();
  static final BorrowerInfoAdapter borrowerInfoAdapter = BorrowerInfoAdapter();
}
