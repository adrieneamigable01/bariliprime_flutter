import 'package:flutter/material.dart';

class RoundedInput extends StatelessWidget {
  RoundedInput({@required this.hintText,@required this.functionChange,this.keyboardType,this.isObscureText,this.initialValue});
  final hintText;
  final Function functionChange;
  final keyboardType;
  final bool isObscureText;
  final String initialValue;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          hintText: hintText,
          contentPadding: EdgeInsets.all(15.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))
          ),
          filled: true,
          fillColor: Colors.grey[200]
      ),
      initialValue: initialValue,
      keyboardType: keyboardType,
      obscureText: isObscureText != null ? isObscureText : false,
      onChanged: functionChange,
    );
  }
}
