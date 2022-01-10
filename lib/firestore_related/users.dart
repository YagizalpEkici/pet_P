import 'package:cloud_firestore/cloud_firestore.dart';

class user {
  String username;
  String surname;
  String password;
  String name;
  String photoUrl;
  List<dynamic> followers;
  List<dynamic> following;
  List<dynamic> posts;
  String bio;
  bool profType;
  String email;

  String petName;
  String birthYear;
  String sex;
  String breed;
  user(
      {required this.username,
        required this.surname,
        required this.name,
        required this.followers,
        required this.password,
        required this.following,
        required this.posts,
        required this.bio,
        required this.photoUrl,
        required this.profType,
        required this.email,

        required this.petName,
        required this.birthYear,
        required this.sex,
        required this.breed,});

  user.fromData(Map<String, dynamic> data)
      : username = data['username'],
        name = data['name'],
        surname = data['surname'],
        followers = data['followers'],
        password = data['password'],
        following = data['following'],
        posts = data['posts'],
        bio = data['bio'],
        photoUrl = data['photoUrl'],
        profType = data['profType'],
        email = data['email'],
        petName = data['petName'],
        birthYear = data['birthYear'],
        breed = data['breed'],
        sex = data['sex'];

  factory user.fromDocument(DocumentSnapshot doc) {
    return user(
      username: doc['username'],
      name: doc['name'],
      surname: doc['surname'],
      followers: doc['followers'],
      following: doc['following'],
      posts: doc['posts'],
      password: doc['password'],
      bio: doc['bio'],
      photoUrl: doc['photoUrl'],
      profType: doc['profType'],
      email: doc['email'],

      petName: doc['petName'],
      birthYear: doc['birthYear'],
      breed: doc['breed'],
      sex: doc['sex'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'name': name,
      'surname': surname,
      'followers': followers,
      'following': following,
      'password': password,
      'posts': posts,
      'bio': bio,
      'photoUrl': photoUrl,
      'profType': profType,
      'email':email,

      'petName': petName,
      'birthYear': birthYear,
      'sex': sex,
      'breed': breed,};
  }

}

