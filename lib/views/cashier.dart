import 'dart:async';
import 'package:barili_prime/constant/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barili_prime/mywidgets/my_table.dart';
import 'package:barili_prime/helpers/session_login.dart';
import 'package:barili_prime/helpers/borrowerinfo.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:barili_prime/mywidgets/navigation_bar.dart';
import 'package:barili_prime/controllers/http_cashier.dart';
import 'package:barili_prime/mywidgets/my_alert_message.dart';
import 'package:barili_prime/controllers/http_users.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:barili_prime/mywidgets/float_button.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:barili_prime/mywidgets/rounded_input.dart';
import 'package:barili_prime/mywidgets/raised_button.dart';
import 'package:toast/toast.dart';

SessionList _sessionLogin = SessionList();
BorrowerList _borrowerList = BorrowerList();

class CashierPage extends StatefulWidget {
  @override
  _CashierPageState createState() => _CashierPageState();
}

class _CashierPageState extends State<CashierPage> {

  String searchText;
  var _isDone = false;
  String _overAllCash = "0";
  String _totalCashIn = "0";
  String _totalCashOut = "0";
  var _useFuture = null;
  var httpCashier = HttpCashier();
  var httpUsers = HttpUsers();
  var alert = PopupDialog();
  var cashierTotal = 0;
  var dropdownValue = "Approved";
  String cashierUserId;
  String _amount ;
  String _description;



  List<DropdownMenuItem<int>> _users = [];


  String userId = _sessionLogin.getSingleBox("userId");
  String firstName = _sessionLogin.getSingleBox("firstName");
  String lastName = _sessionLogin.getSingleBox("lastName");
  String position = _sessionLogin.getSingleBox("position");
  DateTime selectedDate = DateTime.now();
  DateTime currentDate = DateTime.now();


  getCashierVault({payload}) async {
    var response =  await httpCashier.getCashierVault(payload: payload);
    print(response);
    if(response['isError'] == false){
      var total = response['total'];
      var cin = response['in'];
      var cout = response['out'];
      setState(() {
        // _totalCashIn = response['total'];
        _isDone = response['isDone'] != "Error" ? response['isDone'] : true ;

        _overAllCash  = total.toString();
        _totalCashIn  = cin.toString();
        _totalCashOut = cout.toString();

      });
      return response['data'];
    }
  }

  getCashier({payload}) async {

    var response =  await httpUsers.getUsers(payload: payload);
    print("Cashier Response : $response");

    if(response['isError'] == false){

      _users.clear();

      var data =  response['data'];
      data.forEach((dynamic value){
         String lastName    = value['lastname'];
         String firstName   = value['firstname'];
         String middleName  = value['middlename'];
         String fullName    = '$firstName $lastName';
         String id          = value['user_id'];
         print(fullName);
         setState(() {
           _users.add(
               DropdownMenuItem(
                 value: int.parse(id),
                 child: Text(fullName),
               )
           );
         });
      });

    }
  }


  addMiniVaultTransaction({payload}) async {
    var response =  await httpCashier.miniVaultDeposit(payload: payload);

    var message =  response['message'];

    if(response['isError'] == false){

      var payload = {
        'userId':'$cashierUserId',
        'date': "${selectedDate.toLocal()}".split(' ')[0]
      };

      setState(() {
        Navigator.pop(this.context);
        _useFuture = getCashierVault(payload: payload);
      });

    }

    Toast.show(message, context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);

  }


  @override
  void initState() {
    super.initState();

    var getCashierPayload = '?usertype_id=4';
    getCashier(payload: getCashierPayload);

  }

  var form = FormGroup({
    'users' : FormControl(validators: [ Validators.required ]),
  });

