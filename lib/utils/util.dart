import 'package:firebaseflutterauth/utils/mat_colors.dart';
import 'package:firebaseflutterauth/utils/style.dart';
import 'package:flutter/material.dart';

String validateEmail(String value) {
  Pattern pattern =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Please enter valid Email Address';
  else
    return null;
}

String validatePassword(String value) {
  if (value.isEmpty || value.length < 6)
    return 'Password must contain atlest 6 characters';
  else
    return null;
}

String validatePhone(String value) {
  String patttern = r'(^[0-9]*$)';
  RegExp regExp = new RegExp(patttern);
  if (value.length == 0) {
    return "Phone number is Required";
  } else if (value.length != 10) {
    return "Phone number must conatains 10 digits";
  } else if (!regExp.hasMatch(value)) {
    return "Mobile Number must be digits";
  }
  return null;
}

getAppBar(String title) {
  return AppBar(
    automaticallyImplyLeading: true,
    title: Text(
      title,
      style: screenTitleStyle,
    ),
    centerTitle: true,
  );
}

getMaxSizeButton(String text, Function onPressed, bool enable) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    child: SizedBox(
      height: 45,
      width: double.infinity,
      child: FlatButton(
        disabledColor: MatColor.dividerColor,
        color: Colors.green,
        onPressed: (enable) ? onPressed : null,
        child: Text(
          text,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Robota',
              fontSize: 20,
              color: Colors.white),
        ),
      ),
    ),
  );
}

handleException(Exception exception) {
  return exception.toString();
}
