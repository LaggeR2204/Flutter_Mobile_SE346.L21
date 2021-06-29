import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/MainScreen/pages/Chat.dart';
import 'package:flutter_app/Screens/MainScreen/pages/SearchChatUser.dart';
import 'package:flutter_app/components/Loading.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/main.dart';

class MessengerPage extends StatefulWidget {
  @override
  MessengerPageState createState() => MessengerPageState();
}

class MessengerPageState extends State<MessengerPage>
    with AutomaticKeepAliveClientMixin<MessengerPage> {
  @override
  void initState() {
    super.initState();
    listScrollController.addListener(scrollListener);
  }

  // ensures state is kept when switching pages
  @override
  bool get wantKeepAlive => true;

  final ScrollController listScrollController = ScrollController();

  int _limit = 20;
  int _limitIncrement = 20;
  bool isLoading = false;

  void scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    return Container(
      child: FlatButton(
        child: Row(
          children: <Widget>[
            Material(
              child: document.data()['photoUrl'] != ""
                  ? CircleAvatar(
                      backgroundImage:
                          NetworkImage(document.data()['photoUrl']),
                      radius: 25.0,
                    )
                  : Image.asset(
                      "assets/images/defaultProfileImage.png",
                      height: 50,
                      width: 50,
                    ),
              borderRadius: BorderRadius.all(Radius.circular(50.0)),
              clipBehavior: Clip.hardEdge,
            ),
            Flexible(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        document.data()['displayName'],
                        style: TextStyle(fontSize: 20),
                      ),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                    ),
                    ((document.data()['bio'] != "")
                        ? Container(
                            child: Text('About me: ${document.data()['bio']}'),
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                          )
                        : Container(
                            height: 0,
                          ))
                  ],
                ),
                margin: EdgeInsets.only(left: 20.0),
              ),
            ),
          ],
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Chat(
                        peerId: document.id,
                        peerAvatar: document.data()['photoUrl'],
                        peerName: document.data()['displayName'],
                      )));
        },
        color: appPrimaryLightColor,
        padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        title: Text("Message"),
        actions: [
          IconButton(
              icon: Icon(Icons.edit_rounded),
              padding: EdgeInsets.only(right: 10.0),
              onPressed: () {
                setState(() {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return SearchUserChat();
                    },
                  ));
                });
              }),
        ],
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            // List
            Container(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('chatWiths.${currentUserModel.id}', isEqualTo: true)
                    //.limit(_limit)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(appPrimaryColor),
                      ),
                    );
                  } else if (snapshot.data.docs.length == 0) {
                    return Center(
                      child: Text("You don't have any messages"),
                    );
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemBuilder: (context, index) =>
                          buildItem(context, snapshot.data.docs[index]),
                      itemCount: snapshot.data.docs.length,
                      controller: listScrollController,
                    );
                  }
                },
              ),
            ),

            // Loading
            Positioned(
              child: isLoading ? const Loading() : Container(),
            )
          ],
        ),
      ),
    );
  }
}
