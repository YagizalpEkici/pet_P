import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:pet_project/routes/loginpage.dart';
import 'package:provider/provider.dart';

import 'HomeScreen.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if(user == null){
      return login(analytics: FirebaseAnalytics(), observer: FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),);
    }
    else{
      return HomeScreen();
    }
  }
}
