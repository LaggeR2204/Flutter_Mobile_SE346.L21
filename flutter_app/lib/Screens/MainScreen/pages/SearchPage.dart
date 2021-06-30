import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';

class SearchPage extends StatefulWidget {
  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final double appBarHeight = AppBar().preferredSize.height;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        brightness: Brightness.dark,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[appPrimaryColor, appPrimaryColor2],
            ),
          ),
        ),
        title: Container(
          height: appBarHeight * 0.8,
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: appPrimaryLightColor,
            borderRadius: BorderRadius.circular(29),
          ),
          child: TextField(
            cursorColor: appPrimaryColor,
            decoration: InputDecoration(
              hintStyle: TextStyle(fontSize: appBarHeight * 0.3),
              hintText: 'Search',
              suffixIcon: Icon(Icons.search),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.only(left: 15, bottom: 10, top: 10, right: 15),
            ),
          ),
        ),
      ),
      body: Center(
        child: Text("Search Page"),
      ),
    );
  }
}
