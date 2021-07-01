import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/Screens/MainScreen/pages/ProfilePage.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/models/Post.dart';

class SearchPage extends StatefulWidget {
  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage>
    with TickerProviderStateMixin<SearchPage> {
  final double appBarHeight = AppBar().preferredSize.height;
  TabController _tabController;
  String searchHintText;
  TextEditingController _searchTermController;
  String searchTerm = "";

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    _searchTermController = new TextEditingController();
    _tabController.addListener(TabControllerListener);
    _searchTermController.addListener(SearchControllerListener);
    searchHintText = 'Search';
    super.initState();
  }

  @override
  void dispose() {
    _searchTermController.removeListener(SearchControllerListener);
    _tabController.removeListener(TabControllerListener);
    super.dispose();
  }

  SearchControllerListener() {
    print('[LISTENER]');
    setState(() {
      searchTerm = _searchTermController.value.text;
    });
  }

  TabControllerListener() {
    if (_tabController.indexIsChanging) {
      _searchTermController.clear();
    }

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

  Container buildSearchResult() {
    final Size size = MediaQuery.of(context).size;
    QuerySnapshot temp;

    if (_tabController.index == 1) {
      // search accounts
      return Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .where("displayName", isGreaterThanOrEqualTo: searchTerm)
              .snapshots(),
          builder: (context, snapshot) {
            return (searchTerm == "")
                ? Center(
                    child: Text("Looking for soneone"),
                  )
                : (snapshot.connectionState == ConnectionState.waiting)
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot doc = snapshot.data.docs[index];
                          var data = doc.data();
                          return FlatButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ProfilePage(userId: data['id']);
                                }));
                              },
                              child: Column(children: <Widget>[
                                SizedBox(
                                  height: size.height * 0.01,
                                ),
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: (data['photoUrl'] != "") ? 25 : 20,
                                    ),
                                    (data['photoUrl'] != "")
                                        ? CircleAvatar(
                                            radius: size.width * 0.06,
                                            backgroundImage:
                                                NetworkImage(data['photoUrl']),
                                          )
                                        : Image.asset(
                                            "assets/images/defaultProfileImage.png",
                                            width: size.width * 0.14,
                                            height: size.width * 0.14,
                                            fit: BoxFit.fitHeight),
                                    SizedBox(
                                      width: (data['photoUrl'] != "") ? 25 : 20,
                                    ),
                                    Text(
                                      data['displayName'],
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.01,
                                ),
                              ]));
                        },
                      );
          },
        ),
      );
    } else if (_tabController.index == 2) {
      //search places
      return Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("posts")
              .where("location", isGreaterThanOrEqualTo: searchTerm)
              //.orderBy("likes", )
              .snapshots(),
          builder: (context, snapshot) {
            return (searchTerm == "")
                ? Center(
                    child: Text("Looking for somewhere"),
                  )
                : (snapshot.connectionState == ConnectionState.waiting)
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot doc = snapshot.data.docs[index];
                          var data = doc.data();
                          return FlatButton(
                              onPressed: () {
                                // ImagePost temp = ImagePost.fromDocument(doc);
                                // Navigator.of(context).push(
                                //     MaterialPageRoute<bool>(
                                //         builder: (BuildContext context) {
                                //   return Center(
                                //     child: Scaffold(
                                //         appBar: AppBar(
                                //           automaticallyImplyLeading: true,
                                //           brightness: Brightness.dark,
                                //           flexibleSpace: Container(
                                //             decoration: BoxDecoration(
                                //               gradient: LinearGradient(
                                //                 begin: Alignment.centerLeft,
                                //                 end: Alignment.centerRight,
                                //                 colors: <Color>[
                                //                   appPrimaryColor,
                                //                   appPrimaryColor2
                                //                 ],
                                //               ),
                                //             ),
                                //           ),
                                //           title: Text('Photo'),
                                //         ),
                                //         body: ListView(
                                //           children: <Widget>[
                                //             Container(
                                //               child: temp,
                                //             ),
                                //           ],
                                //         )),
                                //   );
                                // }));
                              },
                              child: Column(children: <Widget>[
                                SizedBox(
                                  height: size.height * 0.01,
                                ),
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: (data['mediaUrl'] != "") ? 25 : 20,
                                    ),
                                    (data['mediaUrl'] != "")
                                        ? CircleAvatar(
                                            radius: size.width * 0.06,
                                            backgroundImage:
                                                NetworkImage(data['mediaUrl']),
                                          )
                                        : Image.asset(
                                            "assets/images/defaultProfileImage.png",
                                            width: size.width * 0.14,
                                            height: size.width * 0.14,
                                            fit: BoxFit.fitHeight),
                                    SizedBox(
                                      width: (data['mediaUrl'] != "") ? 25 : 20,
                                    ),
                                    // Text(
                                    //   data['ownerId'],
                                    //   style: TextStyle(
                                    //       fontSize: 20,
                                    //       fontWeight: FontWeight.normal),
                                    // ),
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.01,
                                ),
                              ]));
                        },
                      );
          },
        ),
      );
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
            controller: _searchTermController,
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
      body: buildSearchResult(),
      // body: TabBarView(
      //   controller: _tabController,
      //   children: [
      //     Center(
      //       child: Text("search recent"),
      //     ),

      //     Center(
      //       child: Text("search places"),
      //     ),
      //   ],
      // ),
    );
  }

  Widget buildSearchAccountsPage(BuildContext context, String searchTerm) {
    final Size size = MediaQuery.of(context).size;
    if (searchTerm != "" && searchTerm != null) {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            //.where("id", isNotEqualTo: currentUserModel.id)
            .where("displayName", isGreaterThanOrEqualTo: searchTerm)
            .snapshots(),
        builder: (context, snapshot) {
          return (snapshot.connectionState == ConnectionState.waiting)
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = snapshot.data.docs[index];
                    var data = doc.data();
                    return FlatButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ProfilePage(userId: data['id']);
                          }));
                        },
                        // Navigator.push(context, MaterialPageRoute(builder: (context) {
                        //   return Chat(
                        //       peerId: data['id'],
                        //       peerAvatar: data['photoUrl'],
                        //       peerName: data['displaynName']); //Mở tin nhắn của user này
                        // })),
                        child: Column(children: <Widget>[
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: (data['photoUrl'] != "") ? 25 : 20,
                              ),
                              (data['photoUrl'] != "")
                                  ? CircleAvatar(
                                      radius: size.width * 0.06,
                                      backgroundImage:
                                          NetworkImage(data['photoUrl']),
                                    )
                                  : Image.asset(
                                      "assets/images/defaultProfileImage.png",
                                      width: size.width * 0.14,
                                      height: size.width * 0.14,
                                      fit: BoxFit.fitHeight),
                              SizedBox(
                                width: (data['photoUrl'] != "") ? 25 : 20,
                              ),
                              Text(
                                data['displayName'],
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                        ]));
                  },
                );
        },
      );
    } else {
      return Container();
    }
  }
}
