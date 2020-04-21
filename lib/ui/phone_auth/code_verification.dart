import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseflutterauth/utils/mat_colors.dart';
import 'package:firebaseflutterauth/utils/style.dart';
import 'package:firebaseflutterauth/utils/util.dart';
import 'package:flutter/material.dart';

class CodeVerification extends StatefulWidget {
  final String phoneNumber;

  CodeVerification(this.phoneNumber);

  @override
  _CodeVerificationState createState() => _CodeVerificationState();
}

class _CodeVerificationState extends State<CodeVerification> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();

  String _code;
  bool _enableBtn = false;

  bool _showError = false;
  String _error;
  String _verificationId;

  Future<void> sendVerificationCode() async {
    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) {
      this._verificationId = verificationId;
    };

    final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String verID) {
      this._verificationId = verID;
    };

    final PhoneVerificationCompleted onCompleted = (AuthCredential credential) {
      debugPrint("Phone Auth : Completed : ${credential.toString()}");
//      setState(() {
//        controller.text = "687880";
//      });
      FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pop(context);
      Navigator.pop(context);
    };

    final PhoneVerificationFailed onFailed = (AuthException exception) {
//      debugPrint("Phone Auth : Failed : ${exception.message}");
      setState(() {
        _error = handleException(exception);
        _error += " Please try again later.";
        _showError = true;
      });
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber,
        timeout: const Duration(seconds: 30),
        verificationCompleted: onCompleted,
        verificationFailed: onFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: autoRetrievalTimeout);
  }

  @override
  void initState() {
    // TODO: implement initState
    controller.addListener(() {});
    super.initState();
    sendVerificationCode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar("Verification Code"),
      body: Container(
        margin: EdgeInsets.only(top: 32, left: 16, right: 16),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "We have send you a 6 digit OTP code on this ${widget.phoneNumber} number, please enter the code here.",
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
              child: formUI(),
            ),
            SizedBox(
              height: 24,
            ),
            getMaxSizeButton("Verify", _verifyPassword, _enableBtn),
          ],
        ),
      ),
    );
  }

  Widget formUI() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "Enter OTP",
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(5.0),
                borderSide: new BorderSide(),
              ),
            ),
            maxLength: 6,
            onChanged: (val) {
              if (val != null && val.length == 6) {
                setState(() {
                  _enableBtn = true;
                });
              } else {
                setState(() {
                  _enableBtn = false;
                });
              }
            },
            keyboardType: TextInputType.number,
            maxLines: 1,
            style: TextStyle(
              letterSpacing: 2,
              fontSize: 16,
              color: MatColor.primaryTextColor,
            ),
            validator: validateEmail,
            onSaved: (String val) {
              _code = val;
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

  _verifyPassword() {
//    FirebaseAuth.instance
  }
}
