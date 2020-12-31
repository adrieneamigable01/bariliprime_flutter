import 'package:flutter/material.dart';

class SnackBarPage  {

  showSnackBar({BuildContext context,Widget content}){

    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: content,
      ),
    );
  }

}