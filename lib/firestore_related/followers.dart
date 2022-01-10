/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_project/firestore_related/users.dart';


class Followers extends StatefulWidget {
  const Followers({required Key key, required this.currentUser}) : super(key: key);
  final user currentUser;

  @override
  _FollowersState createState() => _FollowersState();
}

class _FollowersState extends State<Followers> {
  String mail;
  String name;
  String message;


  noResultsFound(context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              "No Followers found!",
              style: TextStyle(
                fontFamily: 'BrandonText',
                fontSize: 24.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            width: double.infinity,
          )
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    mail = widget.currentUser.email;
    var otherUserMails = widget.currentUser.following;
    FirebaseAuth _auth;
    User? _user;
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Followers",
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[800],
        elevation: 0.0,
      ),
      body: (otherUserMails.length == 0) ? noResultsFound(context) : StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("user")
            .where("email", whereIn: widget.currentUser.followers)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            //crashlytics
            return Text("Error: ${snapshot.error}");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            //crashlytics
            return Text("Loading...");
          }
          // ListView

          return ListView(
            children: snapshot.data.docs
                .map((doc) => Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(doc["photoUrl"]),
                    backgroundColor: Colors.black,
                  ),
                  horizontalTitleGap: 25.0,

                  title: Text(doc["username"],
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                  onTap: () {
                    if (doc['email'] == _user.uid) {
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Profile()));
                    }
                    else {
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  OtherProfilePage(otherUser: user.fromDocument(doc))));
                    }
                  },
                )))
                .toList(),
          );
        },
      ),
    );
  }
}

 */