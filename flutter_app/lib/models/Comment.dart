import 'package:flutter_app/models/AppUser.dart';

class Comment {
  String comment;
  AppUser appUser;
  DateTime dateOfComment;
  bool isLiked;
  Comment(this.appUser, this.comment, this.dateOfComment, this.isLiked);
}