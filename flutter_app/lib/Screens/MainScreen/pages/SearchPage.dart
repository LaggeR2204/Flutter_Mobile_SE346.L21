import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/constants.dart';

class SearchPage extends StatefulWidget {
  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage>
    with TickerProviderStateMixin<SearchPage> {
  final double appBarHeight = AppBar().preferredSize.height;
  TabController _tabController;
  String searchHintText;

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    _tabController.addListener(TabControllerListener);
    searchHintText = 'Search';
    super.initState();
  }

  @override
  void dispose() {
    _tabController.removeListener(TabControllerListener);
    super.dispose();
  }

  TabControllerListener() {
    if (_tabController.index == 0) {
      setState(() {
        searchHintText = 'Search';
      });
    } else if (_tabController.index == 1) {
      setState(() {
        searchHintText = 'Search accounts';
      });
    } else {
      setState(() {
        searchHintText = 'Search places';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        bottom: TabBar(
          indicatorColor: Colors.white,
          controller: _tabController,
          tabs: [
            Tab(
              text: "Recent",
            ),
            Tab(
              text: "Accounts",
            ),
            Tab(
              text: "Places",
            )
          ],
        ),
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
              hintText: searchHintText,
              suffixIcon: Icon(Icons.search),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.only(left: 15, bottom: 10, top: 10, right: 15),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(
            child: Text("search recent"),
          ),
          Center(
            child: Text("search acc"),
          ),
          Center(
            child: Text("search places"),
          ),
        ],
      ),
    );
  }
}
