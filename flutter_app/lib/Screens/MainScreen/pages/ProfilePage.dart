import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Username"),
        actions: [
          IconButton(
            icon: Icon(Icons.settings), 
            onPressed: (){
              _scaffoldKey.currentState.openEndDrawer();
            }
          )
        ],
      ),
      body: Center(child: Text("Search Page"),),
      endDrawer: Drawer(
        elevation: 16,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            ListTile(
              title: new Text("Log out"),
              leading: new Icon(Icons.logout),
            ),
          ],
        )
      )
    );
  }
}