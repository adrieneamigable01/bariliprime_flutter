import 'package:flutter/material.dart';
import 'package:barili_prime/constant/style.dart';

class default_drawer extends StatelessWidget {
  const default_drawer({
    Key key,
    @required this.firstName,
    @required this.lastName,
    @required this.position,
  }) : super(key: key);

  final String firstName;
  final String lastName;
  final String position;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$firstName, $lastName',style: kDashboardDrawerName),
                Text(position,style: kDashboardPosition,)
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: Icon(
                Icons.dashboard
            ),
            title: Text('Dashbard'),
            onTap: () {
              // Update the state of the app.
              // ...
              Navigator.pushNamed(context, "dashboard");
            },
          ),
          ListTile(
            leading: Icon(
                Icons.supervised_user_circle_sharp
            ),
            title: Text('Borrowers'),
            onTap: () {
              // Update the state of the app.
              // ...
              Navigator.pushNamed(context, "borrowers");
            },
          ),
          ListTile(
            leading: Icon(
                Icons.attach_money
            ),
            title: Text('Loan'),
            onTap: () {
              // Update the state of the app.
              // ...
              Navigator.pushNamed(context, "loan");
            },
          ),
          ListTile(
            leading: Icon(
                Icons.plus_one_sharp
            ),
            title: Text('Added Capital'),
            onTap: () {
              // Update the state of the app.
              // ...
              Navigator.pushNamed(context, "capital");

            },
          ),
          ListTile(
            leading: Icon(
                Icons.print
            ),
            title: Text('Reports'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            leading: Icon(
                Icons.logout
            ),
            title: Text('Logout'),
            onTap: () {
              // Update the state of the app.
              // ...
              Navigator.pushNamed(context, "/");
            },
          ),
        ],
      ),
    );
  }
}