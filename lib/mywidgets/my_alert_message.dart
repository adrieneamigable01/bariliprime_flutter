import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


enum _status  {
  success,
  warning,
  info,
  danger
}

class PopupDialog  {

  // PopupDialog({@required this.context,@required this.title,@required this.description});
  // final dynamic context;
  // final String title;
  // final String description;
  // The easiest way for creating RFlutter Alert
  onBasicAlert({@required context,@required title,@required description}) {
    Alert(
      context: context,
      title: title,
      desc: description,
    ).show();
  }
  onBasicAlertWithConetnt({@required context,@required title,@required content,@required buttons}) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: title,
      content: content,
      buttons: buttons,
    ).show();
  }

 //Custom animation alert
  onCustomAnimationAlertPressed({@required context,@required title,@required description}) {
    Alert(
      context: context,
      title: title,
      desc: description,
      alertAnimation: FadeAlertAnimation,
    ).show();
  }

  Widget FadeAlertAnimation(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return Align(
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

// Alert with single button.
  onAlertButtonPressed({@required context,@required title,@required description,@required dialogButtonText,@required isError}) {
    var alertType = AlertType.error;
    if(isError == false){
      alertType = AlertType.success;
    }
    else{
      alertType = AlertType.warning;
    }

    Alert(
      context: context,
      type: alertType,
      title: title,
      desc: description,
      buttons: [
        DialogButton(
          child: Text(
            dialogButtonText,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => onCustomAnimationAlertPressed(context: context,title: title,description: description),
          width: 120,
        )
      ],
    ).show();
  }

  // Alert with multiple and custom buttons
  onAlertButtonsPressed({@required context,@required title,@required description}) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: title,
      desc: description,
      buttons: [
        DialogButton(
          child: Text(
            "FLAT",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "GRADIENT",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () => Navigator.pop(context),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();
  }

 // Advanced using of alerts
  onAlertWithStylePressed({@required context,@required title,@required description,@required buttonText,@required isError}) {
    // Reusable alert style
    var alertType = AlertType.error;
    if(isError == false){
      alertType = AlertType.success;
    }
    else{
      alertType = AlertType.warning;
    }


    var alertStyle = AlertStyle(
        animationType: AnimationType.fromTop,
        isCloseButton: false,
        isOverlayTapDismiss: false,
        descStyle: TextStyle(fontWeight: FontWeight.bold),
        animationDuration: Duration(milliseconds: 400),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
          side: BorderSide(
            color: Colors.grey,
          ),
        ),
        titleStyle: TextStyle(
          color: Colors.red,
        ),
        constraints: BoxConstraints.expand(width: 300),
        //First to chars "55" represents transparency of color
        overlayColor: Color(0x55000000),
        alertElevation: 0,
        alertAlignment: Alignment.topCenter
    );

    // Alert dialog using custom alert style
    Alert(
      context: context,
      style: alertStyle,
      type: alertType,
      title: title,
      desc: description,
      buttons: [
        DialogButton(
          child: Text(
            buttonText,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color.fromRGBO(0, 179, 134, 1.0),
          radius: BorderRadius.circular(0.0),
        ),
      ],
    ).show();
  }

// Alert custom images
  onAlertWithCustomImagePressed({@required context,@required title,@required description}) {
    Alert(
      context: context,
      title: "RFLUTTER ALERT",
      desc: "Flutter is more awesome with RFlutter Alert.",
      image: Image.asset("assets/success.png"),
    ).show();
  }

// Alert custom content
  onAlertWithCustomContentPressed({@required context,@required title,@required description,@required content}) {
    Alert(
        context: context,
        title: title,
        content: content,
        buttons:[]
        // buttons: [
        //   DialogButton(
        //     onPressed: () => Navigator.pop(context),
        //     child: Text(
        //       "LOGIN",
        //       style: TextStyle(color: Colors.white, fontSize: 20),
        //     ),
        //   )
        // ]
    ).show();
  }
}