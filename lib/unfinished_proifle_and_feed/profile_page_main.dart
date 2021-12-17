import 'package:flutter/material.dart';
import 'package:pet_project/unfinished_proifle_and_feed/profilePage.dart';
import 'package:pet_project/unfinished_proifle_and_feed/HomeScreen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: profilePage(),
    );
  }
}
