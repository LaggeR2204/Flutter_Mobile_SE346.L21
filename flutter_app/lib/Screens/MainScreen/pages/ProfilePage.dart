import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/AppUser.dart';
import 'package:flutter_app/Screens/MainScreen/pages/SettingPage.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/Screens/MainScreen/pages/EditProfilePage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({this.userId});

  final String userId;

  @override
  ProfilePageState createState() => ProfilePageState(this.userId);
}

class ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage> {
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
    FirebaseFirestore.instance.collection('users').doc(currentUserId).get().then((querySnapshot) {
      setState(() {
        userName = querySnapshot['displayName'];
      });
    });
  }

  // Future<String> getCurrentUserUID() async{
  //   User user = FirebaseAuth.instance.currentUser;
  //   return user.uid;
  // }

    EditProfilePage editPage = new EditProfilePage();
  openEditProfilePage(){

    // Navigator.of(context)
    //     .push(MaterialPageRoute<bool>(builder: (BuildContext context) {
    //   return editPage;
    // }));
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) {
          return editPage;
        },
      )
    );
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
    // FirebaseFirestore.instance
    //     .collection("insta_a_feed")
    //     .doc(profileId)
    //     .collection("items")
    //     .doc(currentUserId)
    //     .set({
    //   "ownerId": profileId,
    //   "username": FirebaseAuth.instance.currentUser.displayName,
    //   "userId": currentUserId,
    //   "type": "follow",
    //   "userProfileImg": FirebaseAuth.instance.currentUser.photoURL,
    //   "timestamp": DateTime.now()
    // });
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

    // FirebaseFirestore.instance
    //     .collection("insta_a_feed")
    //     .doc(profileId)
    //     .collection("items")
    //     .doc(currentUserId)
    //     .delete();
  }

  changeView(String viewName) {
    setState(() {
      view = viewName;
    });
  }

  int _countFollowings(Map followings) {
    int count = 0;

    void countValues(key, value) {
      if (value) {
        count += 1;
      }
    }

    followings.forEach(countValues);

    return count;
  }

  // ensures state is kept when switching pages
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // reloads state when opened again

    Column buildStatColumn(String label, int number) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            number.toString(),
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          ),
          Container(
              margin: const EdgeInsets.only(top: 4.0),
              child: Text(
                label,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400),
              ))
        ],
      );
    }

    Container buildFollowButton(
        {String text,
        Color backgroundcolor,
        Color textColor,
        Color borderColor,
        Function function}) {
      return Container(
        padding: EdgeInsets.only(top: 2.0),
        child: FlatButton(
            onPressed: function,
            child: Container(
              decoration: BoxDecoration(
                  color: backgroundcolor,
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(5.0)),
              alignment: Alignment.center,
              child: Text(text,
                  style: TextStyle(
                      color: textColor, fontWeight: FontWeight.bold)),
              width: 250.0,
              height: 27.0,
            )),
      );
    }

    Container buildProfileFollowButton(BuildContext _context) {
      // viewing your own profile - should show edit button
      if (currentUserId == profileId) {
        print("Build edit button");
        return buildFollowButton(
          text: "Edit Profile",
          backgroundcolor: Colors.white,
          textColor: Colors.black,
          borderColor: Colors.grey,
          function: openEditProfilePage,
        );
      }

      // already following user - should show unfollow button
      if (isFollowing) {
        return buildFollowButton(
          text: "Unfollow",
          backgroundcolor: Colors.white,
          textColor: Colors.black,
          borderColor: Colors.grey,
          function: unfollowUser,
        );
      }

      // does not follow user - should show follow button
      if (!isFollowing) {
        return buildFollowButton(
          text: "Follow",
          backgroundcolor: Colors.blue,
          textColor: Colors.white,
          borderColor: Colors.blue,
          function: followUser,
        );
      }

      return buildFollowButton(
          text: "loading...",
          backgroundcolor: Colors.white,
          textColor: Colors.black,
          borderColor: Colors.grey);
    }

    Row buildImageViewButtonBar() {
      Color isActiveButtonColor(String viewName) {
        if (view == viewName) {
          return appPrimaryColor2;
        } else {
          return Colors.black26;
        }
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.grid_on, color: isActiveButtonColor("grid")),
            onPressed: () {
              changeView("grid");
            },
          ),
          IconButton(
            icon: Icon(Icons.list, color: isActiveButtonColor("feed")),
            onPressed: () {
              changeView("feed");
            },
          ),
        ],
      );
    }

