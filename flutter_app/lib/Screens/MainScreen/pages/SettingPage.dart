import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/Welcome/Welcome.dart';
import 'package:flutter_app/constants.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

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
            Divider(color: Colors.black),
            ListTile(
              title: new Text("other setting 2"),
              leading: new Icon(Icons.edit, color: Colors.blueAccent,),
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