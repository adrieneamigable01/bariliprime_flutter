import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barili_prime/mywidgets/my_table.dart';
import 'package:barili_prime/constant/style.dart';
import 'package:barili_prime/network_helper/http_loan.dart';
import 'package:barili_prime/mywidgets/rounded_input.dart';
import 'package:barili_prime/mywidgets/raised_button.dart';
import 'package:barili_prime/mywidgets/my_alert_message.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';

int loanId;
String searchText;
var _useFuture;
var httpRequest = HttpLoan();
var alert = PopupDialog();
String dropdownValue = 'Pending';

class LoanPage extends StatefulWidget {
  @override
  _BorrowersPageState createState() => _BorrowersPageState();
}


class _BorrowersPageState extends State<LoanPage> {

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
        searchText = "Release";
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
         searchText = "Approved";
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
        searchText = "Disapproved";
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

    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Loan"),
              Container(
                width: 200.0,
                height: 40.0,
                child: DropdownButton<String>(
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
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: Container(
            child:FutureBuilder(
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
                    return _createListBorrowerView(context,response);
                  }else{
                    return Center(
                      child: Container(
                        child: Text("No data found",style: kNoDataText,),
                      ),
                    );
                  }

                }
              },
            )
        )
    );
  }

  Widget _createListBorrowerView(BuildContext context, AsyncSnapshot response) {
    var values =  response.data;
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
                    Text("Name:"),
                    Text(values[index]['borrower'] != null ? values[index]['borrower']  : "N/A",style: kTableContentStyle,),
                  ],
                ),
                Row(
                  children: [
                    Text("Principal Amount:"),
                    Text(values[index]['principal_amount'] != null ? values[index]['principal_amount'] : "N/A",style: kTableContentStyle,),
                  ],
                ),
                Row(
                  children: [
                    Text("Release Amount"),
                    Text(values[index]['released_amount'] != null ? values[index]['released_amount'] : "N/A",style: kTableContentStyle,)
                  ],
                ),
                Row(
                  children: [
                    Text("Term"),
                    Text(values[index]['term'] != null ? values[index]['term'] : "N/A",style: kTableContentStyle,),
                  ],
                ),
                Row(
                  children: [
                    Text("Loan Product"),
                    Text(values[index]['loan_product'] != null ? values[index]['loan_product'] : "N/A",style: kTableContentStyle,),
                  ],
                ),
                Row(
                  children: [
                    Text("Interest %:"),
                    Text(values[index]['interest'] != null ? values[index]['interest'] : "N/A",style: kTableContentStyle,),
                  ],
                ),
                Row(
                  children: [
                    Text("Description:"),
                    Text(values[index]['description']!= null ? values[index]['description'] : "N/A",style: kTableContentStyle,),
                  ],
                )
              ];
            }
            else if(values[index]['status_id'] == "1" && values[index]['is_released'] == "0"){
              buttonsItem.add(
                  DialogButton(
                    child: Text(
                      "Release",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    onPressed: (){


                      var payload = {
                        'loan_id':values[index]['loan_id'],
                        'name':'TestAdriene',
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
                    Text("Name:"),
                    Text(values[index]['borrower'] != null ? values[index]['borrower']  : "N/A",style: kTableContentStyle,),
                  ],
                ),
                Row(
                  children: [
                    Text("District:"),
                    Text(values[index]['district'] != null ? values[index]['district']  : "N/A",style: kTableContentStyle,),
                  ],
                ),
                Row(
                  children: [
                    Text("Principal Amount:"),
                    Text(values[index]['principal_amount'] != null ? values[index]['principal_amount'] : "N/A",style: kTableContentStyle,),
                  ],
                ),
                Row(
                  children: [
                    Text("Release Amount"),
                    Text(values[index]['released_amount'] != null ? values[index]['released_amount'] : "N/A",style: kTableContentStyle,)
                  ],
                ),
                Row(
                  children: [
                    Text("Term"),
                    Text(values[index]['term'] != null ? values[index]['term'] : "N/A",style: kTableContentStyle,),
                  ],
                ),
                Row(
                  children: [
                    Text("Loan Product"),
                    Text(values[index]['loan_product'] != null ? values[index]['loan_product'] : "N/A",style: kTableContentStyle,),
                  ],
                ),
                Row(
                  children: [
                    Text("Interest %:"),
                    Text(values[index]['interest'] != null ? values[index]['interest'] : "N/A",style: kTableContentStyle,),
                  ],
                ),
                Row(
                  children: [
                    Text("Description:"),
                    Text(values[index]['description']!= null ? values[index]['description'] : "N/A",style: kTableContentStyle,),
                  ],
                ),
              ];
            }
            else if(values[index]['status_id'] == "2"){
              buttonsItem.add(
                  DialogButton(
                    child: Text(
                      "Approve",
                      style: TextStyle(color: Colors.white, fontSize: 18),
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
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                              onPressed: () {

                                var payload = {
                                  'loan_id':values[index]['loan_id'],
                                  'name':'TestAdriene'
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
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    onPressed: (){


                      var payload = {
                        'loan_id':values[index]['loan_id'],
                        'name':'TestAdriene'
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
                    Text("Name:"),
                    Text(values[index]['borrower'] != null ? values[index]['borrower']  : "N/A",style: kTableContentStyle,),
                  ],
                ),
                Row(
                  children: [
                    Text("District:"),
                    Text(values[index]['district'] != null ? values[index]['district']  : "N/A",style: kTableContentStyle,),
                  ],
                ),
                Row(
                  children: [
                    Text("Principal Amount:"),
                    Text(values[index]['principal_amount'] != null ? values[index]['principal_amount'] : "N/A",style: kTableContentStyle,),
                  ],
                ),
                Row(
                  children: [
                    Text("Release Amount"),
                    Text(values[index]['released_amount'] != null ? values[index]['released_amount'] : "N/A",style: kTableContentStyle,)
                  ],
                ),
                Row(
                  children: [
                    Text("Term"),
                    Text(values[index]['term'] != null ? values[index]['term'] : "N/A",style: kTableContentStyle,),
                  ],
                ),
                Row(
                  children: [
                    Text("Loan Product"),
                    Text(values[index]['loan_product'] != null ? values[index]['loan_product'] : "N/A",style: kTableContentStyle,),
                  ],
                ),
                Row(
                  children: [
                    Text("Interest %:"),
                    Text(values[index]['interest'] != null ? values[index]['interest'] : "N/A",style: kTableContentStyle,),
                  ],
                ),
                Row(
                  children: [
                    Text("Description:"),
                    Text(values[index]['description']!= null ? values[index]['description'] : "N/A",style: kTableContentStyle,),
                  ],
                ),
              ];
            }
            else{
              contentBody = [
                Row(
                  children: [
                    Text("Name:"),
                    Text(values[index]['borrower'] != null ? values[index]['borrower']  : "N/A",style: kTableContentStyle,),
                  ],
                ),
                Row(
                  children: [
                    Text("Principal Amount:"),
                    Text(values[index]['principal_amount'] != null ? values[index]['principal_amount'] : "N/A",style: kTableContentStyle,),
                  ],
                ),
                Row(
                  children: [
                    Text("Release Amount"),
                    Text(values[index]['released_amount'] != null ? values[index]['released_amount'] : "N/A",style: kTableContentStyle,)
                  ],
                ),
                Row(
                  children: [
                    Text("Term"),
                    Text(values[index]['term'] != null ? values[index]['term'] : "N/A",style: kTableContentStyle,),
                  ],
                ),
                Row(
                  children: [
                    Text("Loan Product"),
                    Text(values[index]['loan_product'] != null ? values[index]['loan_product'] : "N/A",style: kTableContentStyle,),
                  ],
                ),
                Row(
                  children: [
                    Text("Interest %:"),
                    Text(values[index]['interest'] != null ? values[index]['interest'] : "N/A",style: kTableContentStyle,),
                  ],
                ),
                Row(
                  children: [
                    Text("note:"),
                    Text(values[index]['note']!= null ? values[index]['note'] : "N/A",style: kTableContentStyle,),
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
          childRow: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(values[index]['borrower'],style: kTableContentStyle,),
                Text(values[index]['released_amount'],style: kTableContentStyle,),
                Text(values[index]['status'],style: kTableContentStyle,),
              ],
            ),
          ),
        );
      },
    );
  }
}


