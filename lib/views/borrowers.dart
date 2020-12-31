import 'package:barili_prime/constant/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barili_prime/mywidgets/my_table.dart';
import 'package:barili_prime/controllers/http_borrower.dart';
import 'package:barili_prime/mywidgets/rounded_input.dart';
import 'package:barili_prime/mywidgets/raised_button.dart';
import 'package:barili_prime/helpers/session_login.dart';
import 'package:barili_prime/helpers/borrowerinfo.dart';
import 'package:barili_prime/mywidgets/default_drawer.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:barili_prime/mywidgets/navigation_bar.dart';

SessionList _sessionLogin = SessionList();
BorrowerList _borrowerList = BorrowerList();

class BorrowersPage extends StatefulWidget {
  @override
  _BorrowersPageState createState() => _BorrowersPageState();
}

class _BorrowersPageState extends State<BorrowersPage> {
  String searchText;
  var _useFuture;
  var httpRequest = HttpBorrower();
  var borrowerBalance = 0;
  String userId = _sessionLogin.getSingleBox("userId");
  String firstName = _sessionLogin.getSingleBox("firstName");
  String lastName = _sessionLogin.getSingleBox("lastName");
  String position = _sessionLogin.getSingleBox("position");

   getBorrowers({payload}) async {
      var response =  await httpRequest.getBorrowers(payload: payload);
      if(response['isError'] == false){
        return response['data'];
      }
   }

   String getImageLink({borrowerId,imageLink}){
     return "https://bariliprime.doitcebu.com/uploads/$borrowerId/$imageLink";
   }


  @override
  void initState() {
    super.initState();
    String payload = '?is_active=1';
    _useFuture = getBorrowers(payload: payload);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
        builder: (context,sizingInformation){
          if(sizingInformation.deviceScreenType == DeviceScreenType.tablet){
            return SafeArea(
              child: Scaffold(
                  appBar: AppBar(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Borrowers"),
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
                                  width: 200.0,
                                  height: 40.0,
                                  child: RoundedInput(
                                    isObscureText: false,
                                    hintText: "Enter Name,District etc.",
                                    functionChange: (searchItem){
                                      searchText = searchItem;
                                      if(searchText == ""){
                                        setState(() {
                                          String payload = '?is_active=1';
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
                                        String payload = '?is_active=1&item=$searchText';
                                        _useFuture = getBorrowers(payload: payload);
                                      });
                                    },
                                  ),
                                )],
                            ),
                          ),
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
                                  return _createListBorrowerView(context,response);
                                }
                              },
                            ),
                          ),
                        ],
                      )
                  )
              ),
            );
          }
          if(sizingInformation.deviceScreenType == DeviceScreenType.mobile){
            return SafeArea(
              child: Scaffold(
                  appBar: AppBar(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Borrowers"),
                      ],
                    ),
                    centerTitle: true,
                  ),
                  drawer: default_drawer(firstName: firstName, lastName: lastName, position: position),
                  body: Container(
                      child:Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                          String payload = '?is_active=1';
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
                                        String payload = '?is_active=1&item=$searchText';
                                        _useFuture = getBorrowers(payload: payload);
                                      });
                                    },
                                  ),
                                )],
                            ),
                          ),
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
                                  return _createListBorrowerView(context,response);
                                }
                              },
                            ),
                          ),
                        ],
                      )
                  ),
                  bottomNavigationBar: NavigationBar(),
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

  Widget _createListBorrowerView(BuildContext context, AsyncSnapshot response) {
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

                     String borrowerId = values[index]['borrower_id'];
                     String firstName = values[index]['firstname'];
                     String lastName = values[index]['lastName'];
                     String fullName = values[index]['fullname'];
                     String image = values[index]['image'];
                     String gender = values[index]['gender'];
                     String present_address = values[index]['present_address'];
                     String position = values[index]['position'];
                     String net = values[index]['net'];
                     String mobile = values[index]['mobile'];
                     String email = values[index]['email'];
                     String district = values[index]['district'];

                     _borrowerList.putSingleBox(key:'borrowerId',value: borrowerId);
                     _borrowerList.putSingleBox(key:'firstName',value: firstName);
                     _borrowerList.putSingleBox(key:'firstName',value: lastName);
                     _borrowerList.putSingleBox(key:'fullName',value: fullName);
                     _borrowerList.putSingleBox(key:'image',value: image);
                     _borrowerList.putSingleBox(key:'gender',value: gender);
                     _borrowerList.putSingleBox(key:'present_address',value: present_address);
                     _borrowerList.putSingleBox(key:'position',value: position);
                     _borrowerList.putSingleBox(key:'net',value: net);
                     _borrowerList.putSingleBox(key:'mobile',value: mobile);
                     _borrowerList.putSingleBox(key:'email',value: email);
                     _borrowerList.putSingleBox(key:'district',value: district);

                     Navigator.pushNamed(context, "borrower");
                   },
                   childRow: Card(
                     child: ListTile(
                       leading: CircleAvatar(
                         backgroundColor: Colors.greenAccent[400],
                         backgroundImage: NetworkImage(
                             getImageLink(borrowerId:values[index]['borrower_id'],imageLink:values[index]['image']),
                         ),
                       ),
                       trailing: Icon(
                         Icons.arrow_right
                       ),
                       title: Text(values[index]['fullname'],style: kBorrowerTableContentStyle,),
                       subtitle: Text(values[index]['district'],style: kBorrowerTableContentStyle,),
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


