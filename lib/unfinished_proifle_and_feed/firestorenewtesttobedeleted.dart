/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pet_project/routes/homePage.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:pet_project/utils/colors.dart';
import 'package:pet_project/utils/dimensions.dart';

import 'package:uuid/uuid.dart';

var uuid = Uuid();



class addphoto extends StatefulWidget {
  const addphoto({Key? key}) : super(key: key);

  @override
  _addphotoState createState() => _addphotoState();
}

class _addphotoState extends State<addphoto> {

  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  user? currentUser;
  Post? currentPost;

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
  var pickedFile;

  String url = "";

  //var photoUrl = "https://firebasestorage.googleapis.com/v0/b/sinapps0.appspot.com/o/profilepictures%2FScreen%20Shot%202021-06-06%20at%2023.43.18.png?alt=media&token=6c28fb47-2924-4b74-a3d6-b47a3844fea0";

  // Controller error about post
  String error = "";
  String contentHint = 'Explain your case and include all necessary information.\n'
      'e.g. I encountered an very rare that and wanted to share my idea about that...';
  String titleHint = "Be spesific and give insight about your case.";
  bool errorHint = false;


  Future pickImageGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    });
  }
  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = basename(_image!.path);
    url = fileName;
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('uploads/$fileName');
    try {
      await firebaseStorageRef.putFile(File(_image!.path));
      print('upload compete');
      setState(() {
        _image = null;
      });
    } on FirebaseException catch(e) {
      print('ERROR: ${e.code} - ${e.message}');
    } catch(e){
      print(e.toString());
    }
  }
  String id = uuid.v4();


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
      postsUser=x.docs[0]['posts'];
      profType=x.docs[0]['profType'];

    });
  }
  void pageDirection() {
    Navigator.pushNamed(this.context, '/homePage');
  }


  Future<void> addPost(Post cPost) async {
    final CollectionReference posts = FirebaseFirestore.instance.collection('posts');
    //var post_ref = posts.doc();
    try {
      //
      await posts.doc(cPost.pid).set(cPost.toJson());
      print("null olmadı");
      //.then((value) => print("User Added"))
      //.catchError((error) => print("Failed to add user: $error"));
    } catch (e) {
      print("null oldu");
      return null;
    }
  }
  /*
  updateUserData() {
    setState(() {

    });
    FirebaseAuth _auth;
    User? _user;
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;

    FirebaseFirestore.instance
        .collection('user')
        .doc(_user?.email)
        .update({
      "posts": id,
    })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));

    SnackBar successSnackBar =
    SnackBar(content: Text("Profile has been updated."));
  }

   */


  @override
  void initState() {
    _loadUserInfo();
    //_loadPostInfo();
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

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
      appBar: AppBar(
        title: Text("Add new post"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Stack(
                      children: [
                        Center(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: ClipRRect(
                                //clipper: ,
                                borderRadius: BorderRadius.circular(10.0),
                                child: Container(
                                  child: getImage(),
                                ),
                              ),
                            )
                        ),
                      ],
                    ),
                  ),
                ]
            ),
            OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if(states.contains(MaterialState.pressed))
                      return Theme.of(context).colorScheme.primary.withOpacity(0.5);
                    return Colors.grey;
                  },
                ),
              ),
              onPressed: pickImageGallery,
              child: Text(
                'Upload a photo',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          decoration: InputDecoration(
                            fillColor: AppColors.app_icons,
                            filled: true,
                            hintText: "content",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.text_color,
                              ),
                              borderRadius: Dimen.Border,
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          onSaved: (value){
                            if(value != null){
                              content = value;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              child: Text('Post'),
              onPressed: () async{
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  if (_image != null) {
                    uploadImageToFirebase(context);
                  }
                  print("result öncesi");
                  var result = await FirebaseFirestore
                      .instance
                      .collection('posts')
                      .where(
                      'email', isEqualTo: email)
                      .get();
                  print(result.size);
                  if (result.size != 0) {
                    FirebaseAuth _auth;
                    _auth = FirebaseAuth.instance;
                    User? _user = _auth.currentUser;
                    print("result 0");
                    Post cPost = Post(
                      username: username,
                      content: content,
                      pid: id,
                      userPhotoUrl: url,
                      comments: [],
                      likes: [],
                      email: email,
                      postPhotoURL: pickedFile,
                      date: DateTime.now(),
                    );
                    addPost(cPost);
                    //updateUserData();
                    pageDirection();
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget getImage() {
    return _image != null ? Image.file(File(_image!.path)) :TextButton(
      child:
      Icon(
          Icons.add,
          color: Colors.blue,
          size:200
      ),
      onPressed: () {},
    );
  }

}
*/