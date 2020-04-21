import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseflutterauth/models/user.dart';
import 'package:flutter/cupertino.dart';

class FirebaseAuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User fromFirebaseUser(FirebaseUser firebaseUser) {
    return (firebaseUser != null)
        ? new User(
        userId: firebaseUser.uid,
        email: firebaseUser.email,
        phoneNumber: firebaseUser.phoneNumber)
        : null;
  }

  // auth change stream
  Stream<FirebaseUser> get firebaseUser {
    return _firebaseAuth.onAuthStateChanged;
  }

  // SignIn using Email and password
  Future<dynamic> signInUsingEmailAndPassword(String email,
      String password) async {
    try {
      AuthResult authResult = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (authResult.user != null) return authResult.user;
//      return authResult;
    } catch (exp) {
      debugPrint(exp.toString());
      return exp;
    }
  }

  // Register with email and password
  Future<dynamic> registerWithEmailAndPassword(String email,
      String password) async {
    try {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (exp) {
      debugPrint(exp.toString());
      return exp;
    }
  }

  Future<dynamic> sendResetEmail(String email) async {
    try {
      return await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (exp) {
      debugPrint(exp.toString());
      return exp;
    }
  }


  // Sign out
  Future signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch (exp) {
      debugPrint(exp.toString());
    }
  }


//  Future verifyCode(String code, String vId) async{
//    await _firebaseAuth.verifyPhoneNumber(phoneNumber: null, timeout: null, verificationCompleted: null, verificationFailed: null, codeSent: null, codeAutoRetrievalTimeout: null)
//  }



}