  var formCashIn = FormGroup({
    'vault' : FormControl(validators: [ Validators.required ]),
  });
  @override
  Widget build(BuildContext context) {


    Future<void> _selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2015, 8),
          lastDate: currentDate);

      if (picked != null && picked != selectedDate){
        setState(() {
          selectedDate = picked;
          var payload = {
            'userId':'$cashierUserId',
            'date': "${selectedDate.toLocal()}".split(' ')[0]
          };
          setState(() {
            _useFuture = getCashierVault(payload: payload);
          });
        });
      }

    }


    return ResponsiveBuilder(
        builder: (context,sizingInformation){
          if(sizingInformation.deviceScreenType == DeviceScreenType.tablet){

          }
          if(sizingInformation.deviceScreenType == DeviceScreenType.mobile){
            return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Cashiers Vault"),
                    ],
                  ),
                  centerTitle: true,
                ),
                // drawer: default_drawer(firstName: firstName, lastName: lastName, position: position),
                body: Container(
                    child:Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 300.0,
                                child: ReactiveForm(
                                  formGroup: this.form,
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: ReactiveDropdownField <int> (
                                                onChanged: (value){
                                                  cashierUserId = value.toString();
                                                  var payload = {
                                                    'userId':'$cashierUserId',
                                                    'date': "${selectedDate.toLocal()}".split(' ')[0]
                                                  };
                                                  setState(() {
                                                    _useFuture = getCashierVault(payload: payload);
                                                  });
                                                },
                                                formControlName: 'users',
                                                hint:Text("Select a cashier"),
                                                items: _users
                                            ),
                                          ),
                                          GestureDetector(
                                            child: Text("${selectedDate.toLocal()}".split(' ')[0],style: TextStyle(
                                              fontSize: 15.0,
                                            ),),
                                            onTap: () => _selectDate(context),
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                )
                              )],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 30.0,bottom: 30.0,right:30.0,left: 30.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("In:",style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold
                                  ),),
                                  Text(_totalCashIn,style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400
                                  ),)
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Out:",style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold
                                  ),),
                                  Text(_totalCashOut,style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400
                                  ),)
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Total:",style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold
                                  ),),
                                  Text(_overAllCash,style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400
                                  ),)
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: FutureBuilder(
                            future: _useFuture,
                            builder: (context, response){
                              if(response.data == null){
                                return Center(
                                  child: Container(
                                    child: Text("No Data",style: kNoDataText,),
                                  ),
                                );
                              }
                              else if(response.connectionState == ConnectionState.none && response.hasData == null){
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
                                if(response.data.length > 0){
                                  return _createListCashierView(context,response);
                                }else{
                                  return Center(
                                    child: Container(
                                      child: Text("No data found",style: kNoDataText,),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    )
                ),
                bottomNavigationBar: NavigationBar(),
                floatingActionButton: _isDone == false ? FloatingButton(
                  children:  [
                    SpeedDialChild(
                      child: Icon(Icons.keyboard_return),
                      backgroundColor: Colors.blue,
                      label: 'Return to Vault',
                      labelStyle: TextStyle(fontSize: 18.0),
                      onTap: () {
                        alert.onAlertWithCustomContentPressed(
                          context: context,
                          title: "Return To Vault",
                          content: ReactiveForm(
                            formGroup: this.formCashIn,
                            child: Column(
                              children: <Widget>[
                                RoundedInput(
                                  hintText: "Enter Description",
                                  keyboardType: TextInputType.multiline,
                                  functionChange: (description){
                                    _description = description;
                                  },
                                ),
                                MyRaisedButton(
                                  buttonText:"Submit",
                                  buttonColor: Colors.blueAccent,
                                  onPress: () async {
                                    var cashInPayload = {
                                      'date':"${selectedDate.toLocal()}".split(' ')[0],
                                      'amount':'$_amount',
                                      'description':'$_description',
                                      'assign_id':'$cashierUserId',
                                      'transaction_type_id':'1',
                                      'user_id':'$userId',
                                      'name':'$firstName $lastName',
                                    };
                                    addMiniVaultTransaction(payload: cashInPayload);
                                  },
                                ),
                              ],
                            ),
                          ),
                          // buttons: []
                        );
                      },
                    ),
                    SpeedDialChild(
                        child: Icon(Icons.add_circle),
                        backgroundColor: Colors.green,
                        label: 'Cash In',
                        labelStyle: TextStyle(fontSize: 18.0),
                        onTap: () => {
                          alert.onAlertWithCustomContentPressed(
                              context: context,
                              title: "Return To Vault",
                              content: ReactiveForm(
                                formGroup: this.formCashIn,
                                child: Column(
                                  children: <Widget>[
                                    RoundedInput(
                                      hintText: "Enter Amount",
                                      validator: (value){
                                        if (value.isEmpty) {
                                          return "Empty value";
                                        }
                                      },
                                      functionChange: (amount){
                                        _amount = amount;
                                      },
                                    ),
                                    SizedBox(height: 10.0,),
                                    RoundedInput(
                                      hintText: "Enter Description",
                                      keyboardType: TextInputType.multiline,
                                      functionChange: (description){
                                          _description = description;
                                      },
                                    ),
                                    MyRaisedButton(
                                      buttonText:"Submit",
                                      buttonColor: Colors.blueAccent,
                                      onPress: () async {
                                        var cashInPayload = {
                                          'date':"${selectedDate.toLocal()}".split(' ')[0],
                                          'amount':'$_amount',
                                          'description':'$_description',
                                          'assign_id':'$cashierUserId',
                                          'transaction_type_id':'1',
                                          'user_id':'$userId',
                                          'name':'$firstName $lastName',
                                        };
                                        addMiniVaultTransaction(payload: cashInPayload);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              // buttons: []
                          )
                        }
                    ),
                  ],
                ) : null ,
              ),
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

  Widget _createListCashierView(BuildContext context, AsyncSnapshot response) {
    var values =  response.data;
    return ResponsiveBuilder(
        builder: (context,sizingInformation){
          if(sizingInformation.deviceScreenType == DeviceScreenType.tablet){

          }
          if(sizingInformation.deviceScreenType == DeviceScreenType.mobile){
            return new ListView.builder(
              itemCount: values.length,
              itemBuilder: (BuildContext context,int index){
                var id                = values[index]['id'];
                var amount            = values[index]['amount'];
                var dateAdded         = values[index]['date_added'];
                var transactionType   = values[index]['transaction_type_id'] == "1" ? "Cash In" : "Cash out";
                var transactionTypeId = values[index]['transaction_type_id'];
                var transactBy        = values[index]['trasnsactby'];
                var description       = values[index]['description'];


                return TableColumn(
                  onTap: (){
                    Navigator.pushNamed(context, "borrower");
                  },
                  childRow: Card(
                    child: ListTile(
                      leading: Icon(
                          transactionTypeId == "1" ? Icons.add_circle : Icons.remove_circle
                      ),
                      title: Text('$amount',softWrap: true,style: transactionTypeId == "1" ? kCashierVaultPriceStyleIn : kCashierVaultPriceStyleOut,),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$transactionType by $transactBy',softWrap: true),
                          Text('Date: $dateAdded',softWrap: true,),
                          Text('Description: $description',softWrap: true,),
                        ],
                      ),
                    ),
                  ),
                );
                return TableColumn(
                    onTap: (){

                    },
                    childRow: Card(
                      child: ListTile(
                        // leading: CircleAvatar(
                        //   backgroundColor: Colors.greenAccent[400],
                        //   backgroundImage: NetworkImage(
                        //     getImageLink(borrowerId:values[index]['borrower_id'],imageLink:values[index]['image']),
                        //   ),
                        // ),
                        trailing: Icon(
                            Icons.arrow_right
                        ),
                        title: Text(values[index]['trasnsactby'],style: kBorrowerTableContentStyle,),
                        subtitle: Text(values[index]['amount'],style: kBorrowerTableContentStyle,),
                        // trailing: Text(values[index]['position'],style: kBorrowerTableContentStyle,),
                      ),
                    )
                );
              },
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


