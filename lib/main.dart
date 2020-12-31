import 'package:flutter/material.dart';
import 'package:barili_prime/views/authentication.dart';
import 'package:barili_prime/views/dashboard.dart';
import 'package:barili_prime/views/borrowers.dart';
import 'package:barili_prime/views/borrower.dart';
import 'package:barili_prime/views/loan.dart';
import 'package:barili_prime/views/added-capital.dart';
import 'package:barili_prime/views/cashier.dart';
import 'package:barili_prime/controllers/hivedb_helper.dart';

void main() async {

  runApp(MyApp());
  HiveDBHelper hiveDBHelper = HiveDBHelper();
  await hiveDBHelper.initHelper();

}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/':(context) => AuthenticationPage(),
        'dashboard': (context) => DashboardPage(),
        'borrowers': (context) => BorrowersPage(),
        'borrower': (context) => BorrowerPage(),
        'loan': (context) => LoanPage(),
        'capital': (context) => CapitalPage(),
        'cashier': (context) => CashierPage(),
      },
    );
  }
}

