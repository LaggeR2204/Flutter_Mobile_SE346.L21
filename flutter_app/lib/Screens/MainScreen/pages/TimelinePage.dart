import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';

class TimelinePage extends StatefulWidget {
  @override
  TimelinePageState createState() => TimelinePageState();
}

class TimelinePageState extends State<TimelinePage> {
  final double appBarHeight = AppBar().preferredSize.height;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        brightness: Brightness.dark,
        title: Text(
          appName,
          style: TextStyle(fontFamily: 'Billabong', fontSize: appBarHeight * 0.7, fontStyle: FontStyle.italic),
        ),
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
          IconButton(icon: Icon(Icons.add_circle_rounded), onPressed: (){}),
        ],
      ),
      body: Center(child: Text("Timeline Page"),),
    );
  }
}