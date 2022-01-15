import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:pet_project/routes/search.dart';
import 'package:pet_project/unfinished_proifle_and_feed/HomeScreen.dart';
import 'package:pet_project/unfinished_proifle_and_feed/privateOtherProfile.dart';
import 'package:pet_project/unfinished_proifle_and_feed/profilePage.dart';

import 'form.dart';
import 'gathering.dart';


class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  int currentIndex = 0;
  final screens = [
    HomeScreen(),
    search(),
    gathering(),
    forum(),
    profilePage(),
  ];
  //PageController pageController = PageController();

  void onTapped(int index){
    setState((){
      currentIndex = index;
    });
    //pageController.jumpToPage(index);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: screens[currentIndex],
      /*PageView(
        controller: pageController,
        children: [
          Container(
            color: Colors.black,
          ),
          Container(
            color: Colors.yellow,
          ),
          Container(
            color: Colors.blue,
          ),
          Container(
            color: Colors.purple,
          ),
          Container(
            color: Colors.green,

          ),
        ],

       */


      bottomNavigationBar: BottomNavigationBar(items: const < BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label:'mainFeed'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label:'search'),
        BottomNavigationBarItem(icon: Icon(Icons.meeting_room), label:'gathering'),
        BottomNavigationBarItem(icon: Icon(Icons.pending_actions), label:'form'),
        BottomNavigationBarItem(icon: Icon(Icons.accessibility), label:'profile'),

      ],
          currentIndex: currentIndex,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.red,
          onTap: onTapped
      ),
    );
  }
}
