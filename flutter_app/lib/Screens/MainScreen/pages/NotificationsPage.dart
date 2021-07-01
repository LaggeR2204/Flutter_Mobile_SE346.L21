import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:flutter_app/main.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationsPage extends StatefulWidget {
  @override
  NotificationsPageState createState() => NotificationsPageState();
}

Widget mediaPreview;
String notifiationText;

class NotificationsPageState extends State<NotificationsPage> {
  bool isMute = false;
  List<NotificationItems> tempData = [];
  buildNotifications() {
    return Container(
      child: FutureBuilder(
          future: getNoti(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Container(
                  alignment: FractionalOffset.center,
                  padding: const EdgeInsets.only(top: 10.0),
                  child: CircularProgressIndicator());
            else {
              return ListView(children: snapshot.data);
            }
          }),
    );
  }

  Future<void> getNoti() async {
    List<NotificationItems> listNoti = [];
    var snap = await FirebaseFirestore.instance
        .collection('feed')
        .doc(currentUserModel.id)
        .collection("items")
        .get();
    print(currentUserModel.id);
    print(snap.docs);
    for (var doc in snap.docs) {
      listNoti.add(NotificationItems.fromDocument(doc));
    }
    return listNoti;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        automaticallyImplyLeading: false,
        title: Text("Notifications"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isMute = !isMute;
              });
            },
            icon: Icon(
              isMute ? Icons.notifications_off : Icons.notifications,
            ),
          ),
        ],
      ),
      body: buildNotifications(),
    );
  }
}

class NotificationItems extends StatelessWidget {
  final String mediaUrl;
  final String postId;
  final Timestamp timestamp;
  final String type;
  final String userId;
  final String userProfileImg;
  final String commentData;
  final String userName;

  NotificationItems(
      {this.mediaUrl,
      this.postId,
      this.timestamp,
      this.type,
      this.userId,
      this.userProfileImg,
      this.commentData,
      this.userName});

  factory NotificationItems.fromDocument(DocumentSnapshot doc) {
    return NotificationItems(
      mediaUrl: doc.data()['mediaUrl'],
      postId: doc.data()['postId'],
      timestamp: doc.data()['timestamp'],
      commentData: doc.data()['commentData'],
      type: doc.data()['type'],
      userId: doc.data()['userId'],
      userName: doc.data()['username'],
      userProfileImg: doc.data()['userProfileImg'],
    );
  }
  mediaReviewConfig() {
    if (type == "like" || type == "comment") {
      mediaPreview = GestureDetector(
        onTap: () => print('showing post'),
        child: Container(
          height: 50.0,
          width: 50.0,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(mediaUrl),
              )),
            ),
          ),
        ),
      );
    } else {
      mediaPreview = Text('');
    }
    if (type == "like") {
      notifiationText = " liked your post.";
    } else if (type == "follow") {
      notifiationText = " is following you.";
    } else if (type == "comment") {
      notifiationText = " commented: $commentData.";
    } else {
      notifiationText = "Error: Unknown type '$type'";
    }
  }

  @override
  Widget build(BuildContext context) {
    mediaReviewConfig();
    return Padding(
        padding: EdgeInsets.only(bottom: 2.0),
        child: Container(
          color: Colors.white60,
          child: ListTile(
            title: GestureDetector(
              onTap: () => print("profile"),
              child: RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                          text: userName,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                        text: '$notifiationText',
                      )
                    ]),
              ),
            ),
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(userProfileImg),
            ),
            subtitle: Text(
              timeago.format(timestamp.toDate()),
              overflow: TextOverflow.ellipsis,
            ),
            trailing: mediaPreview,
          ),
        ));
  }
}
