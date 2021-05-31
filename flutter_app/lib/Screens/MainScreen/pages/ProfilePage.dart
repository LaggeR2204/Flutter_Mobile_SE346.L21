import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/MainScreen/pages/SettingPage.dart';
import 'package:flutter_app/constants.dart';

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  String userName = "";

  @override
  void initState(){
    super.initState();
    updateProfileData();
  }

  Future<void> updateProfileData() async{
    User user = FirebaseAuth.instance.currentUser;
    // firestore.collection('users').doc(user.uid).get().then((querySnapshot) {
    //   setState(() {
    //     userName = querySnapshot['displayName'];
    //   });
    // });
    userName = user.displayName;
  }

  Future<String> getCurrentUserUID() async{
    User user = FirebaseAuth.instance.currentUser;
    return user.uid;
  }

  @override
  Widget build(BuildContext context) {
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
        title: Container(
          child: Text(userName),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings), 
            onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context){
                    return SettingPage();
                })
              );
            }
          )
        ],
      ),
      body: Center(child: Text("Profile Page"),),
    );
  }
}