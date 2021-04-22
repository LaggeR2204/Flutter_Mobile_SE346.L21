import 'package:flutter/material.dart';

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