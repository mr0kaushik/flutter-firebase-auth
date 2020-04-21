import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseflutterauth/auths/auth.dart';
import 'package:firebaseflutterauth/ui/HomeScreen.dart';
import 'package:firebaseflutterauth/ui/dashboard/dashboard.dart';
import 'package:firebaseflutterauth/utils/mat_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final ThemeData _kDefaultTheme = new ThemeData(
    accentColor: MatColor.accentColor,
    primaryColor: MatColor.primaryColor,
    indicatorColor: MatColor.lightGreyColor,
    primaryColorDark: MatColor.primaryDarkColor,
    primaryIconTheme: IconThemeData(
      color: MatColor.iconColor,
    ),
    fontFamily: 'Lato',
    textTheme: TextTheme(
        headline6: TextStyle(color: MatColor.primaryTextColor),
        subtitle1: TextStyle(color: MatColor.secondaryTextColor)),
  );

  @override
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser>.value(
      value: FirebaseAuthServices().firebaseUser,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
//      title: 'Flutter Firebase Auth',
        theme: _kDefaultTheme,
        home: HomeScreen(),
        routes: {
          '/dashboard': (context) => DashBoard(),
        },
      ),
    );
  }
}
