import 'package:flutter/material.dart';

class TableColumn extends StatelessWidget {
  TableColumn({@required this.childRow,this.onTap});

  final Widget childRow;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: childRow
    );
  }
}