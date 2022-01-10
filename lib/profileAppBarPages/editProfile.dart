import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pet_project/firestore_related/users.dart';


import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class editProfile extends StatefulWidget{

  @override
  _editProfile createState() => _editProfile();
}

class _editProfile extends State<editProfile> {
  final _formKey = GlobalKey<FormState>();
  String petName = "";
  String bio = "";
  String birthYear = "";
  String breed = "";
  String sex = "";
  List<String> sexType = ["female", "male", "none"];
  String url = "";

  user? currentUser;

  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future pickImageGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    });
  }
  Future pickImageCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
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

  updateUserData() {
    //bool priv;
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
      "petName": petName,
      "bio": bio,
      "photoUrl": url,
      "birthYear": birthYear,
      "breed": breed,
      "sex": sex,
    })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));

    SnackBar successSnackBar =
    SnackBar(content: Text("Profile has been updated."));
  }


  @override
  void initState(){
    super.initState();
  }

  void buttonPressed() {
    print(petName+"\n"+bio+"\n"+birthYear+"\n"+breed+"\n"+sex+"\n");
  }
  void pageDirection() {
    Navigator.pushNamed(this.context, '/homePage');
  }

  @override
  Widget build (BuildContext context){
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(icon:Icon(Icons.arrow_back),
            onPressed:() => Navigator.pop(context, false),
            //onPressed:() => exit(0),
          ),
          title: Text(
            "Edit Your Pet's Profile",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.green,
          centerTitle: true,
        ),
        body: SafeArea(
            child : Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                      children: [
                        SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Please fill all the blanks',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Container(
                                        child: CircleAvatar(
                                          child: ClipOval(
                                            child: getImage(),
                                          ),
                                          radius: 70,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
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
                                'gallery',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
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
                              onPressed: pickImageCamera,
                              child: Text(
                                'camera',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 16,),
                            if(_image != null) OutlinedButton(
                              onPressed: (){
                                setState(() {
                                  _image = null;
                                });

                              },
                              child: Text('Cancel'),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  fillColor: Colors.grey,
                                  filled: true,
                                  hintText: "Pet's Name",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                  ),
                                ),
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if(value==null){
                                    return 'Pet name field cannot be empty!';
                                  }
                                  else{
                                    String trimmedValue = value.trim();
                                    if(trimmedValue.isEmpty){
                                      return 'Pet name field cannot be empty';
                                    }
                                  }
                                  return null;
                                },
                                onSaved: (value){
                                  if(value != null){
                                    petName = value;
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height : 10,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  fillColor: Colors.grey,
                                  filled: true,
                                  hintText: "Biography",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                  ),
                                ),
                                keyboardType: TextInputType.multiline,
                                onSaved: (value){
                                  if(value != null){
                                    bio = value;
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height : 10,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  fillColor: Colors.grey,
                                  filled: true,
                                  hintText: "Birth Year",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                  ),
                                ),
                                keyboardType: TextInputType.text,
                                onSaved: (value){
                                  if(value != null){
                                    birthYear = value;
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height : 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  fillColor: Colors.grey,
                                  filled: true,
                                  hintText: "Breed",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                  ),
                                ),
                                keyboardType: TextInputType.text,
                                onSaved: (value){
                                  if(value != null){
                                    breed = value;
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height : 10,),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding:
                                EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    shape: BoxShape.rectangle,
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(10)),
                                child: DropdownButton<String>(
                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                  iconEnabledColor: Colors.black,
                                  dropdownColor: Colors.white,
                                  alignment: AlignmentDirectional.center,
                                  icon: Icon(Icons.arrow_drop_down),
                                  hint: Text('Sex'),
                                  underline: SizedBox(),
                                  items: sexType.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    if(value != null){
                                      sex = value;
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: 20,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(width: 80,),
                                    TextButton(
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                              (Set<MaterialState> states) {
                                            if(states.contains(MaterialState.pressed))
                                              return Theme.of(context).colorScheme.primary.withOpacity(0.5);
                                            return Colors.blueGrey;
                                          },
                                        ),
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          print("route: homePage successful");
                                          _formKey.currentState!.save();
                                          updateUserData();
                                          pageDirection();
                                        }
                                      },
                                      child: Text(
                                        'Enter',
                                        style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 80,),
                                  ],
                                ),
                              ]
                          ),
                        ),
                      ]
                  ),
                ),
              ),
            )
        )
    );
  }
  Widget getImage() {
    return _image != null ? Image.file(File(_image!.path)) :TextButton(
      child:
      Icon(
          Icons.face,
          color: Colors.white,
          size:70
      ),
      onPressed: () {},
    );
  }
}
