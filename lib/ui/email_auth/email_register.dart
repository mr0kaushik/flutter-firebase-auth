import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseflutterauth/auths/auth.dart';
import 'package:firebaseflutterauth/utils/mat_colors.dart';
import 'package:firebaseflutterauth/utils/style.dart';
import 'package:firebaseflutterauth/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmailRegister extends StatefulWidget {
  @override
  _EmailRegisterState createState() => _EmailRegisterState();
}

class _EmailRegisterState extends State<EmailRegister> {
  bool isEmailAvail, isPasswordAvail;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FirebaseAuthServices _authServices = FirebaseAuthServices();

//  final GlobalKey<FormState> _emailKey = GlobalKey<FormState>();

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
                "Register",
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
              getMaxSizeButton("Register", _signUp, _enableBtn),
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
              onChanged: (val) {
                hideError();
                if (val != null && val.length > 5) {
                  setState(() {
                    _email = val;
                  });
                }
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
                    _password = value;
                  });
                } else {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    debugPrint("Email Auth : Email $_email");
                    debugPrint("Email Auth : Password $_password");
                    // make register call
                  } else {
                    setState(() {
                      _autoValidate = true;
                    });
                  }
                  setState(() {
                    _password = '';
                  });
                }
              },
              validator: validatePassword,
              onSaved: (String val) {
                setState(() {
                  _password = val;
                });
              },
            ),
            SizedBox(
              height: 12,
            ),
            TextFormField(
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: "Confrim Password",
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
                if (value != null &&
                    value.length >= 6 &&
                    value == _password &&
                    _email != null &&
                    _email.length > 5) {
                  setState(() {
                    _enableBtn = true;
                  });
                } else {
                  setState(() {
                    _enableBtn = false;
                  });
                }
              },
              validator: (value) {
                return validateConfirmPassword(_password, value);
              },
              onSaved: (String val) {
                _password = val;
              },
            ),
            SizedBox(
              height: 8,
            ),
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
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.bold,
                      color: MatColor.secondaryTextColor,
                    ),
                  ),
                ],
              ),
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

  void _signUp() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      debugPrint("Email Auth : Email $_email");
      debugPrint("Email Auth : Password $_password");
      // make register call
      dynamic result =
          await _authServices.registerWithEmailAndPassword(_email, _password);
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
        Navigator.pop(context);
      }
      /*else{
        //Register successfully
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) {
          return DashBoard();
        }));}*/
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  String validateConfirmPassword(String password, String value) {
    if (password != value) {
      return "Passwords do not match";
    }
    return null;
  }

  void hideError() {
    if (_showError) {
      _showError = false;
      _error = '';
    }
  }
}
