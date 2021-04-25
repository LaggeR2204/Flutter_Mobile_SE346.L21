import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/Welcome/Welcome.dart';
import 'package:flutter_app/constants.dart';

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final firestore = Firestore.instance;
  String userName = "";

  @override
  void initState(){
    super.initState();
    updateProfileData();
  }

  Future<void> updateProfileData() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    firestore.collection('users').document(user.uid).get().then((querySnapshot) {
      setState(() {
        userName = querySnapshot['displayName'];
      });
    });
  }

  Future<String> getCurrentUserUID() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
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
        title: Container(
          child: Text(userName),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings), 
            onPressed: (){
              _scaffoldKey.currentState.openEndDrawer();
            }
          )
        ],
      ),
      body: Center(child: Text("Profile Page"),),
      endDrawer: Drawer(
        elevation: 16,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            ListTile(
              title: new Text("Log out"),
              leading: new Icon(Icons.logout),
              onTap: _signOut
            ),
          ],
        )
      )
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