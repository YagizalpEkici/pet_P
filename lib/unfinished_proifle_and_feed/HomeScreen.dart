import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_project/firestore_related/users.dart';
import 'package:pet_project/firestore_related/posts.dart';
import 'package:pet_project/firestore_related/users.dart';
import 'package:pet_project/unfinished_proifle_and_feed/mainfeedpost.dart';
//import 'package:pet_project/unfinished_proifle_and_feed/post.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_project/utils/auth.dart';
import 'package:pet_project/utils/colors.dart';
import 'package:pet_project/utils/dimensions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_project/routes/createPetProfile.dart';
import 'package:pet_project/routes/homePage.dart';
import 'package:pet_project/unfinished_proifle_and_feed/mainfeedpost.dart';

import 'navigation_drawer_widget.dart';



class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /*
  List<Post> myPostsmain = [
    Post(text: 'Hello World 1', date: '22.10.2021', likeCount: 10, commentCount: 5),
    Post(text: 'Hello World 2', date: '22.10.2021', likeCount: 20, commentCount: 10),
    Post(text: 'Hello World 3', date: '22.10.2021', likeCount: 30, commentCount: 15),
    Post(text: 'Hello World 4', date: '25.10.2021', likeCount: 40, commentCount: 20),
    Post(text: 'Hello World 5', date: '25.10.2021', likeCount: 50, commentCount: 25),
    Post(text: 'Hello World 6', date: '25.10.2021', likeCount: 60, commentCount: 30),
  ];

   */

  final ImagePicker _picker = ImagePicker();
  XFile? _image;


  Future pickImageCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = pickedFile;
    });
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

    currentPost= Post(
      username: username,
      pid : pid,
      comments: comments,
      likes: likes,
      content: content,
      userPhotoUrl: photoUrl,
      postPhotoURL: postPhotoURL,
      email: email,
      date: DateTime.now(),
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'FEED PAGE' ,
          ),
          centerTitle: true,
        ),

        drawer: NavigationDrawerWidget(),
        body:Padding(
          padding: Dimen.RegularPadding,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(onPressed: () {
                      Navigator.pushNamed(context, '/addphoto');
                    },
                      icon: Icon(Icons.add_photo_alternate),
                      label: Text('Add Photo'),
                    ),
                    SizedBox(
                      width: 9,
                    ),
                    ElevatedButton.icon(onPressed: pickImageCamera,
                      icon: Icon(Icons.add_a_photo),
                      label: Text('Take Photo'),
                    ),
                    SizedBox(
                      width: 9,
                    ),
                    /*
                    ElevatedButton.icon(onPressed: () {

                    },
                      icon: Icon(Icons.send),
                      label: Text('Status'),
                    ),
                    */
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                        height: 480, width: 379,
                        child: feedposts()),
                  ],
                )
              ],
            ),
          ),
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


  Widget feedScreen() {
    return Padding(
      padding: Dimen.RegularPadding,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton.icon(onPressed: () {

                },
                  icon: Icon(Icons.add_photo_alternate),
                  label: Text('Add Photo'),
                ),
                SizedBox(
                  width: 9,
                ),
                ElevatedButton.icon(onPressed: () {

                },
                  icon: Icon(Icons.add_a_photo),
                  label: Text('Take Photo'),
                ),
                SizedBox(
                  width: 9,
                ),
                ElevatedButton.icon(onPressed: () {

                },
                  icon: Icon(Icons.send),
                  label: Text('Status'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}