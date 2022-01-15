import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_project/firestore_related/users.dart';
import 'package:pet_project/profileAppBarPages/friendshipRequests.dart';
import 'package:pet_project/utils/colors.dart';
import 'package:pet_project/firestore_related//notifClass.dart';

class notifications extends StatefulWidget {
  const notifications({Key? key}) : super(key: key);

  @override
  _notifications createState() => _notifications();
}

class _notifications extends State<notifications> {
  List<notifClass> myNotifications = [];

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


  void _refreshNotifications() async{
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

  void _loadUserProf() async {

    FirebaseAuth _auth;
    User? _user;
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;

    var dbNotifGetter = await FirebaseFirestore.instance.collection('notification').where('userMail', isEqualTo: _user?.email).get();
    dbNotifGetter.docs.forEach((doc) => {
      myNotifications.add(
          notifClass(
            Photoid: doc['photoID'],
            userName: doc['username'],
            type: doc['type'],
            userMail: doc['userMail'],
            senderMail: doc['senderMail'],
            postID: doc['postID'],
            pid: "",
            sendername: doc['sendername']
          )
      )
    });

  }



  //********************************
  final db = FirebaseFirestore.instance;



  @override
  void initState(){
    super.initState();
    _refreshNotifications();
  }

  Widget build(BuildContext context){

    currentUser = user(
        posts: posts,
        following: following,
        birthYear: birthYear,
        bio: bio,
        name: fullName,
        petName: petName,
        breed: breed,
        photoUrl: photoURL,
        email: userMail,
        surname: surname,
        profType: profType,
        followers: followers,
        sex: sex,
        password: password,
        username: userName
    );

    FirebaseAnalytics().logEvent(name: 'notifications', parameters: null);

    const title = 'Notifications';
    return MaterialApp(
        title: title,
        home: Scaffold(

          appBar: AppBar(
            title: const Text(title, style: TextStyle(fontWeight: FontWeight.bold),),
            leading: IconButton(icon: Icon(Icons.arrow_back),
              onPressed: ()=>Navigator.pop(context, false),),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: db.collection('notification').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              else
                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    if(doc['userMail'] == userMail){
                      if(doc['type'] == 'like'){
                        return Card(
                          child: ListTile(
                            title: Text(doc['sendername'] + ' liked your post.'),
                            trailing: ElevatedButton(onPressed: buttonPressedlike, child: Text('->'),),
                          ),
                        );}
                      else if(doc['type'] == 'comment'){
                        return Card(
                          child: ListTile(
                            title: Text(doc['sendername'] + ' commented on your post.'),
                            trailing: ElevatedButton(onPressed: buttonPressedcomment, child: Text('->'),),
                          ),
                        );
                      }
                      else if(doc['type'] == 'follow'){
                        return Card(
                          child: ListTile(
                            title: Text(doc['sendername'] + ' sent you a following request.'),
                            trailing: ElevatedButton(onPressed: buttonPressedfollow, child: Text('->'),),
                          ),
                        );
                      }
                      else{
                        return Card(
                        );
                      }
                    }
                    else{
                      return Card(
                      );
                    }
                  }).toList(),
                );
            },
          ),
          /*
          body: Padding(
            padding: const EdgeInsets.all(16.0),
              child: Text(myNotifications[0].userName),

            child: ListView.builder(
              itemCount: myNotifications.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 24, 20, 0),
                  child: SizedBox(
                    height: 100, width: 50,
                    child: Column(
                      children: [

                        if(myNotifications[index].type == 'like')...[
                          ListTile(
                            title: Text(myNotifications[index].userName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),),
                            trailing: SizedBox(
                              height: 100, width: 144,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  deleteButton(index, myNotifications),
                                ],
                              ),
                            ),
                          ),]

                        else if(myNotifications[index].type == 'followRequest')...[
                          ListTile(
                            title: Text(myNotifications[index].userName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),),
                            trailing: SizedBox(
                              height: 100, width: 144,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  deleteButton(index, myNotifications),
                                ],
                              ),
                            ),
                          ),]

                      ],
                    ),
                  ),
                );
              },
            ),

          ),
          */
        )
    );
  }

  Widget deleteButton(int index, List myList){
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        child: TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed))
                      return Theme
                          .of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.5);
                    return Colors.red;
                  }
              ),
            ),
            child: Text('Delete', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white,),),
            onPressed: () {
              //buttonPressed(index, myList);
            }
        ),
      ),
    );
  }
  void buttonPressedlike(){
    Navigator.pushNamed(context, '/friendshipRequests');
  }
  void buttonPressedcomment(){
    Navigator.pushNamed(context, '/friendshipRequests');
  }
  void buttonPressedfollow(){
    Navigator.pushNamed(context, '/friendshipRequests');
  }
}