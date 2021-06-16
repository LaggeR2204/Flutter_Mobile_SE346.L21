import 'package:flutter/material.dart';
import 'package:flutter_app/models/AppUser.dart';
import 'package:flutter_app/models/Comment.dart';

class Post {
  Image image;
  String description;
  AppUser appUser;
  List<AppUser> likes;
  List<Comment> comments;
  DateTime date;
  bool isLiked;
  Post(this.image, this.appUser, this.description, this.date, this.likes, this.comments, this.isLiked);
}