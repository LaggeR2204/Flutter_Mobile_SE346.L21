import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';

class TimelinePage extends StatefulWidget {
  @override
  TimelinePageState createState() => TimelinePageState();
}

class TimelinePageState extends State<TimelinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(appName),
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
        actions: [
          IconButton(icon: Icon(Icons.add_box), onPressed: (){}),
        ],
      ),
      body: Center(child: Text("Timeline Page"),),
    );
  }
}