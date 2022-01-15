import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

import 'navigation_drawer_widget.dart';

class changepassword extends StatefulWidget {
  const changepassword({Key? key}) : super(key: key);

  @override
  _changepasswordState createState() => _changepasswordState();
}

class _changepasswordState extends State<changepassword> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController pass = TextEditingController();
  TextEditingController repass = TextEditingController();
  TextEditingController currentPass = TextEditingController();
  late String password;
  late String repassword;
  late String curpassword;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
        centerTitle: true,
      ),
      body: Padding(
        padding: Dimen.RegularPadding,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: currentPass,
                        decoration: InputDecoration(
                          fillColor: AppColors.app_icons,
                          filled: true,
                          hintText: "Current password",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.text_color,
                            ),
                            borderRadius: Dimen.Border,
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          User user = FirebaseAuth.instance.currentUser!;
                          if(value == null){
                            return 'password field cannot be empty!';
                          }
                          if(currentPass.text.length == 0)
                          {
                            return 'password field cannot be empty!';
                          }

                          return null;
                        },

                        obscureText: true,
                        onSaved: (value) {
                          if (value != null) {
                            curpassword = value;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30,),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: pass,
                        decoration: InputDecoration(
                          fillColor: AppColors.app_icons,
                          filled: true,
                          hintText: "New Password",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.text_color,
                            ),
                            borderRadius: Dimen.Border,
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if(value == null){
                            return 'password field cannot be empty!';
                          }
                          if(pass.text.length == 0)
                          {
                            return 'password field cannot be empty!';
                          }
                          if(pass.text.length < 8)
                          {
                            return 'password has to be at least 8 characters long!';
                          }
                          if(pass.text == currentPass.text){
                            return 'New password can not be your old password!';
                          }
                          return null;
                        },

                        obscureText: true,
                        onSaved: (value) {
                          if (value != null) {
                            password = value;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30,),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: repass,
                        decoration: InputDecoration(
                          fillColor: AppColors.app_icons,
                          filled: true,
                          hintText: "Retype your new password",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.text_color,
                            ),
                            borderRadius: Dimen.Border,
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        validator: (value) {
                          if(value==null){
                            return 'password field cannot be empty!';
                          }
                          if(repass.text.length == 0)
                          {
                            return 'password field cannot be empty!';
                          }
                          if(repass.text.length < 8)
                          {
                            return 'password has to be at least 8 characters long!';
                          }
                          if(pass.text != repass.text){
                            return "Password does not match";
                          }
                          return null;
                        },
                        onSaved: (value){
                          if(value != null){
                            repassword = value;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 100,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: () async {
                      if(_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        User user = await FirebaseAuth.instance.currentUser!;
                        user.updatePassword(password).then((_){
                          print("Successfully changed password");
                        }).catchError((error){
                          print("Password can't be changed" + error.toString());
                          //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
                        });
                        Navigator.pop(context);
                      }

                      },
                        child: Text('Apply Changes'))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
