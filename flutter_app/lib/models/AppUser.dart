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
  final List<String> searchRecent;
  final String chattingWith;

  const AppUser(
      {this.id,
      this.photoUrl,
      this.email,
      this.displayName,
      this.bio,
      this.followers,
      this.following,
      this.chatWiths,
      this.searchRecent,
      this.chattingWith});

  factory AppUser.changeChattingWith(AppUser currentUser, String chattingWith) {
    return AppUser(
        email: currentUser.email,
        photoUrl: currentUser.photoUrl,
        id: currentUser.id,
        displayName: currentUser.displayName,
        bio: currentUser.bio,
        followers: currentUser.followers,
        following: currentUser.following,
        chatWiths: currentUser.chatWiths,
        chattingWith: chattingWith,
        searchRecent: currentUser.searchRecent);
  }

  factory AppUser.fromDocument(DocumentSnapshot document) {
    return AppUser(
        email: document['email'],
        photoUrl: document['photoUrl'],
        id: document.id,
        displayName: document['displayName'],
        bio: document['bio'],
        followers: document['followers'],
        following: document['following'],
        chatWiths: document['chatWiths'],
        chattingWith: document['chattingWith'],
        searchRecent: List.from(document['searchRecent']));
  }
  factory AppUser.fromMap(Map<String, dynamic> data) {
    return AppUser(
        email: data['email'],
        photoUrl: data['photoUrl'],
        id: data['id'],
        displayName: data['displayName'],
        bio: data['bio'],
        followers: data['followers'],
        following: data['following'],
        chatWiths: data['chatWiths'],
        chattingWith: data['chattingWith'],
        searchRecent: List.from(data['searchRecent']));
  }
}
