import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_project/profileAppBarPages/options.dart';
import 'package:pet_project/unfinished_proifle_and_feed/privateOtherProfile.dart';
import 'package:pet_project/unfinished_proifle_and_feed/post.dart';
import 'package:pet_project/unfinished_proifle_and_feed/useragreement.dart';
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

import 'communityrules.dart';
import 'notification.dart';

class NavigationDrawerWidget extends StatelessWidget {
  NavigationDrawerWidget({Key? key}) : super(key: key);
  final padding = EdgeInsets.symmetric(horizontal: 20);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Colors.blue,
        child: ListView(
          padding: padding,
          children: [
            const SizedBox(height: 48),
            Expanded(child: Align(
              alignment: Alignment.bottomCenter,
              child: Text('V - g.0.6.2', style: TextStyle(color: Colors.white),),
            ),
            ),
            const SizedBox(height: 48),
            buildMenuItem(
              text: 'Notifications',
              icon: Icons.notifications,
              onClicked: () => selectedItem(context, 0),
            ),
            const SizedBox(height: 48),
            buildMenuItem(text: 'Settings', icon: Icons.settings, onClicked: () => selectedItem(context, 1),),
            const SizedBox(height: 48),
            buildMenuItem(text: 'User Agreement', icon: Icons.menu_book_outlined, onClicked: () => selectedItem(context, 2),),
            const SizedBox(height: 48),
            buildMenuItem(text: 'Community Rules', icon: Icons.assignment, onClicked: () => selectedItem(context, 3),),
            //const SizedBox(height: 130),

          ],
        ),
      ),
    );
  }
  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
}){
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index){
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => notifications(),));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => options(),));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => otherprofilePage(),));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => communityrules(),));
        break;
    }
  }
}
