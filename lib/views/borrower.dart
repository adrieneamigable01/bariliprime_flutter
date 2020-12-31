import 'package:barili_prime/constant/style.dart';
import 'package:flutter/material.dart';
import 'package:barili_prime/helpers/session_login.dart';
import 'package:barili_prime/mywidgets/default_drawer.dart';
import 'package:barili_prime/helpers/borrowerinfo.dart';
import 'package:barili_prime/controllers/http_borrower.dart';
import 'package:barili_prime/mywidgets/my_table.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:expandable/expandable.dart';
import 'package:intl/intl.dart';
import 'package:barili_prime/mywidgets/navigation_bar.dart';

SessionList _sessionLogin = SessionList();
BorrowerList _borrowerList = BorrowerList();
final oCcy = new NumberFormat("#,##0.00", "en_US");

class BorrowerPage extends StatefulWidget {
  @override
  _BorrowerPageState createState() => _BorrowerPageState();
}

class _BorrowerPageState extends State<BorrowerPage> {

  var _useFuture;
  var httpRequest = HttpBorrower();

  String userId     = _sessionLogin.getSingleBox("userId");
  String firstName  = _sessionLogin.getSingleBox("firstName");
  String lastName   = _sessionLogin.getSingleBox("lastName");
  String position   = _sessionLogin.getSingleBox("position");

  String borrowerId       = _borrowerList.getSingleBox("borrowerId");
  String borrowerFullName = _borrowerList.getSingleBox("fullName");
  String gender           = _borrowerList.getSingleBox("gender");
  String presentAddress   = _borrowerList.getSingleBox("present_address");
  String borrowerPosition = _borrowerList.getSingleBox("position");
  String net              = _borrowerList.getSingleBox("net");
  String mobile           = _borrowerList.getSingleBox("mobile");
  String email            = _borrowerList.getSingleBox("email");
  String district         = _borrowerList.getSingleBox("district");
  String image            = _borrowerList.getSingleBox("image");


  var borrowerBalance     = 0;
  Future getBorrowerLoan({payload}) async {
    var response =  await httpRequest.getBorrowerLoan(payload: payload);
    if(response['isError'] == false){
      return response['data'];
    }
  }

