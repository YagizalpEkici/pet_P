import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_project/firestore_related/users.dart';
import 'package:pet_project/routes/loginpage.dart';
import 'package:pet_project/unfinished_proifle_and_feed/post.dart';
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



class options extends StatefulWidget {
  const options({Key? key}) : super(key: key);


  @override
  State<options> createState() => _optionsState();
}

class _optionsState extends State<options> {
  bool isSwitched = false;
  AuthService auth = AuthService();



  String userMail = "";
  String senderId = "";
  String type = "";
  String postId = "";
  String userName = "";
  String fullName = "";
  String photoURL = "";
  String activation = "";
  String surname = "";
  List<dynamic> followers = [];
  String password = "";
  List<dynamic> following = [];
  List<dynamic> posts = [];
  String bio = "";
  String petName = "";
  String birthYear = "";
  String sex = "";
  String breed = "";




  user? currentUser;
  bool profType = true;


  void _loadtheuser() async{
    FirebaseAuth _auth;
    User _user;
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser!;

    var dbUserGetter = await FirebaseFirestore.instance.collection('user').where('email', isEqualTo: _user.email).get();


    setState(() {
      userName = dbUserGetter.docs[0]['username'];
      //print(userName);
      fullName = dbUserGetter.docs[0]['name'];
      photoURL = dbUserGetter.docs[0]['photoUrl'];
      userMail = dbUserGetter.docs[0]['email'];
      profType = dbUserGetter.docs[0]['profType'];
      surname = dbUserGetter.docs[0]['surname'];
      followers = dbUserGetter.docs[0]['followers'];
      password = dbUserGetter.docs[0]['password'];
      following = dbUserGetter.docs[0]['following'];
      posts = dbUserGetter.docs[0]['posts'];
      bio = dbUserGetter.docs[0]['bio'];
      petName = dbUserGetter.docs[0]['petName'];
      birthYear = dbUserGetter.docs[0]['birthYear'];
      sex = dbUserGetter.docs[0]['sex'];
      breed = dbUserGetter.docs[0]['breed'];
    });
  }


  changeProfType(bool ifso) {
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
      "profType": ifso,
    })

        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));




    SnackBar successSnackBar =
    SnackBar(content: Text("Profile has been updated."));
  }

  deactivateAccount() {
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
      "activation": false,
    })

        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));




    SnackBar successSnackBar =
    SnackBar(content: Text("Profile has been updated."));
  }




  final AuthService _auth = AuthService();

  @override

  void initState(){
    super.initState();
    _loadtheuser();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: ElevatedButton(
                    onPressed: (){},
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(300.0, 50.0)
                    ),
                    child: Row(
                      children: [
                        Text('Make Your Account Private'),
                        Switch(
                          value: isSwitched,
                          onChanged: (value) {
                            setState(() {
                              isSwitched = value;
                              changeProfType(isSwitched);
                              print(isSwitched);
                            });
                          },
                          activeTrackColor: Colors.lightBlueAccent,
                          activeColor: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: ElevatedButton(onPressed: (){
                    Navigator.pushNamed(context, '/changepassword');
                  }, child: Text('Change Password'), style: ElevatedButton.styleFrom(
                      minimumSize: Size(300.0, 50.0)
                  ),),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: ElevatedButton(onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Deactivate Account'),
                      content: const Text('You are about to deactivate your account, are you sure?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: (){
                            deactivateAccount();
                            Navigator.pop(context, 'Yes');
                          },
                          child: const Text('Yes'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'No'),
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


                    child: Text('Deactivate Account'), style: ElevatedButton.styleFrom(
                      minimumSize: Size(300.0, 50.0),

                    ),),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await _auth.signOut().then((result) {
                        Navigator.of(context).pop(true);
                      });
                    },
                    child: Text('Log Out'), style: ElevatedButton.styleFrom(
                      minimumSize: Size(300.0, 50.0)
                  ),),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: ElevatedButton(onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Account Deletion'),
                      content: const Text('You are about to delete your account permanently, are you sure?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: (){
                            FirebaseAuth.instance.currentUser!.delete();
                            Navigator.pop(context, 'Yes');
                          },
                          child: const Text('Yes'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'No'),
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


                    child: Text('Delete Account'), style: ElevatedButton.styleFrom(
                      minimumSize: Size(300.0, 50.0),
                      primary: Colors.red,
                  ),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

