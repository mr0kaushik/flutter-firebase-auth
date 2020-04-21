import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseflutterauth/ui/dashboard/dashboard.dart';
import 'package:firebaseflutterauth/ui/email_auth/email_auth.dart';
import 'package:firebaseflutterauth/ui/phone_auth/phone_auth.dart';
import 'package:firebaseflutterauth/utils/mat_colors.dart';
import 'package:firebaseflutterauth/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = Provider.of<FirebaseUser>(context);
    debugPrint("HomeScreen: Firebase User : $firebaseUser");

    // user logged in
    if (firebaseUser != null) {
      return DashBoard();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Flutter Firebase Auth",
            style: screenTitleStyle,
          ),
          centerTitle: true,
        ),
        body: Container(
          child: Center(
            child: new Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Image.asset(
                    "assets/images/login.png",
                    width: 150,
                    height: 150,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 64),
                        child: Text(
                          "Select Authentication Method",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            height: 1.5,
                            fontSize: 24,
                            fontFamily: 'Lato',
                            color: MatColor.primaryTextColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 48),
                      RaisedButton(
                        color: MatColor.primaryDarkColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(22.0)),
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (_) {
                            return EmailLogin();
                          }));
                        },
                        child: SizedBox(
                          width: 200,
                          height: 45,
                          child: Center(
                            child: Text(
                              "Email Authentication",
                              style: TextStyle(
                                color: MatColor.iconColor,
                                fontFamily: 'Lato',
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      RaisedButton(
                        color: MatColor.primaryDarkColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(22.0)),
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (_) {
                            return PhoneLogin();
                          }));
                        },
                        child: SizedBox(
                          width: 200,
                          height: 45,
                          child: Center(
                            child: Text(
                              "Phone Authentication",
                              style: TextStyle(
                                color: MatColor.iconColor,
                                fontFamily: 'Lato',
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
