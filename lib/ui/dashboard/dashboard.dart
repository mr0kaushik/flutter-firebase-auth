import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseflutterauth/auths/auth.dart';
import 'package:firebaseflutterauth/models/user.dart';
import 'package:firebaseflutterauth/utils/mat_colors.dart';
import 'package:firebaseflutterauth/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  bool _isEmailAuth = false;
  String mEmail = '', mPhone = '';
  final FirebaseAuthServices _authServices = FirebaseAuthServices();

  // LogOff
  _logOff() async {
    await _authServices.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = Provider.of<FirebaseUser>(context);
    final User user = FirebaseAuthServices().fromFirebaseUser(firebaseUser);
    if (user != null) {
      debugPrint("User Dashboard: ${user.phoneNumber}");
      debugPrint("User Dashboard: ${user.email}");
      debugPrint("User Dashboard: ${user.userId}");
      setState(() {
        mPhone = user.phoneNumber;
      });
    }
    if (user != null) {
      if (mounted) {
        setState(() {
          mPhone = user.phoneNumber;
        });
        setState(() {
          _isEmailAuth = user.isEmailAuth;
        });
        setState(() {
          mEmail = user.email;
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: screenTitleStyle,
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: MatColor.iconColor,
            ),
            onPressed: _logOff,
          )
        ],
      ),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              currentAccountPicture: Image.asset("assets/images/login.png"),
              accountName: new Text((mEmail == null) ? mPhone : mEmail),
              accountEmail: new Text(user.userId),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 24,
            ),
            Text(
              "HEY\nTHERE!!",
              style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                  fontFamily: 'Robota',
                  color: MatColor.primaryTextColor),
            )
          ],
        ),
      ),
    );
  }
}
