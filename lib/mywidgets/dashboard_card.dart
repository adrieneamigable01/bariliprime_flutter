import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  DashboardCard({@required this.tileText,@required this.tileIcon,this.onTap});
  final tileText;
  final IconData tileIcon;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        child: ListTile(
          // tileColor: Colors.grey,
          leading: Icon(
              tileIcon
          ),
          title: Text(tileText,style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),),
        ),
      ),
    );
  }
}