import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/constants.dart';

class SearchUserChat extends StatefulWidget {
  @override
  _SearchUserChatState createState() => _SearchUserChatState();
}

class _SearchUserChatState extends State<SearchUserChat> {
  String searchTerm = "";

  void getSearchTerm(String value) {
    searchTerm = value.trim();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double appBarHeight = AppBar().preferredSize.height;
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
          automaticallyImplyLeading: true,
          title: Container(
            height: appBarHeight * 0.8,
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: appPrimaryLightColor,
              borderRadius: BorderRadius.circular(29),
            ),
            child: TextField(
              autofocus: true,
              onChanged: (value) {
                getSearchTerm(value);
              },
              cursorColor: appPrimaryColor,
              decoration: InputDecoration(
                hintStyle: TextStyle(fontSize: appBarHeight * 0.3),
                hintText: 'Search for a user...',
                suffixIcon: Icon(Icons.search),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(left: 15, bottom: 10, top: 10, right: 15),
              ),
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: (searchTerm != "" && searchTerm != null)
              ? FirebaseFirestore.instance
                  .collection("users")
                  .where("displayName", isGreaterThanOrEqualTo: searchTerm)
                  .snapshots()
              : FirebaseFirestore.instance.collection("users").snapshots(),
          builder: (context, snapshot) {
            return (snapshot.connectionState == ConnectionState.waiting)
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot data = snapshot.data.docs[index];
                      return SearchUserCard(size: size, data: data);
                    },
                  );
          },
        ));
  }
}

class SearchUserCard extends StatelessWidget {
  const SearchUserCard({
    Key key,
    @required this.size,
    @required this.data,
  }) : super(key: key);

  final Size size;
  final DocumentSnapshot data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => print(data['id']),
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
                      backgroundImage: NetworkImage(data['photoUrl']),
                    )
                  : Image.asset("assets/images/defaultProfileImage.png",
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
                ),
              ),
            ],
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
        ]));
  }
}
