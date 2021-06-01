import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/MainScreen/EditProfilePage.dart';
import 'package:flutter_app/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({this.userId});

  final String userId;

  @override
  ProfilePageState createState() => ProfilePageState(this.userId);
}

class ProfilePageState extends State<ProfilePage> {
  final String profileId;

  String currentUserId = FirebaseAuth.instance.currentUser.uid;
  String view = "grid"; // default view
  bool isFollowing = false;
  bool followButtonClicked = false;
  int postCount = 0;
  int followerCount = 0;
  int followingCount = 0;


  String userName = "";

  ProfilePageState(this.profileId);

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

  // Future<String> getCurrentUserUID() async{
  //   User user = FirebaseAuth.instance.currentUser;
  //   return user.uid;
  // }

  EditProfilePage editPage = new EditProfilePage();

  openEditProfilePage(){
    Navigator.of(context)
        .push(MaterialPageRoute<bool>(builder: (BuildContext context) {
      return editPage;
    }));
  }

  followUser() {
    print('following user');
    setState(() {
      this.isFollowing = true;
      followButtonClicked = true;
    });

    FirebaseFirestore.instance.doc("users/$profileId").update({
      'followers.$currentUserId': true
      //firestore plugin doesnt support deleting, so it must be nulled / falsed
    });

    FirebaseFirestore.instance.doc("users/$currentUserId").update({
      'following.$profileId': true
      //firestore plugin doesnt support deleting, so it must be nulled / falsed
    });

    //updates activity feed
    FirebaseFirestore.instance
        .collection("insta_a_feed")
        .doc(profileId)
        .collection("items")
        .doc(currentUserId)
        .set({
      "ownerId": profileId,
      "username": FirebaseAuth.instance.currentUser.displayName,
      "userId": currentUserId,
      "type": "follow",
      "userProfileImg": FirebaseAuth.instance.currentUser.photoURL,
      "timestamp": DateTime.now()
    });
  }

  unfollowUser() {
    setState(() {
      isFollowing = false;
      followButtonClicked = true;
    });

    FirebaseFirestore.instance.doc("users/$profileId").update({
      'followers.$currentUserId': false
      //firestore plugin doesnt support deleting, so it must be nulled / falsed
    });

    FirebaseFirestore.instance.doc("users/$currentUserId").update({
      'following.$profileId': false
      //firestore plugin doesnt support deleting, so it must be nulled / falsed
    });

    FirebaseFirestore.instance
        .collection("insta_a_feed")
        .doc(profileId)
        .collection("items")
        .doc(currentUserId)
        .delete();
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
              openEditProfilePage();
              // Navigator.of(context).push(
              //   MaterialPageRoute(builder: (context){
              //       return SettingPage();
              //   })
              // );
            }
          )
        ],
      ),
      body: Center(child: Text("Profile Page"),),
    );
  }
}

void openProfile(BuildContext context, String userId) {
  Navigator.of(context)
      .push(MaterialPageRoute<bool>(builder: (BuildContext context) {
    return ProfilePage(userId: userId);
  }));
}