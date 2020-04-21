
import 'package:firebaseflutterauth/auths/auth.dart';
import 'package:firebaseflutterauth/utils/mat_colors.dart';
import 'package:firebaseflutterauth/utils/style.dart';
import 'package:firebaseflutterauth/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _validate = false;
  FirebaseAuthServices _authServices = FirebaseAuthServices();

  bool _showError = false;
  String _error;

  String _email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar("Forget Password"),
      body: Container(
        margin: EdgeInsets.only(top: 32, left: 16, right: 16),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "We will send you a reset email, please provide your email address.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 1.5,
                  fontSize: 18,
                  fontFamily: 'Lato',
                  color: MatColor.primaryTextColor,
                ),
              ),
            ),
            SizedBox(
              height: 32,
            ),
            Form(
              key: _formKey,
              autovalidate: _validate,
              child: formUI(),
            ),
            SizedBox(
              height: 24,
            ),
            getMaxSizeButton("Next", _sendResetEmail, true),
          ],
        ),
      ),
    );
  }

  // Send Code
  _sendResetEmail() async {
    if (_formKey.currentState.validate()) {
      // No any error in validation
      _formKey.currentState.save();
      debugPrint("Phone Auth :Email $_email");
      // Call Firebase api to receive code

      dynamic result = await _authServices.sendResetEmail(_email);
      // caught exception
      if (result is PlatformException) {
        String error = result.message;
        setState(() {
          _error = error;
          _showError = true;
        });
      } else {
        //Show Dialog and return to login page
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (buildContext) {
              return AlertDialog(
                title: Text(
                  "Reset Email",
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 16,
                    color: MatColor.primaryTextColor,
                  ),
                ),
                content: Text(
                  "We have send you a reset email on ${_email}, please check your inbox to reset password.",
                  style: TextStyle(
                    fontFamily: 'Robota',
                    fontSize: 14,
                    color: MatColor.secondaryTextColor,
                  ),
                ),
                actions: [
                  FlatButton(
                    child: Text("Go to Login"),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            });
      }
    } else {
      // validation error
      setState(() {
        _validate = true;
      });
    }
  }

  Widget formUI() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
    );
  }
}
