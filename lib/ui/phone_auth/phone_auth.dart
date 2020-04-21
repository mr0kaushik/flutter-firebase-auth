import 'dart:io';
import 'package:firebaseflutterauth/auths/auth.dart';
import 'package:firebaseflutterauth/ui/phone_auth/code_verification.dart';
import 'package:firebaseflutterauth/utils/mat_colors.dart';
import 'package:firebaseflutterauth/utils/style.dart';
import 'package:firebaseflutterauth/utils/util.dart';
import 'package:flutter/material.dart';

class PhoneLogin extends StatefulWidget {
  @override
  _PhoneLoginState createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _validate = false;
  bool _enableBtn = false;

  bool _showError = false;
  String _error;

  final FirebaseAuthServices services = FirebaseAuthServices();

  String _phoneNumber;
  String _verificationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar("Phone Authentication"),
      body: Container(
        margin: EdgeInsets.only(top: 32, left: 16, right: 16),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Please enter your 10 digit phone number",
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 1.5,
                  fontSize: 22,
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
            getMaxSizeButton("Next", _sendCode, _enableBtn),
            SizedBox(
              height: 24,
            ),
            Visibility(
              visible: _showError,
              child: Text(
                (_error != null) ? _error : '',
                style: errorStyle,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "Term and Conditions",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 14,
                        fontFamily: 'Robota',
                        color: MatColor.secondaryTextColor),
                  ),
                  SizedBox(
                    height: 16,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Send Code
  _sendCode() async {
    if (_formKey.currentState.validate()) {
      // No any error in validation
      _formKey.currentState.save();
      debugPrint("Phone Auth : Phone Number $_phoneNumber");

      bool isConnectionAvail = await isInternetAvail();
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return CodeVerification(_phoneNumber);
      }));
      /*} else {
        setState(() {
          _error = "Please check your internet Connection!";
          _showError = true;
        });
      }*/
      // Call Firebase api to receive code
//      sendVerificationCode();
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
      child: TextFormField(
        decoration: InputDecoration(
          prefixText: "+91",
          labelText: "Phone Number",
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(5.0),
            borderSide: new BorderSide(),
          ),
        ),
        keyboardType: TextInputType.phone,
        maxLines: 1,
        maxLength: 10,
        onChanged: (value) {
          if (value != null && value.length == 10) {
            setState(() {
              _enableBtn = true;
            });
          } else {
            setState(() {
              _enableBtn = false;
            });
          }
        },
        style: TextStyle(
          fontSize: 16,
          color: MatColor.primaryTextColor,
        ),
        validator: validatePhone,
        onSaved: (String val) {
          _phoneNumber = "+91" + val;
        },
      ),
    );
  }

  Future<bool> isInternetAvail() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        return true;
      }
    } on SocketException catch (_) {
      print('not connected');
      return false;
    }
  }
}
