import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/Welcome/Welcome.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/main.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  @override
  void initState()
  {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        automaticallyImplyLeading: false,
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back), 
          onPressed: (){
            Navigator.of(context).pop(); 
          }
        ),
        title: Text("Setting"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            ListTile(
              title: new Text("other setting"),
              leading: new Icon(Icons.child_friendly, color: Colors.orange,),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(size.width * 0.03, 10, size.width * 0.03, 10),
              child: Row(
                children: <Widget>[
                  Icon(Icons.wb_sunny, color: Colors.yellow,),
                  SizedBox(width: size.width * 0.08,),
                  Text("Change theme", style: TextStyle(fontSize: size.width * 0.04),),
                  SizedBox(width: size.width * 0.5,),
                ],
              )
            ),
            Divider(color: Colors.black),
            ListTile(
              title: new Text("Log out"),
              leading: new Icon(Icons.logout),
              onTap: _signOut
            ),
          ],
        )
      ),
    );
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut().then((_) {
      currentUserModel = null;
      Navigator.pushAndRemoveUntil(
        context, 
        MaterialPageRoute(
              builder: (context) {
                return WelcomeScreen();
              },
            ), 
        (route) => false
      );
    });
    } catch (e) {

    }
  }
}