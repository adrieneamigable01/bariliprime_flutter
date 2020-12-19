import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barili_prime/MyWidgets/my_table.dart';
import 'package:barili_prime/Constant/style.dart';
import 'package:barili_prime/network_helper/http_loan.dart';
import 'package:barili_prime/mywidgets/rounded_input.dart';
import 'package:barili_prime/mywidgets/raised_button.dart';
import 'package:barili_prime/mywidgets/my_alert_message.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LoanPage extends StatefulWidget {
  @override
  _BorrowersPageState createState() => _BorrowersPageState();
}

class _BorrowersPageState extends State<LoanPage> {
  String searchText;
  var _useFuture;
  var httpRequest = HttpLoan();
  var alert = PopupDialog();
  getLoan({payload}) async {
    var response =  await httpRequest.getAllLoan(payload: payload);
    if(response['isError'] == false){
      return response['data'];
    }
  }

  @override
  void initState() {
    super.initState();
    String payload = '?status_id=1';
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 200.0,
                    height: 40.0,
                    child: RoundedInput(
                      isObscureText: false,
                      hintText: "Enter Name,District etc.",
                      functionChange: (searchItem){
                        searchText = searchItem;
                        if(searchText == ""){
                          setState(() {
                            String payload = '?isactive=1';
                            _useFuture = getLoan(payload: payload);
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Container(
                    width: 100.0,
                    child: MyRaisedButton(
                      buttonText:"Search",
                      buttonColor: Colors.blueAccent,
                      onPress: () async {
                        setState(() {
                          // _useFuture = getBorrowers();
                          String payload = '?isactive=1&item=$searchText';
                          _useFuture = getLoan(payload: payload);
                        });
                      },
                    ),
                  )],
              )
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
                  return Container(
                    child: Text("Loading"),
                  );
                }
                else{
                  return _createListBorrowerView(context,response);
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
            var buttonsItem = [];

            if(values[index]['status_id'] == 1){

            }


            alert.onBasicAlertWithConetnt(
                context: context,
                title: "Loan Details",
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(values[index]['borrower'],style: kTableContentStyle,),
                    Text(values[index]['principal_amount'],style: kTableContentStyle,),
                    Text(values[index]['released_amount'],style: kTableContentStyle,),
                    Text(values[index]['term'],style: kTableContentStyle,),
                    Text(values[index]['loan_product'],style: kTableContentStyle,),
                    Text(values[index]['interest'],style: kTableContentStyle,),
                    Text(values[index]['status'],style: kTableContentStyle,),
                  ],
                ),
               buttons: [
                 DialogButton(
                   child: Text(
                     "Approve",
                     style: TextStyle(color: Colors.white, fontSize: 18),
                   ),
                   onPressed: () => Navigator.pop(context),
                   color: Color.fromRGBO(0, 179, 134, 1.0),
                 ),
                 DialogButton(
                   child: Text(
                     "Release",
                     style: TextStyle(color: Colors.white, fontSize: 18),
                   ),
                   onPressed: () => Navigator.pop(context),
                   gradient: LinearGradient(colors: [
                     Color.fromRGBO(116, 116, 191, 1.0),
                     Color.fromRGBO(52, 138, 199, 1.0)
                   ]),
                 )
               ]
            );
          },
          childRow: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(values[index]['loan_id'],style: kTableContentStyle,),
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