//     Container buildUserPosts() {
//       Future<List<ImagePost>> getPosts() async {
//         List<ImagePost> posts = [];
//         var snap = await FirebaseFirestore.instance
//             .collection('insta_posts')
//             .where('ownerId', isEqualTo: profileId)
//             .orderBy("timestamp")
//             .get();
//         for (var doc in snap.docs) {
//           posts.add(ImagePost.fromDocument(doc));
//         }
//         setState(() {
//           postCount = snap.docs.length;
//         });

//         return posts.reversed.toList();
//       }

//       return Container(
//           child: FutureBuilder<List<ImagePost>>(
//         future: getPosts(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData)
//             return Container(
//                 alignment: FractionalOffset.center,
//                 padding: const EdgeInsets.only(top: 10.0),
//                 child: CircularProgressIndicator());
//           else if (view == "grid") {
//             // build the grid
//             return GridView.count(
//                 crossAxisCount: 3,
//                 childAspectRatio: 1.0,
// //                    padding: const EdgeInsets.all(0.5),
//                 mainAxisSpacing: 1.5,
//                 crossAxisSpacing: 1.5,
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 children: snapshot.data.map((ImagePost imagePost) {
//                   return GridTile(child: ImageTile(imagePost));
//                 }).toList());
//           } else if (view == "feed") {
//             return Column(
//                 children: snapshot.data.map((ImagePost imagePost) {
//               return imagePost;
//             }).toList());
//           }
//         },
//       ));
//     }

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(profileId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Container(
                alignment: FractionalOffset.center,
                child: CircularProgressIndicator());

          //print("[SNAPSHOT DATA ] "+ snapshot.data['displayName'].toString());
          AppUser user = AppUser.fromDocument(snapshot.data);

          if (user.followers.containsKey(currentUserId) &&
              user.followers[currentUserId] &&
              followButtonClicked == false) {
            isFollowing = true;
          }

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
              body: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            (user.photoUrl != "")?
                            CircleAvatar(
                              radius: 40.0,
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(user.photoUrl),
                            )
                            :
                            Image.asset(
                              "assets/images/defaultProfileImage.png",
                              width: 90,
                              height: 90,
                              fit: BoxFit.fitHeight
                            ),
                            
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      buildStatColumn("posts", postCount),
                                      buildStatColumn("followers",
                                           _countFollowings(user.followers)),
                                      buildStatColumn("following",
                                           _countFollowings(user.following)),
                                    ],
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        buildProfileFollowButton(context),
                                        // TextButton(onPressed: (){
                                        //   Navigator.of(context)
                                        //       .push(MaterialPageRoute<bool>(builder: (BuildContext context) {
                                        //     return editPage;
                                        //   }));
                                        // }, 
                                        // child: Text("button edit profile test"))
                                      ]),
                                ],
                              ),
                            )
                          ],
                        ),
                        Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Text(
                              user.bio,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                      ],
                    ),
                  ),
                  Divider(),
                  buildImageViewButtonBar(),
                  Divider(height: 0.0),
                  //buildUserPosts(),
                ],
              ));
        });
  }
}

void openProfile(BuildContext context, String userId) {
  Navigator.of(context)
      .push(MaterialPageRoute<bool>(builder: (BuildContext context) {
    return ProfilePage(userId: userId);
  }));
}