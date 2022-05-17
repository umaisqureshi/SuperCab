import 'package:flutter/material.dart';
import 'package:supercab/generated/l10n.dart';
import 'package:supercab/utils/firebaseCredentials.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:supercab/utils/userController.dart';


CurrentUser localCurrentUser;

signUpFacebook(context) async {
  FacebookLogin _facebookLogin = FacebookLogin();
  final res = await _facebookLogin.logIn(permissions: [
    FacebookPermission.publicProfile,
    FacebookPermission.email,
  ]);
  switch (res.status) {
    case FacebookLoginStatus.Success:
      final AuthCredential credential =
          FacebookAuthProvider.credential(res.accessToken.token);
      User firebaseUser = (await FirebaseCredentials()
              .auth
              .signInWithCredential(credential)
              .catchError((e) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(title: Text(e.toString()));
            });
      }))
          .user;
      if (firebaseUser != null) {
        FirebaseCredentials()
            .firestore
            .collection('user')
            .doc(firebaseUser.uid)
            .set({
          'name': firebaseUser.displayName,
          'email': firebaseUser.email,
          'phone': firebaseUser.phoneNumber ?? 'null',
          'selectedLanguage': 'English'
        }, SetOptions(merge: true)).then((value) {
          localCurrentUser = Get.put(CurrentUser());
          localCurrentUser.currentUserId = firebaseUser.uid;
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        });
      }
      break;
    case FacebookLoginStatus.Cancel:
      print('The user canceled the login');
      break;
    case FacebookLoginStatus.Error:
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(title: Text(res.error.toString()));
          });
      print(FacebookLoginStatus.Error);
      break;
  }
}

signUpGoogle(context) async {
  try {
    GoogleSignIn googleSignIn = GoogleSignIn();

    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    print("*************** Google Auth Access Token : " +
        googleAuth.accessToken.toString() +
        '*****');

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    User firebaseUser =
        (await FirebaseCredentials().auth.signInWithCredential(credential))
            .user;

    if (firebaseUser != null) {
      FirebaseCredentials()
          .firestore
          .collection('user')
          .doc(firebaseUser.uid)
          .set({
        'name': firebaseUser.displayName,
        'email': firebaseUser.email ?? 'null', // googleUser.email
        'phone': firebaseUser.phoneNumber ?? 'null',
        'selectedLanguage': 'English'
      }, SetOptions(merge: true)).then((value) {
        localCurrentUser = Get.put(CurrentUser());
        localCurrentUser.currentUserId = firebaseUser.uid;
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      });
    }
  } catch (error) {
    print(error.toString());
  }
}
