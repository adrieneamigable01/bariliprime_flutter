import 'package:flutter/material.dart';

class TableColumn extends StatelessWidget {
  TableColumn({@required this.childRow,this.onTap});

  final Widget childRow;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
            decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 2.0, color: Colors.grey),
                )
            ),
            child: childRow
        ),
      ),
    );
  }
}