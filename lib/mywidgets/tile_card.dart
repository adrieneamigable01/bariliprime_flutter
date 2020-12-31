import 'package:flutter/material.dart';

class TileCard extends StatelessWidget {
  TileCard({@required this.tileText,@required this.tileIcon,this.trailing,this.subtitle,this.tileColor,this.textColor,this.onTap});
  final Widget tileText;
  final Icon tileIcon;
  final Function onTap;
  final Widget trailing;
  final Widget subtitle;
  Color tileColor = Colors.blueAccent;
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
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              tileIcon,
              tileText,
              subtitle,
            ],
          ),
        ),
      )
    );
  }
}