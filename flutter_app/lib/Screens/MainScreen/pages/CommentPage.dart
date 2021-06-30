import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "dart:async";
import '../../../main.dart';


class CommentPage extends StatefulWidget {
  final String postId;
  final String postOwner;
  final String postMediaUrl;

  const CommentPage({this.postId, this.postOwner, this.postMediaUrl});
  @override
  _CommentPageState createState() => _CommentPageState(
      postId: this.postId,
      postOwner: this.postOwner,
      postMediaUrl: this.postMediaUrl);
}

class _CommentPageState extends State<CommentPage> {
  final String postId;
  final String postOwner;
  final String postMediaUrl;

  bool didFetchComments = false;
  List<Comment> fetchedComments = [];

  final TextEditingController _commentController = TextEditingController();

  _CommentPageState({this.postId, this.postOwner, this.postMediaUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Comments",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: buildPage(),
    );
  }

  Widget buildPage() {
    return Column(
      children: [
        Expanded(
          child:
          buildComments(),
        ),
        Divider(),
        ListTile(
          title: TextFormField(
            controller: _commentController,
            decoration: InputDecoration(labelText: 'Write a comment...'),
            onFieldSubmitted: addComment,
          ),
          trailing: OutlineButton(onPressed: (){addComment(_commentController.text);}, borderSide: BorderSide.none, child: Text("Post"),),
        ),
      ],
    );
  }


  Widget buildComments() {
    if (this.didFetchComments == false){
      return FutureBuilder<List<Comment>>(
          future: getComments(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Container(
                  alignment: FractionalOffset.center,
                  child: CircularProgressIndicator());

            this.didFetchComments = true;
            this.fetchedComments = snapshot.data;
            return ListView(
              children: snapshot.data,
            );
          });
    } else {
      // for optimistic updating
      return ListView(
          children: this.fetchedComments
      );
    }
  }

  Future<List<Comment>> getComments() async {
    List<Comment> comments = [];

    QuerySnapshot data = await FirebaseFirestore.instance
        .collection("insta_comments")
        .doc(postId)
        .collection("comments")
        .get();
    data.docs.forEach((DocumentSnapshot doc) {
      comments.add(Comment.fromDocument(doc));
    });
    return comments;
  }

  addComment(String comment) {
    _commentController.clear();
    FirebaseFirestore.instance
        .collection("comments")
        .doc(postId)
        .collection("comments_in_post")
        .add({
      "comment": comment,
      "timestamp": Timestamp.now(),
      "avatarUrl": currentUserModel.photoUrl,
      "userId": currentUserModel.id
    });

    //adds to postOwner's activity feed
    FirebaseFirestore.instance
        .collection("feed")
        .doc(postOwner)
        .collection("items")
        .add({
      "userId": currentUserModel.id,
      "type": "comment",
      "userProfileImg": currentUserModel.photoUrl,
      "commentData": comment,
      "timestamp": Timestamp.now(),
      "postId": postId,
      "mediaUrl": postMediaUrl,
    });

    // add comment to the current listview for an optimistic update
    setState(() {
      fetchedComments = List.from(fetchedComments)..add(Comment(
          comment: comment,
          timestamp: Timestamp.now(),
          avatarUrl: currentUserModel.photoUrl,
          userId: currentUserModel.id
      ));
    });
  }
}

class Comment extends StatelessWidget {
  final String username;
  final String userId;
  final String avatarUrl;
  final String comment;
  final Timestamp timestamp;

  Comment(
      {this.username,
        this.userId,
        this.avatarUrl,
        this.comment,
        this.timestamp});

  factory Comment.fromDocument(DocumentSnapshot document) {
    var data = document.data();
    return Comment(
      username: data['username'],
      userId: data['userId'],
      comment: data["comment"],
      timestamp: data["timestamp"],
      avatarUrl: data["avatarUrl"],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(comment),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(avatarUrl),
          ),
        ),
        Divider(),
      ],
    );
  }
}
