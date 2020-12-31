import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  DashboardCard({@required this.tileText,@required this.tileIcon,this.trailing,this.subtitle,this.tileColor,this.textColor,this.onTap});
  final tileText;
  final IconData tileIcon;
  final Function onTap;
  final Widget trailing;
  final String subtitle;
  final Color tileColor;
  final Color textColor;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: tileColor,
        elevation: 10,
        child: ListTile(
          // tileColor: tileColor,
          trailing: trailing,
          leading: Icon(
              tileIcon
          ),
          title: Text(tileText,style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: textColor
          ),),
          subtitle: Text(
            subtitle,style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: textColor
          ),
          ),
        ),
      ),
    );
  }
}