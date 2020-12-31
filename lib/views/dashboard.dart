import 'package:flutter/material.dart';
import 'package:barili_prime/MyWidgets/dashboard_card.dart';


class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Barili Prime Dashboard"),
            centerTitle: true,
          ),
          body: Column(
            children: [
                DashboardCard(
                  tileText: "Borrowers",
                  tileIcon:  Icons.supervised_user_circle,
                  onTap: (){
                      Navigator.pushNamed(context, "borrowers");
                  },
                ),
                DashboardCard(
                  tileText: "Loan",
                  tileIcon:  Icons.monetization_on_outlined,
                  onTap: (){
                    Navigator.pushNamed(context, "loan");
                  },
                ),
                DashboardCard(
                  tileText: "Capital",
                  tileIcon:  Icons.post_add_sharp,
                  onTap: (){

                  },
                ),
                DashboardCard(
                  tileText: "Schedules",
                  tileIcon:  Icons.calendar_today_outlined,
                  onTap: (){

                  },
                ),
                DashboardCard(
                  tileText: "Reports",
                  tileIcon:  Icons.local_print_shop_outlined,
                  onTap: (){

                  },
                ),
            ],
          ),
        )
    );
  }
}


