import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Post {
  String username;
  String pid;
  String email;
  DateTime date;
  String userPhotoUrl;
  String content;
  String postPhotoURL;
  List<dynamic> comments;
  List<dynamic> likes;

  bool isLiked;

  Post(
      {required this.username,
        required this.email,
        required this.pid,
        required this.userPhotoUrl,
        required this.content,
        required this.date,
        required this.comments,
        required this.likes,
        this.isLiked=false,
        required this.postPhotoURL}
      );

  Post.fromData(Map<String, dynamic> data)
      : username = data['username'],
        pid = data['pid'],
        comments = data['comments'],
        likes = data['likes'],
        content = data['content'],
        userPhotoUrl = data['userPhotoUrl'],
        postPhotoURL = data['postPhotoURL'],
        email = data['email'],
        date = data['date'],
        isLiked = data['isLiked'];

  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      username: doc['username'],
      pid: doc['pid'],
      date: DateTime.fromMillisecondsSinceEpoch(doc['date'].seconds * 1000),
      userPhotoUrl: doc['userPhotoURL'],
      content: doc['content'],
      email: doc['email'],
      comments: doc['comments'],
      likes: doc['likes'],
      postPhotoURL: doc['postPhotoURL'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'pid' : pid,
      'comments': comments,
      'likes': likes,
      'content': content,
      'userPhotoUrl': userPhotoUrl,
      'postPhotoURL': postPhotoURL,
      'email': email,
      'date': date,
    };
  }

}