import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barili_prime/mywidgets/my_table.dart';
import 'package:barili_prime/constant/style.dart';
import 'package:barili_prime/controllers/http_loan.dart';
import 'package:barili_prime/mywidgets/my_alert_message.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';
import 'package:barili_prime/mywidgets/default_drawer.dart';
import 'package:barili_prime/helpers/session_login.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:barili_prime/mywidgets/navigation_bar.dart';

int loanId;
String searchText;
var _useFuture;
var httpRequest = HttpLoan();
var alert       = PopupDialog();
String dropdownValue = 'Pending';
SessionList _sessionLogin = SessionList();

class LoanPage extends StatefulWidget {
  @override
  _LoanPageState createState() => _LoanPageState();
}


class _LoanPageState extends State<LoanPage> {

  String userId = _sessionLogin.getSingleBox("userId");
  String firstName = _sessionLogin.getSingleBox("firstName");
  String lastName = _sessionLogin.getSingleBox("lastName");
  String position = _sessionLogin.getSingleBox("position");

  getLoan({payload}) async {
    var response =  await httpRequest.getAllLoan(payload: payload);
    if(response['isError'] == false){
      return response['data'];
    }else{
      return "";
    }
  }



  releaseLoan({payload}) async {
    var response =  await httpRequest.releaseLoan(payload: payload);
    if(response['isError'] == false){
      Navigator.pop(this.context);
      Toast.show(response['message'], context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      setState(() {
        dropdownValue = "Released";
        payload = '?status_id=1&is_released=1';
        _useFuture = getLoan(payload: payload);
      });
    }else{
      alert.onBasicAlert(context: context, title: "System Message", description: response['message']);
    }
  }

  approveLoan({payload}) async {
    var response =  await httpRequest.approveLoan(payload: payload);
    if(response['isError'] == false){
       Toast.show("Successfully approve loan", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
       setState(() {
         dropdownValue = "Approved";
         payload = '?status_id=1&is_released=0';
         _useFuture = getLoan(payload: payload);
       });
       Navigator.pop(this.context);
    }
  }

  disapproveLoan({payload}) async {
    var response = await httpRequest.disapproveLoan(payload: payload);
    if(response['isError'] == false){
      Navigator.pop(this.context);
      alert.onBasicAlert(context: this.context, title: "System Message", description: response['message']);
      setState(() {
        dropdownValue = "Disapproved";
        payload = '?status_id=6';
        _useFuture = getLoan(payload: payload);
      });
    }else{
      Toast.show(response['message'], context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
    }
  }

  @override
  void initState() {
    super.initState();
    String payload = '?status_id=2';
    _useFuture = getLoan(payload: payload);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
        builder: (context,sizingInformation){
          if(sizingInformation.deviceScreenType == DeviceScreenType.tablet){

          }
          if(sizingInformation.deviceScreenType == DeviceScreenType.mobile){
            return Scaffold(
                appBar: AppBar(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Loan"),
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
                              Text("Status:"),
                              DropdownButton<String>(
                                value: dropdownValue,
                                style: TextStyle(
                                    color: Colors.deepPurple
                                ),
                                underline: Container(
                                  height: 2,
                                  color: Colors.deepPurpleAccent,
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    dropdownValue = newValue;
                                    String payload = "";

                                    if(dropdownValue == "Released"){
                                      payload = '?status_id=1&is_released=1';
                                    }else if(dropdownValue == "Approved"){
                                      payload = '?status_id=1&is_released=0';
                                    }
                                    else  if(dropdownValue == "Pending"){
                                      payload = '?status_id=2';
                                    }
                                    else  if(dropdownValue == "Disapproved"){
                                      payload = '?status_id=6';
                                    }else{
                                      payload = '';
                                    }

                                    _useFuture = getLoan(payload: payload);

                                  });
                                },

                                items: <String>['Released','Approved', 'Pending','Disapproved']
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value,style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: FutureBuilder(
                            future: _useFuture,
                            builder: (context, response){
                              if(response.connectionState == ConnectionState.none && response.hasData == null){
                                return Container(
                                  child: Text("Error"),
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
                                  return _createListLoanView(context,response);
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

  Widget _createListLoanView(BuildContext context, AsyncSnapshot response) {

    var values =  response.data;

    return ResponsiveBuilder(
        builder: (context,sizingInformation){
          if(sizingInformation.deviceScreenType == DeviceScreenType.tablet){

          }
          if(sizingInformation.deviceScreenType == DeviceScreenType.mobile){
            return new ListView.builder(
              itemCount: values.length,
              itemBuilder: (BuildContext context,int index){
                return TableColumn(
                    onTap: (){
                      List<Widget> contentBody;
                      List<DialogButton> buttonsItem = [];
                      if(values[index]['status_id'] == "1" && values[index]['is_released'] == "1"){
                        contentBody = [
                          Row(
                            children: [
                              Text("Name:",style: kLoanAlertContent,),
                              Text(values[index]['borrower'] != null ? values[index]['borrower']  : "N/A",style: kLoanAlertContent,),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Principal Amount:",style: kLoanAlertContent,),
                              Text(values[index]['principal_amount'] != null ? values[index]['principal_amount'] : "N/A",style: kLoanAlertContent,),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Release Amount",style: kLoanAlertContent,),
                              Text(values[index]['released_amount'] != null ? values[index]['released_amount'] : "N/A",style: kLoanAlertContent,)
                            ],
                          ),
                          Row(
                            children: [
                              Text("Term",style: kLoanAlertContent,),
                              Text(values[index]['term'] != null ? values[index]['term'] : "N/A",style: kLoanAlertContent,),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Loan Product",style: kLoanAlertContent,),
                              Text(values[index]['loan_product'] != null ? values[index]['loan_product'] : "N/A",style: kLoanAlertContent,),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Interest %:",style: kLoanAlertContent,),
                              Text(values[index]['interest'] != null ? values[index]['interest'] : "N/A",style: kLoanAlertContent,),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Description:",style: kLoanAlertContent,),
                              Text(values[index]['description']!= null ? values[index]['description'] : "N/A",style: kLoanAlertContent,),
                            ],
                          )
                        ];
                      }
                      else if(values[index]['status_id'] == "1" && values[index]['is_released'] == "0"){
                        buttonsItem.add(
                            DialogButton(
                              child: Text(
                                "Release",
                                style: kLoanApproveButton
                              ),
                              onPressed: (){


                                var payload = {
                                  'loan_id':values[index]['loan_id'],
                                  'name':'$lastName, $firstName',
                                  'userId':userId
                                };

                                releaseLoan(payload: payload);
                              },
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(116, 116, 191, 1.0),
                                Color.fromRGBO(52, 138, 199, 1.0)
                              ]),
                            )
                        );
                        contentBody = [
                          Row(
                            children: [
                              Text("Name:",style: kLoanAlertContent,),
                              Text(values[index]['borrower'] != null ? values[index]['borrower']  : "N/A",style: kLoanAlertContent,),
                            ],
                          ),
                          Row(
                            children: [
                              Text("District:",style: kLoanAlertContent,),
                              Text(values[index]['district'] != null ? values[index]['district']  : "N/A",style: kLoanAlertContent,),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Principal Amount:",style: kLoanAlertContent,),
                              Text(values[index]['principal_amount'] != null ? values[index]['principal_amount'] : "N/A",style: kLoanAlertContent,),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Release Amount",style: kLoanAlertContent,),
                              Text(values[index]['released_amount'] != null ? values[index]['released_amount'] : "N/A",style: kLoanAlertContent,)
                            ],
                          ),
                          Row(
                            children: [
                              Text("Term",style: kLoanAlertContent,),
                              Text(values[index]['term'] != null ? values[index]['term'] : "N/A",style: kLoanAlertContent,),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Loan Product",style: kLoanAlertContent,),
                              Text(values[index]['loan_product'] != null ? values[index]['loan_product'] : "N/A",style: kLoanAlertContent,),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Interest %:",style: kLoanAlertContent,),
                              Text(values[index]['interest'] != null ? values[index]['interest'] : "N/A",style: kLoanAlertContent,),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Description:",style: kLoanAlertContent,),
                              Text(values[index]['description']!= null ? values[index]['description'] : "N/A",style: kLoanAlertContent,),
                            ],
                          ),
                        ];
                      }
                      else if(values[index]['status_id'] == "2"){
                        buttonsItem.add(
                          DialogButton(
                            child: Text(
                              "Approve",
                              style: kLoanApproveButton
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              alert.onBasicAlertWithConetnt(
                                  context: context,
                                  title:  "Approve Loan",
                                  content: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [],
                                  ),
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        "Submit",
                                        style: TextStyle(color: Colors.white, fontSize: 15),
                                      ),
                                      onPressed: () {

                                        var payload = {
                                          'loan_id':values[index]['loan_id'],
                                          'name':'$lastName, $firstName',
                                        };

                                        approveLoan(payload: payload);

                                      },
                                      gradient: LinearGradient(colors: [
                                        Color.fromRGBO(116, 116, 191, 1.0),
                                        Color.fromRGBO(52, 138, 199, 1.0)
                                      ]),
                                    ),
                                  ]
                              );
                            },
                            color: Color.fromRGBO(0, 179, 134, 1.0),
                          ),
                        );
                        buttonsItem.add(
                            DialogButton(
                              child: Text(
                                "Disapprove",
                                style: kLoanApproveButton,
                              ),
                              onPressed: (){


                                var payload = {
                                  'loan_id':values[index]['loan_id'],
                                  'name':'$lastName, $firstName',
                                };

                                disapproveLoan(payload: payload);
                              },
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(116, 116, 191, 1.0),
                                Color.fromRGBO(52, 138, 199, 1.0)
                              ]),
                            )
                        );
                        contentBody = [
                          Row(
                            children: [
                              Text(values[index]['borrower'] != null ? values[index]['borrower']  : "N/A",style: kLoanAlertContent,),
                            ],
                          ),
                          Row(
                            children: [
                              Text("District:",style: kLoanAlertContent,),
                              Text(values[index]['district'] != null ? values[index]['district']  : "N/A",style: kLoanAlertContent,),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Principal Amount:",style: kLoanAlertContent,),
                              Text(values[index]['principal_amount'] != null ? values[index]['principal_amount'] : "N/A",style: kLoanAlertContent,),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Release Amount",style: kLoanAlertContent,),
                              Text(values[index]['released_amount'] != null ? values[index]['released_amount'] : "N/A",style: kLoanAlertContent,)
                            ],
                          ),
                          Row(
                            children: [
                              Text("Term",style: kLoanAlertContent,),
                              Text(values[index]['term'] != null ? values[index]['term'] : "N/A",style: kLoanAlertContent,),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Loan Product",style: kLoanAlertContent,),
                              Text(values[index]['loan_product'] != null ? values[index]['loan_product'] : "N/A",style: kLoanAlertContent,),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Interest %:",style: kLoanAlertContent,),
                              Text(values[index]['interest'] != null ? values[index]['interest'] : "N/A",style: kLoanAlertContent,),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Description:",style: kLoanAlertContent,),
                              Text(values[index]['description']!= null ? values[index]['description'] : "N/A",style: kLoanAlertContent,),
                            ],
                          ),
                        ];
                      }
                      else{
                        contentBody = [
                          Row(
                            children: [
                              Text("Name:",style: kLoanAlertContent,),
                              Text(values[index]['borrower'] != null ? values[index]['borrower']  : "N/A",style: kLoanAlertContent,),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Principal Amount:",style: kLoanAlertContent,),
                              Text(values[index]['principal_amount'] != null ? values[index]['principal_amount'] : "N/A",style: kLoanAlertContent,),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Release Amount",style: kLoanAlertContent,),
                              Text(values[index]['released_amount'] != null ? values[index]['released_amount'] : "N/A",style: kLoanAlertContent,)
                            ],
                          ),
                          Row(
                            children: [
                              Text("Term",style: kLoanAlertContent,),
                              Text(values[index]['term'] != null ? values[index]['term'] : "N/A",style: kLoanAlertContent,),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Loan Product",style: kLoanAlertContent,),
                              Text(values[index]['loan_product'] != null ? values[index]['loan_product'] : "N/A",style: kLoanAlertContent,),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Interest %:",style: kLoanAlertContent,),
                              Text(values[index]['interest'] != null ? values[index]['interest'] : "N/A",style: kLoanAlertContent,),
                            ],
                          ),
                          Row(
                            children: [
                              Text("note:",style: kLoanAlertContent,),
                              Text(values[index]['note']!= null ? values[index]['note'] : "N/A",style: kLoanAlertContent,),
                            ],
                          )
                        ];
                      }

                      alert.onBasicAlertWithConetnt(
                          context: context,
                          title:  values[index]['status']!= null ? values[index]['status'] : "N/A",
                          content: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: contentBody,
                          ),
                          buttons: buttonsItem
                      );
                    },
                    childRow: Card(
                      child: ListTile(
                        trailing: Icon(
                          Icons.arrow_right,
                        ),
                        title: Text(values[index]['borrower'],style: kTableContentStyleMobile,),
                        subtitle: Text(values[index]['status'],style: kTableContentStyleMobile,),
                      ),
                    )
                );
              },
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
}


