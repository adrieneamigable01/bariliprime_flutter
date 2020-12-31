import 'package:barili_prime/constant/style.dart';
import 'package:flutter/material.dart';
import 'package:barili_prime/mywidgets/tile_card.dart';
import 'package:barili_prime/helpers/session_login.dart';
import 'package:barili_prime/mywidgets/default_drawer.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:barili_prime/controllers/http_borrower.dart';
import 'package:barili_prime/controllers/http_loan.dart';
import 'package:barili_prime/controllers/http_capital.dart';
import 'package:barili_prime/mywidgets/navigation_bar.dart';

SessionList _sessionLogin = SessionList();
var httpBorrower = HttpBorrower();
var httpLoan     = HttpLoan();
var httpCapital  = HttpCapital();

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}



class _DashboardPageState extends State<DashboardPage> {



  String firstName          = _sessionLogin.getSingleBox("firstName");
  String lastName           = _sessionLogin.getSingleBox("lastName");
  String position           = _sessionLogin.getSingleBox("position");
  String totalBorrower      = "0";
  String totalPendingLoan   = "0";
  String totalToReleaseLoan = "0";
  String totalPendingCapital = "0";
  String totalToReleaseCapital = "0";




  getOverAllBorrower({payload}) async {
    var response =  await httpBorrower.getTotalBorrower(payload: payload);
    if(response['isError'] == false){
      setState(() {
        totalBorrower  = response['data'];
      });
    }
  }

  getTotalPendingLoan({payload}) async {
    var response = await httpLoan.getTotalLoan(payload:payload);
    if(response['isError'] == false){
      setState(() {
        totalPendingLoan  = response['data'];
      });
    }
  }

  getToReleaseLoan({payload}) async {
    var response = await httpLoan.getTotalLoan(payload:payload);
    if(response['isError'] == false){
      setState(() {
        totalToReleaseLoan  = response['data'];
      });
    }
  }

  getPendingCapital({payload}) async {
    var response = await httpCapital.getTotalCapital(payload:payload);
    if(response['isError'] == false){
      setState(() {
        totalPendingCapital  = response['data'];
      });
    }
  }

  getToReleaseCapital({payload}) async {
    var response = await httpCapital.getTotalCapital(payload:payload);
    if(response['isError'] == false){
      setState(() {
        totalToReleaseCapital  = response['data'];
      });
    }
  }


  @override
  void initState() {
    setState(() {
       //get total borrowers
       String activeBorrowerPayload = '?is_active=1';
       getOverAllBorrower(payload: activeBorrowerPayload);


       //get total pending loan
       String pendingLoanPayload = '?is_active=1&status_id=2';
       getTotalPendingLoan(payload: pendingLoanPayload);

       //get total pending loan
       String toReleaseLoanPayload = '?is_active=1&status_id=2&is_release=0';
       getToReleaseLoan(payload: toReleaseLoanPayload);

       //get pending capital
       String pendingCapitalPayload = '?is_active=1&status_id=2&is_release=0';
       getPendingCapital(payload: pendingCapitalPayload);

       //get pending capital
       String toReleaseCapitalPayload = '?is_active=1&status_id=1&is_release=0';
       getToReleaseCapital(payload: toReleaseCapitalPayload);


    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return ResponsiveBuilder(
        builder: (context,sizingInformation){
          if(sizingInformation.deviceScreenType == DeviceScreenType.tablet){

          }
          if(sizingInformation.deviceScreenType == DeviceScreenType.mobile){
            return SafeArea(
                child: Scaffold(
                  appBar: AppBar(
                    leading: Container(),
                    title: Text("Dashboard"),
                    centerTitle: true,
                  ),
                  // drawer: default_drawer(firstName: firstName, lastName: lastName, position: position),
                  body: GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    children: <Widget>[
                      TileCard(
                          tileText: Text(
                              "Total Borrower",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold
                              ),
                          ),
                          tileIcon: Icon(
                              Icons.supervised_user_circle,
                              color: Colors.white,
                              size: 40,
                          ),
                          subtitle: Text(
                              totalBorrower,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400
                              ),
                          ),
                          tileColor: Colors.blueAccent,
                          onTap: (){
                            Navigator.pushNamed(context, "borrowers");
                          },
                      ),
                      TileCard(
                        tileText: Text(
                          "Pending Loan",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        tileIcon: Icon(
                          Icons.new_releases,
                          color: Colors.white,
                          size: 40,
                        ),
                        subtitle: Text(
                          totalPendingLoan,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                        tileColor: Colors.pinkAccent,
                        onTap: (){
                          Navigator.pushNamed(context, "loan");
                        },
                      ),
                      TileCard(
                        tileText: Text(
                          "Release Loan",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        tileIcon: Icon(
                          Icons.thumb_up_sharp,
                          color: Colors.white,
                          size: 40,
                        ),
                        subtitle: Text(
                          totalToReleaseLoan,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                        tileColor: Colors.redAccent,
                        onTap: (){
                          Navigator.pushNamed(context, "loan");
                        },
                      ),
                      TileCard(
                        tileText: Text(
                          "Pending Capital",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        tileIcon: Icon(
                          Icons.post_add_sharp,
                          color: Colors.white,
                          size: 40,
                        ),
                        subtitle: Text(
                          totalPendingCapital,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                        tileColor: Colors.indigo,
                        onTap: (){
                          Navigator.pushNamed(context, "capital");
                        },
                      ),
                      TileCard(
                        tileText: Text(
                          "To Release Capital",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        tileIcon: Icon(
                          Icons.post_add_sharp,
                          color: Colors.white,
                          size: 40,
                        ),
                        subtitle: Text(
                          totalToReleaseCapital,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                        tileColor: Colors.orangeAccent,
                        onTap: (){
                          Navigator.pushNamed(context, "capital");
                        },
                      ),
                      TileCard(
                        tileText: Text(
                          "Cashier Vault",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        tileIcon: Icon(
                          Icons.all_inbox,
                          color: Colors.white,
                          size: 40,
                        ),
                        subtitle: Text(""),
                        tileColor: Colors.deepOrangeAccent,
                        onTap: (){
                          Navigator.pushNamed(context, "cashier");
                        },
                      ),
                      TileCard(
                        tileText: Text(
                          "Reports",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        tileIcon: Icon(
                          Icons.local_print_shop_outlined,
                          color: Colors.white,
                          size: 40,
                        ),
                        subtitle: Text(
                          totalToReleaseCapital,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                        tileColor: Colors.teal,
                        onTap: (){
                          Navigator.pushNamed(context, "capital");
                        },
                      )
                    ],
                  ),
                  bottomNavigationBar: NavigationBar(),
                )
            );
          }
          if(sizingInformation.deviceScreenType == DeviceScreenType.desktop){
          }
          //this will be return if the device type is not yes supported
          return Center(
            child: Text("Device type not supported"),
          );
        }
    );

  }
}