  Future getBorrowerBalance({payload}) async {
    var response = await httpRequest.getBorrowerBalance(payload: payload);
    if(response['isError'] == false){
      setState(() {
        borrowerBalance =  response['data'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    String payload = '?borrower_id=$borrowerId';

    //call borrower on future at init state
    _useFuture = getBorrowerLoan(payload: payload);

    //this will call the borrower loan balance
    getBorrowerBalance(payload: {
      'borrower_id':borrowerId,
    });
  }

  String getRemaining({remaining,capital,payment}){
    var balance = ( double.parse(remaining) + double.parse(capital)) - double.parse(payment);
    return balance.toString();
  }

  @override
  Widget build(BuildContext context) {

    // var deviceData = MediaQuery.of(context);
    // var screenSize = deviceData.size;
    // var width = screenSize.width;
    // var height = screenSize.height;
    // var deviceOrientation = deviceData.orientation;
    // var fontScaling = deviceData.textScaleFactor;
    // var devicePadding = deviceData.padding;
    // var noAnimation = deviceData.disableAnimations;
    // var platFormBrightness = deviceData.platformBrightness;
    // print(screenSize);
    return ResponsiveBuilder(
      builder: (context,sizingInformation){
          if(sizingInformation.deviceScreenType == DeviceScreenType.tablet){
            return Scaffold(
              appBar: AppBar(
                title: Text("Borrower Details"),
                centerTitle: true,
              ),
              // drawer: default_drawer(firstName: firstName, lastName: lastName, position: position),
              body: Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 20.0),
                child: Column(
                  children: [
                    Text("Borrower Details",
                      style: TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.greenAccent[400],
                      backgroundImage: NetworkImage("https://bariliprime.doitcebu.com/uploads/$borrowerId/$image"),
                      radius: 50,
                    ),//Cir
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          crossAxisAlignment:CrossAxisAlignment.start,
                          children: [
                            Text(borrowerId != null ? 'ID: $borrowerId': "N/A",style: kBorrowerDetails),
                            Text(borrowerFullName != null ? 'Name: $borrowerFullName' : "N/A",style: kBorrowerDetails),
                            Text(gender != null ? 'Gender: $gender' : "N/A"),
                            Text(presentAddress != null ? 'Present Address: $presentAddress' : "N/A",style: kBorrowerDetails),
                            Text(borrowerPosition != null ? 'Position : $borrowerPosition' : "N/A",style: kBorrowerDetails),
                          ],
                        ),
                        Column(
                          crossAxisAlignment:CrossAxisAlignment.start,
                          children: [
                            Text(net != null ? 'Net : $net' : "N/A",style: kBorrowerDetails),
                            Text(mobile != null ? 'Mobile # : $mobile' : "N/A",style: kBorrowerDetails),
                            Text(email != null ? 'Email : $email' : "N/A",style: kBorrowerDetails),
                            Text(district != null ? 'District : $district' : "N/A",style: kBorrowerDetails),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text("Loan Details",style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold
                    ),),
                    Container(
                      width: double.infinity,
                      height: 500,
                      child: FutureBuilder(
                        future: _useFuture,
                        builder: (context, response){
                          if(response.connectionState == ConnectionState.none && response.hasData == null){
                            return Center(
                              child: Container(
                                child: Text("Error",style: kNoDataText,),
                              ),
                            );
                          }
                          else if(response.connectionState == ConnectionState.waiting){
                            return Center(
                              child: Container(
                                child: Text("Loading...",style: kNoDataText,),
                              ),
                            );
                          }
                          else{
                            return _createListLoanBorrowerViewMobile(context,response);
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
              bottomNavigationBar: NavigationBar(),
            );
          }
          if(sizingInformation.deviceScreenType == DeviceScreenType.mobile){
            return Scaffold(
              appBar: AppBar(
                title: Text("Borrower Details"),
                centerTitle: true,
              ),
              drawer: default_drawer(firstName: firstName, lastName: lastName, position: position),
              body: Column(
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.greenAccent[400],
                    backgroundImage: NetworkImage("https://bariliprime.doitcebu.com/uploads/$borrowerId/$image"),
                    radius: 50,
                  ),//Cir
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment:CrossAxisAlignment.start,
                        children: [
                          Text(borrowerId != null ? 'ID: $borrowerId': "N/A",style: kBorrowerDetailsMobile),
                          Text(borrowerFullName != null ? 'Name: $borrowerFullName' : "N/A",style: kBorrowerDetailsMobile),
                          Text(gender != null ? 'Gender: $gender' : "N/A",style: kBorrowerDetailsMobile),
                          Text(presentAddress != null ? 'Present Address: $presentAddress' : "N/A",style: kBorrowerDetailsMobile),
                          Text(borrowerPosition != null ? 'Position : $borrowerPosition' : "N/A",style: kBorrowerDetailsMobile),
                          Text(borrowerPosition != null ? 'Total Loan Balance : $borrowerBalance' : "N/A",style: kBorrowerDetailsMobile),
                        ],
                      ),
                      Column(
                        crossAxisAlignment:CrossAxisAlignment.start,
                        children: [
                          Text(net != null ? 'Net : $net' : "N/A",style: kBorrowerDetailsMobile),
                          Text(mobile != null ? 'Mobile # : $mobile' : "N/A",style: kBorrowerDetailsMobile),
                          Text(email != null ? 'Email : $email' : "N/A",style: kBorrowerDetailsMobile),
                          Text(district != null ? 'District : $district' : "N/A",style: kBorrowerDetailsMobile),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text("Loan Details",style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold
                  ),),
                  Expanded(
                    child: FutureBuilder(
                      future: _useFuture,
                      builder: (context, response){
                        if(response.connectionState == ConnectionState.none && response.hasData == null){
                          return Center(
                            child: Container(
                              child: Text("Error",style: kNoDataText,),
                            ),
                          );
                        }
                        else if(response.connectionState == ConnectionState.waiting){
                          return Center(
                            child: Container(
                              child: Text("Loading...",style: kNoDataText,),
                            ),
                          );
                        }
                        else{
                          return _createListLoanBorrowerViewMobile(context,response);
                        }
                      },
                    ),
                  )
                ],
              ),
            );
          }
          if(sizingInformation.deviceScreenType == DeviceScreenType.desktop){
          }
          return Center(
            child: Text("No Device Size Found"),
          );
      }
    );
  }

  Widget _createListLoanBorrowerViewMobile(BuildContext context, AsyncSnapshot response) {
    var values =  response.data;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: values.length,
      itemBuilder: (BuildContext context,int index){

        var loanId          = values[index]['loan_id'];
        var principalAmount = values[index]['principal_amount'];
        var releasedAmount  = values[index]['released_amount'];
        var interest        = values[index]['interest'];
        var term            = values[index]['term'] != null ? values[index]['term'] : "N/A";
        var description     = values[index]['description'];
        var dateAdded       = values[index]['date_added'];
        var creditLine      = values[index]['credit_line'];
        var totalPaid       = values[index]['total_paid'];
        var addedCapital    = values[index]['added_capital'];
        var totalAmount     = double.parse(principalAmount) + double.parse(addedCapital);
        var remaining       = totalAmount - double.parse(totalPaid);

        return TableColumn(
          onTap: (){
            Navigator.pushNamed(context, "borrower");
          },
          childRow: Card(
            child: ExpandablePanel (
              header: ListTile(
                leading: Icon(
                  Icons.dashboard
                ),
                title: Text(values[index]['loan_product'],softWrap: true,),
                subtitle: Text(getRemaining(
                    remaining: values[index]['principal_amount'],
                    capital: values[index]['added_capital'],
                    payment: values[index]['total_paid']
                ),
                )),
              expanded:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                     Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Text('Loan # : $loanId',style: kLoanSingleDetailsMobile,),
                          Text('Principal Amount # : $principalAmount',style: kLoanSingleDetailsMobile,),
                          Text('Added Capital : $addedCapital',style: kLoanSingleDetailsMobile,),
                          Text('Total Amount : $totalAmount',style: kLoanSingleDetailsMobile,),
                          Text('Total Paid : $totalPaid',style: kLoanSingleDetailsMobile,),
                          Text('Balance : $remaining',style: kLoanSingleDetailsMobile,),
                        ],
                      ),
                     Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Interest Rate : $interest',style: kLoanSingleDetailsMobile,),
                        Text('Term : $term',style: kLoanSingleDetailsMobile,),
                        Text('Added Capital : $addedCapital',style: kLoanSingleDetailsMobile,),
                        Text('Date Added : $dateAdded',style: kLoanSingleDetailsMobile,),
                        Text('CreditLine : $creditLine',style: kLoanSingleDetailsMobile,),
                      ],
                    ),
                    ],
                ),
            ),
          ),
        );
      },
    );
  }
}


//
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Text(values[index]['principal_amount'],style: kTableContentStyleLoan,),
// Text(values[index]['loan_product'],style: kTableContentStyleLoan,),
// Text(values[index]['principal_amount'],style: kTableContentStyleLoan,),
// Text(values[index]['total_amount'],style: kTableContentStyleLoan,),
// ],
// ),
