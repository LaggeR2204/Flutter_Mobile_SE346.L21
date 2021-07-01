import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/MainScreen/pages/UploadPage.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/models/AppUser.dart';
import 'package:flutter_app/models/Post.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class TimelinePage extends StatefulWidget {
  @override
  TimelinePageState createState() => TimelinePageState();
}

class TimelinePageState extends State<TimelinePage>
    with AutomaticKeepAliveClientMixin<TimelinePage> {
  final double appBarHeight = AppBar().preferredSize.height;
  List<ImagePost> feedData = [];
  List<ImagePost> tempData = [];
  List<AppUser> followingUser;
  final imagePicker = ImagePicker();
  List<String> followings = [];
  @override
  void initState() {
    super.initState();
  }

  // ensures state is kept when switching pages
  @override
  bool get wantKeepAlive => true;

/*
  Future _getImageFromCamera() async {
    Navigator.pop(context);
    final image = await imagePicker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(image.path);
    });
    Navigator.push(context, MaterialPageRoute(builder: (context)=> UploadPage()));
  }

  Future _getImageFromGallery() async {
    Navigator.pop(context);
    final image = await imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image.path);
    });
    Navigator.push(context, MaterialPageRoute(builder: (context)=> UploadPage()));
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        automaticallyImplyLeading: false,
        brightness: Brightness.dark,
        title: Text(
          appName,
          style: TextStyle(
              fontFamily: 'Billabong',
              fontSize: appBarHeight * 0.7,
              fontStyle: FontStyle.italic),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[appPrimaryColor, appPrimaryColor2],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_rounded),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UploadPage()));
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: buildNewFeed(),
      ),
    );
  }

  buildNewFeed() {
    followings = currentUserModel.following.keys.toList();
    followings.add(currentUserModel.id);
    if (feedData != null) {
      return StreamBuilder<List<ImagePost>>(
          stream: _getfeed(followings),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("Sorry! We have an error."));
            } else if (snapshot.hasData) {
              final data = snapshot.data;
              feedData = data;
            }
            return ListView(
              children: feedData,
            );
          });
    } else {
      return Container(
          alignment: FractionalOffset.center,
          child: CircularProgressIndicator());
    }
  }

  Future<Null> _refresh() async {
    buildNewFeed();
    setState(() {});
    return;
  }

/*  _getNewFeed() async {
    var userFollowingSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserModel.id)
        .get();

    AppUser user = AppUser.fromDocument(userFollowingSnap);
    var followings = user.following;
    List<ImagePost> listPosts = [];
    List<String> followings_list = [];
    //print(followings.keys);

    followings.keys.forEach((key) {
      //print("test " + key);
      followings_list.add(key.toString());
    });
    *//*for (String s in followings_list){
      print("following list " + s);
    }*//*
    listPosts = _getAllPosts(followings_list);

    setState(() {
      feedData = tempData;
    });
  }

  List<ImagePost> _getAllPosts(List<String> followingsList) {
    List<ImagePost> listPosts = [];
    List<ImagePost> userPosts = [];

    for (String s in followingsList) {
      *//* _getUserPosts(s).then((value){
        userPosts.addAll(value);
      });*//*
      _getUserPosts(s);
      listPosts.addAll(userPosts);
    }
    for (ImagePost i in tempData) {
      print("hi hi " + i.description);
    }
    return listPosts;
  }

  *//*Future<void> _getUserPosts(String uid) async {
    List<ImagePost> listPosts = [];
    print(uid);

    var snap = await FirebaseFirestore.instance
        .collection('posts')
        //.where('ownerId', isEqualTo: uid)
        .where('ownerId', isEqualTo: uid)
        .orderBy("timestamp")
        .get();

    for (var doc in snap.docs) {

      listPosts.add(ImagePost.fromDocument(doc));
    }
    tempData.addAll(listPosts);
    return;
  }*//*
  Future<void> _getUserPosts(String uid) async {
    List<ImagePost> listPosts = [];
    print(uid);

    var snap = await FirebaseFirestore.instance
        .collection('posts')
        //.where('ownerId', isEqualTo: uid)
        .where('ownerId', isEqualTo: uid)
        .orderBy("timestamp")
        .get();

    for (var doc in snap.docs) {
      listPosts.add(ImagePost.fromDocument(doc));
    }
    tempData.addAll(listPosts);
    return;
  }*/

  Stream<List<ImagePost>> _getfeed(List<String> followingsList) {
    var snapshots = FirebaseFirestore.instance
        .collection('posts')
        .where('ownerId', whereIn: followingsList)
        .orderBy('timestamp')
        .snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map(
          (snapshot) => ImagePost.fromMap(snapshot.data()),
        )
        .toList());
  }
}
