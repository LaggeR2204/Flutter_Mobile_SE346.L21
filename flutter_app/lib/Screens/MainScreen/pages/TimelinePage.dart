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
        actions: [
          IconButton(icon: Icon(Icons.message), onPressed: (){}),
        ],
      ),
      body: Center(child: Text("Timeline Page"),),
    );
  }
}