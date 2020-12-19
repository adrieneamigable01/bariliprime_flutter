import 'package:flutter/material.dart';

class MyRaisedButton extends StatelessWidget {

  MyRaisedButton({@required this.buttonText,@required this.buttonColor,@required this.onPress});

  final buttonText;
  final Color buttonColor;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: RaisedButton(
        color: buttonColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
        child: Text(buttonText,style: TextStyle(color:Colors.white,textBaseline: TextBaseline.alphabetic),),
        onPressed: onPress,
      ),
    );
  }
}