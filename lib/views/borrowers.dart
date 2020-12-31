import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barili_prime/MyWidgets/my_table.dart';
import 'package:barili_prime/Constant/style.dart';
import 'package:barili_prime/network_helper/http_borrower.dart';
import 'package:barili_prime/mywidgets/rounded_input.dart';
import 'package:barili_prime/mywidgets/raised_button.dart';

class BorrowersPage extends StatefulWidget {
  @override
  _BorrowersPageState createState() => _BorrowersPageState();
}

class _BorrowersPageState extends State<BorrowersPage> {
  String searchText;
  var _useFuture;
  var httpRequest = HttpBorrower();

   getBorrowers({payload}) async {
      var response =  await httpRequest.getBorrowers(payload: payload);
      if(response['isError'] == false){
        return response['data'];
      }
   }

  @override
  void initState() {
    super.initState();
    String payload = '?isactive=1';
    _useFuture = getBorrowers(payload: payload);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Borrowers"),
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
                        _useFuture = getBorrowers(payload: payload);
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
                        _useFuture = getBorrowers(payload: payload);
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
             Navigator.pushNamed(context, "borrower");
           },
           childRow: Padding(
             padding: const EdgeInsets.all(10.0),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text(values[index]['borrower_id'],style: kTableContentStyle,),
                 Text(values[index]['fullname'],style: kTableContentStyle,),
                 Text(values[index]['district'],style: kTableContentStyle,),
               ],
             ),
           ),
         );
       },
     );
  }
}


