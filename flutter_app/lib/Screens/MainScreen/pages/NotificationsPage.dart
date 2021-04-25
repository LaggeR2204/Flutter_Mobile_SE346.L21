import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';

class NotificationsPage extends StatefulWidget {
  @override
  NotificationsPageState createState() => NotificationsPageState();
}

class NotificationsPageState extends State<NotificationsPage> {
  bool isMute = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[
                appPrimaryColor,
                appPrimaryColor2
              ],
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        title: Text("Notifications"),
        actions: [
          IconButton(
            onPressed: (){
              setState(() {
                isMute = !isMute;
              });
            },
            icon: Icon(
              isMute 
              ? Icons.notifications_off 
              : Icons.notifications,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Center(child: Text("Noti Page"),),
    );
  }
}