import 'package:flutter/material.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';

class NavigationBar extends StatefulWidget {

  @override
  _NavigationBarState createState() => _NavigationBarState();


}


class _NavigationBarState extends State<NavigationBar> {



  @override
  Widget build(BuildContext context) {

    final int args = ModalRoute.of(context).settings.arguments;
    var selectedIndex = args != null ? args : 0;

    return FFNavigationBar(
      theme: FFNavigationBarTheme(
        barBackgroundColor: Colors.indigo,
        selectedItemBorderColor: Colors.blueAccent,
        selectedItemBackgroundColor: Colors.blue,
        selectedItemIconColor: Colors.white,
        selectedItemLabelColor: Colors.white,
        unselectedItemLabelColor: Colors.white,
        unselectedItemIconColor: Colors.white
      ),
      selectedIndex: selectedIndex,
      onSelectTab: (index) {
        setState(() {

          selectedIndex = index;

          if(index == 0){
            Navigator.pushNamed(context, "loan",arguments: 0);
          }else if(index == 1){
            // Navigator.pushNamed(context, "cashier_vault");
            Navigator.pushNamed(context, "dashboard",arguments: 1);
          }else{

          }

        });
      },
      items: [
        FFNavigationBarItem(
          iconData: Icons.attach_money,
          label: 'Loan',
        ),
        FFNavigationBarItem(
          iconData: Icons.home,
          label: 'Home',
        ),
        FFNavigationBarItem(
          iconData: Icons.people,
          label: 'Profile',
        ),
      ],
    );
  }
}

