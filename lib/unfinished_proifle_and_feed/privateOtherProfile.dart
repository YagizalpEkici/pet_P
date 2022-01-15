import 'dart:core';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_project/firestore_related/followClass.dart';
import 'package:pet_project/firestore_related/notifClass.dart';
import 'package:pet_project/firestore_related/reportclass.dart';
import 'package:pet_project/firestore_related/users.dart';
import 'package:pet_project/firestore_related/posts.dart';


import 'package:pet_project/unfinished_proifle_and_feed/navigation_drawer_widget.dart';
import 'package:uuid/uuid.dart';
var uuid = Uuid();

class otherprofilePage extends StatefulWidget {
  const otherprofilePage({Key? key}) : super(key: key);


  @override
  _otherprofilePageState createState() => _otherprofilePageState();
}

class _otherprofilePageState extends State<otherprofilePage> {

  int currentIndex = 0;
  void editProfile() {
    Navigator.pushNamed(context, '/editProfile');
  }

  void friendshipRequests() {
    Navigator.pushNamed(context, '/friendshipRequests');
  }

  String password="";
  String name="";
  String surname="";
  String petName="";
  String sex="";
  List<dynamic> followers = [];
  List<dynamic> following = [];
  String bio = "",
      username = "",
      breed = "",
      photoUrl = "",
      birthYear = "";
  List<dynamic> postsUser = [];
  bool profType=true;
  List<dynamic> posts = [];
  String email ="";

  DateTime? date;
  String postPhotoURL = "";
  List<dynamic> comments = [];
  List<dynamic> likes = [];
  String content = "";
  String pid = "";

  user? currentUser;
  Post? currentPost;










  void _loadUserInfo() async {
    FirebaseAuth _auth;
    User? _user;
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;
    var x = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: _user?.email)
        .get();

    setState(() {
      username = x.docs[0]['username'];
      password=x.docs[0]['password'];
      name=x.docs[0]['name'];
      surname=x.docs[0]['surname'];
      followers = x.docs[0]['followers'];
      following = x.docs[0]['following'];
      sex=x.docs[0]['sex'];
      petName=x.docs[0]['petName'];
      photoUrl = x.docs[0]['photoUrl'];
      bio = x.docs[0]['bio'];
      breed = x.docs[0]['breed'];
      birthYear = x.docs[0]['birthYear'];
      email=x.docs[0]['email'];
      posts=x.docs[0]['posts'];
      profType=x.docs[0]['profType'];

    });
  }
  bool feedLoading = true;
  int postsSize = 0;

  void _loadUserProf() async {

    FirebaseAuth _auth;
    User? _user;
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;

    var x = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: _user?.email)
        .get();


    var profPosts = await FirebaseFirestore.instance
        .collection('posts')
        .where('pid', isEqualTo: 'e48e32ef-39bf-414f-b0ce-c030055627dc')
        .get();

    postsSize = profPosts.size;
    username = profPosts.docs[0]['username'];
    pid = profPosts.docs[0]['pid'];
    date= DateTime.fromMillisecondsSinceEpoch(profPosts.docs[0]['date'].seconds * 1000);
    photoUrl= profPosts.docs[0]['userPhotoUrl'];
    content= profPosts.docs[0]['content'];
    email= profPosts.docs[0]['email'];
    comments= profPosts.docs[0]['comments'];
    likes= profPosts.docs[0]['likes'];
    postPhotoURL= profPosts.docs[0]['postPhotoURL'];


    //posts..sort((a, b) => b.date.compareTo(a.date));
    setState(() {
      print("its in");
      feedLoading = false;
    });
  }

