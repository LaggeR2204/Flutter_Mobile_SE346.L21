import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String email;
  final String id;
  final String photoUrl;
  final String displayName;
  final String bio;
  final Map followers;
  final Map following;
  final Map chatWiths;

  const AppUser(
      {this.id,
      this.photoUrl,
      this.email,
      this.displayName,
      this.bio,
      this.followers,
      this.following,
      this.chatWiths,
      });

  factory AppUser.fromDocument(DocumentSnapshot document) {
    return AppUser(
        email: document['email'],
        photoUrl: document['photoUrl'],
        id: document.id,
        displayName: document['displayName'],
        bio: document['bio'],
        followers: document['followers'],
        following: document['following'],
        chatWiths: document['chatWiths'])
    ;
  }
  factory AppUser.fromMap(Map<String, dynamic> data){
    return AppUser(
      email: data['email'],
      photoUrl: data['photoUrl'],
      id: data['id'],
      displayName: data['displayName'],
      bio: data['bio'],
      followers: data['followers'],
      following: data['following'],
      chatWiths: data['chatWiths']
    );
  }
}