import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseflutterauth/auths/auth.dart';
import 'package:firebaseflutterauth/ui/email_auth/email_register.dart';
import 'package:firebaseflutterauth/utils/mat_colors.dart';
import 'package:firebaseflutterauth/utils/style.dart';
import 'package:firebaseflutterauth/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'forget_screen.dart';

class EmailLogin extends StatefulWidget {
  @override
  _EmailLoginState createState() => _EmailLoginState();
}

class _EmailLoginState extends State<EmailLogin> {
  bool isEmailAvail, isPasswordAvail;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//  final GlobalKey<FormState> _emailKey = GlobalKey<FormState>();
  FirebaseAuthServices _authServices = FirebaseAuthServices();

  bool _autoValidate = false;
  bool _enableBtn = false;

  bool _showError = false;
  String _error;
  String _email, _password;

  bool _obscureText = true;

  void _toggle() {
    if (mounted) {
      setState(() {
        _obscureText = !_obscureText;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authServices = FirebaseAuthServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar("Email Authentication"),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Text(
                "LOGIN",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Robota',
                  fontSize: 24,
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: formUI(),
              ),
              SizedBox(
                height: 24,
              ),
              getMaxSizeButton("Sign In", _signIn, _enableBtn),
              SizedBox(
                height: 12,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: divider,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "OR",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Robota',
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    child: divider,
                  ),
                ],
              ),
              SizedBox(
                height: 24,
              ),
              getMaxSizeButton("Sign Up", _signUp, true),
            ],
          ),
        ),
      ),
    );
  }

  Widget formUI() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: "Email",
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(5.0),
                  borderSide: new BorderSide(),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              maxLines: 1,
              style: TextStyle(
                fontSize: 16,
                color: MatColor.primaryTextColor,
              ),
              validator: validateEmail,
              onSaved: (String val) {
                _email = val;
              },
              onChanged: (value) {
                hideError();
              },
            ),
            SizedBox(
              height: 12,
            ),
            TextFormField(
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: "Password",
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(5.0),
                  borderSide: new BorderSide(),
                ),
              ),
              keyboardType: TextInputType.visiblePassword,
              maxLines: 1,
              style: TextStyle(
                fontSize: 16,
                color: MatColor.primaryTextColor,
              ),
              onChanged: (value) {
                hideError();

                if (value != null && value.length >= 6) {
                  setState(() {
                    _enableBtn = true;
                  });
                } else {
                  setState(() {
                    _enableBtn = false;
                  });
                }
              },
              validator: validatePassword,
              onSaved: (String val) {
                _password = val;
              },
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: _toggle,
                  child: Row(
                    children: <Widget>[
                      Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: MatColor.secondaryTextColor,
                      ),
                      SizedBox(width: 5),
                      Text(
                        _obscureText ? "Show" : "Hide",
                        style: onTapTextBoldStyle,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (_) {
                            return ForgetPassword();
                          }));
                        },
                        child: Text(
                          'Forget Password',
                          style: onTapTextBoldStyle,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Visibility(
              visible: _showError,
              child: Text(
                (_error != null) ? _error : '',
                style: errorStyle,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _signIn() async {
    // make register call
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      debugPrint("Email Auth : Email $_email");
      debugPrint("Email Auth : Password $_password");

      dynamic result =
          await _authServices.signInUsingEmailAndPassword(_email, _password);
      // caught exception
      if (result is PlatformException) {
        String error = result.message;
        setState(() {
          _error = error;
          _showError = true;
        });
      } else {
        //Stream listen to call for sign in
        FirebaseUser user = result;
        debugPrint("Email Auth : user : ${user.toString()}");
        Navigator.pop(context);
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  // register
  _signUp() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return EmailRegister();
    }));
  }

  void hideError() {
    if (_showError) {
      _showError = false;
      _error = '';
    }
  }
}