/*
  void _loadUserProf() async {

    FirebaseAuth _auth;
    User? _user;
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;

    var x = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: _user?.email)
        .get();

    username = x.docs[0]['username'];
    followers = x.docs[0]['followers'];
    following = x.docs[0]['following'];
    photoUrl = x.docs[0]['photoUrl'];
    bio = x.docs[0]['bio'];
    profType = x.docs[0]['profType'];

    var profPosts = await FirebaseFirestore.instance
        .collection('posts')
        .where('email', isEqualTo: _user?.email)
        .get();

    postsSize = profPosts.size;
    profPosts.docs.forEach((doc) =>
    {
      posts.add(
          Post(
              username: doc['username'],
              userPhotoUrl: doc['userPhotoUrl'],
              postPhotoURL: doc['postPhotoURL'],
              email: doc['email'],
              pid: doc['pid'],
              content: doc['content'],
              date: DateTime.fromMillisecondsSinceEpoch(doc['date'].seconds * 1000),
              likes: doc['likes'],
              comments: doc['comments'],

              isLiked: doc['likes'].contains(_user?.email) ? true : false //TODO: error olabilir
          )
      )
    });

    posts..sort((a, b) => b.date.compareTo(a.date));
    setState(() {
      print("its in");
      feedLoading = false;
    });
  }
*/

  String id = uuid.v4();

  Future<void> addFollow(followClass follow) async {
    final CollectionReference folllowRequests = FirebaseFirestore.instance.collection('followRequest');
    //var post_ref = posts.doc();
    try {
      //
      await folllowRequests.doc(follow.pid).set(follow.toJson());
      print("null olmadı");
      //.then((value) => print("User Added"))
      //.catchError((error) => print("Failed to add user: $error"));
    } catch (e) {
      print("null oldu");
      return null;
    }
  }

  Future<void> addNotif(notifClass notif) async {
    final CollectionReference notifs = FirebaseFirestore.instance.collection('notification');
    //var post_ref = posts.doc();
    try {
      //
      await notifs.doc(notif.pid).set(notif.toJson());
      print("null olmadı");
      //.then((value) => print("User Added"))
      //.catchError((error) => print("Failed to add user: $error"));
    } catch (e) {
      print("null oldu");
      return null;
    }
  }

  void report(String reportedMail) async {
    final CollectionReference reports = FirebaseFirestore.instance.collection('reports');
    //var post_ref = posts.doc();
    //try {
      reportclass newreport = reportclass(
        pid: id,
        reportedMail: reportedMail
      );
      //
      await reports.doc(newreport.pid).set(newreport.toJson());
      print("null olmadı");
      //.then((value) => print("User Added"))
      //.catchError((error) => print("Failed to add user: $error"));
    //} catch (e) {
      //print("null oldu");
      //return null;
    //}
  }


  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _loadUserProf();
  }

  @override
  Widget build(BuildContext context) {
    currentUser = user(
      username: username,
      name: name,
      surname: surname,
      followers: followers,
      following: following,
      password: password,
      posts: posts,
      bio: bio,
      photoUrl: photoUrl,
      profType: profType,
      email:email,
      petName: petName,
      birthYear: birthYear,
      sex: sex,
      breed: breed,

    );


    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.green,

        title: Text(
          currentUser!.username,
          style: TextStyle(
            color: Colors.black,
            letterSpacing: -1,
            fontSize: 20,
          ),
        ),

        actions: [


          IconButton(onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Report User'),
              content: const Text('You are about to report this user, are you sure? Contact us for further inquiry.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    final CollectionReference reports = FirebaseFirestore.instance.collection('reports');
                    reportclass newreport = reportclass(
                        pid: id,
                        reportedMail: 'a'
                    );
                    //
                    await reports.doc(newreport.pid).set(newreport.toJson());
                    print("null olmadı");
                    Navigator.pop(context, 'Yes');
                  },
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'No');
                  },
                  child: const Text('No'),
                ),
              ],
            ),
          ),

            /*
                  AlertDialog(
                    title: Text('ŞŞŞŞŞ Accountu siliyosun'),
                    actions: [
                      FlatButton(onPressed: (){}, child: Text('Yes')),
                      FlatButton(onPressed: (){}, child: Text('No'))
                    ],
                  );
                  */

            icon: Icon(Icons.report),
            )
        ],

        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Text('Follower',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                              ],
                            ),
                            Chip(
                              label:
                              Container(
                                child: Text(
                                  '${followers.length}',
                                  textAlign: TextAlign.center,
                                ),
                                width: 80,
                                height: 20,
                              ),
                            ),
                            SizedBox(height: 15,),
                            Row(
                              children: [
                                Text('Breed',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),),
                              ],
                            ),
                            Chip(
                              label:
                              Container(
                                child: Text(
                                  '${breed}',
                                  textAlign: TextAlign.center,
                                ),
                                width: 90,
                                height: 20,
                              ),
                            ),
                          ],

                        ),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(currentUser!.photoUrl),
                            radius: 56,
                          ),

                        ),

                        Column(
                          children: [
                            Row(
                              children: [
                                Text('Following',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),),
                              ],
                            ),
                            Chip(
                              label:
                              Container(
                                child: Text(
                                  '${following.length}',
                                  textAlign: TextAlign.center,
                                ),
                                width: 80,
                                height: 20,
                              ),
                            ),
                            SizedBox(height: 15,),
                            Row(
                              children: [
                                Text('BirthYear',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Chip(
                              label:
                              Container(
                                child: Text(
                                  '${birthYear}',
                                  textAlign: TextAlign.center,
                                ),
                                width: 80,
                                height: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Bio',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 17,),
                        ElevatedButton(onPressed: (){},
                          child: Text('Message'),),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                          child: Card(
                            margin: EdgeInsets.fromLTRB(58, 8, 70, 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),),
                            color: Colors.grey[300],
                            elevation: 8,
                            child: Column(
                              children: [

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${bio}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,

                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 0,),
                        ElevatedButton(onPressed: ()async{

                              followClass newfollow = followClass(
                                senderMail: email,
                                senderusername: username,
                                userMail: '',
                                  pid: id
                              );
                              notifClass newnotif = notifClass(
                                  Photoid: '',
                                  userName: '',
                                  type: 'follow',
                                  userMail: '',
                                  senderMail: email,
                                  pid: id,
                              sendername: username);

                              addFollow(newfollow);
                              addNotif(newnotif);
                        },
                          child: Text('Follow'),)
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Divider(thickness: 4,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                SizedBox(width: 75,),
                IconButton(
                    onPressed: (){},
                    icon: Icon(Icons.lock),
                ),
                Text('This account is private.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                  ),),
              ],
            ),
            Text('Follow this account to see their posts.')
          ],
        ),
      ),
    );
  }


  Widget feedposts() {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text(currentPost!.username),
            subtitle: Text(
              ('$date'),
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              currentPost!.content,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),

          Image.asset('assets/image1.jpg'),
          ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
                icon: Icon(Icons.thumb_up),
                onPressed: () {
                  // Perform some action
                },
                label: const Text('Like'),
              ),

              ElevatedButton.icon(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
                icon: Icon(Icons.comment),
                onPressed: () {
                  // Perform some action
                },
                label: const Text('Comment'),
              ),

              ElevatedButton.icon(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
                icon: Icon(Icons.share),
                onPressed: () {
                  // Perform some action
                },
                label: const Text('Share'),

              ),
            ],
          ),
        ],
      ),
    );
  }

}