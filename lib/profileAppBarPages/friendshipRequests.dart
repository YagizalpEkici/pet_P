import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_project/firestore_related/users.dart';
import 'package:pet_project/utils/colors.dart';

class friendshipRequests extends StatefulWidget {
  const friendshipRequests({Key? key}) : super(key: key);

  @override
  _friendshipRequestsState createState() => _friendshipRequestsState();
}

class _friendshipRequestsState extends State<friendshipRequests> {
  int friendNum= 0;
  final List<String> friendRequestList = ['Bobby', 'Fluffy', 'Daisy', 'Rex', 'Suzzie', 'Princess', 'Snowball', 'T-rex'];
  final List<String> deniedRequests = [];
  final List<String> acceptedRequests = [];
  void buttonPressed(bool status, int index) {
    if(status == true){
      print('Accepted.');
    }
    else{
      print('Denied.');
    }
    setState(() {
      if(status == true){
        acceptedRequests.add(friendRequestList.elementAt(index));
        friendRequestList.removeAt(index);
        friendNum++;
      }
      else{
        deniedRequests.add(friendRequestList.elementAt(index));
        friendRequestList.removeAt(index);
      }
    });
  }


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


  void _refreshfollowRequest() async{
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

  acceptfollow(String docid) {
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
      "followers": followers,
    })

        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));

    FirebaseFirestore.instance
        .collection('followRequest')
        .doc(docid)
        .update({
      "userMail": 'AAAAAAAAAAAAAAAAAAAAA',
    });


    SnackBar successSnackBar =
    SnackBar(content: Text("Profile has been updated."));
  }

  final db = FirebaseFirestore.instance;

  @override
  void initState(){
    super.initState();
    _refreshfollowRequest();
    print('initState');
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

    FirebaseAnalytics().logEvent(name: 'followRequest', parameters: null);

    const title = 'My Friend Requests';
    return MaterialApp(
        title: title,
        home: Scaffold(
          appBar: AppBar(
            title: const Text(title, style: TextStyle(fontWeight: FontWeight.bold),),
            leading: IconButton(icon: Icon(Icons.arrow_back),
              onPressed: ()=>Navigator.pop(context, false),),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: db.collection('followRequest').snapshots(),
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
                      return Card(
                        child: ListTile(
                          title: Text(doc['senderusername'] + ' sent you a following request.'),
                          trailing: SizedBox(
                            height: 100, width: 144,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
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
                                                return Colors.green;
                                              }
                                          ),
                                        ),
                                        child: Text('✔', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white,),),
                                        onPressed: () {
                                          followers.add(doc['senderMail']);
                                          acceptfollow(doc.id);

                                        }
                                    ),
                                  ),
                                ),
                                Padding(
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
                                        child: Text('X', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white,),),
                                        onPressed: () {
                                          acceptfollow(doc.id);
                                        }
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
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
          Padding(

            padding: const EdgeInsets.all(16.0),


            child: ListView.builder(
              itemCount: friendRequestList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 24, 20, 0),
                  child: SizedBox(
                    height: 100, width: 50,
                    child: ListTile(
                      //add profile pictures
                      title: Text(friendRequestList[index], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),),
                      trailing: SizedBox(
                        height: 100, width: 144,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            acceptButton(index),
                            denyButton(index),

                          ],
                        ),
                      ),
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
  Widget acceptButton(String sendermailunique, String userMailunique){
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
                    return Colors.green;
                  }
              ),
            ),
            child: Text('✔', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white,),),
            onPressed: () {
              followers.add(sendermailunique);
              //acceptfollow();

            }
        ),
      ),
    );
  }
  Widget denyButton(int index){
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
            child: Text('X', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white,),),
            onPressed: () {
              buttonPressed(false, index);
            }
        ),
      ),
    );
  }
/*Widget totalFriendContainer(){
    return Container(
      margin: EdgeInsets.fromLTRB(15, 20, 15, 0),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: AppColors.Background,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(blurRadius: 10, color: AppColors.app_icons,)]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Total Friends: ', style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.text_color,
              ),
              ),
              Text(friendNum.toString(), style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.text_color,
              ),
              ),
            ],
          ),
        ],
      ),
    );
  }*/
}