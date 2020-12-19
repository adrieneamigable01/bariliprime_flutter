import 'package:flutter/material.dart';
import 'package:barili_prime/Pages/authentication.dart';
import 'package:barili_prime/Pages/dashboard.dart';
import 'package:barili_prime/Pages/borrowers.dart';
import 'package:barili_prime/Pages/borrower.dart';
import 'package:barili_prime/Pages/loan.dart';
import 'dart:convert';
void main() {
  runApp(MyApp());
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
      },
    );
  }
}

