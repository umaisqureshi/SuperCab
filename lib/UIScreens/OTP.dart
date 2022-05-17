import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:supercab/generated/l10n.dart';
import 'package:supercab/utils/constants.dart';
import 'package:supercab/utils/firebaseCredentials.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class OTP extends StatefulWidget {
  final String contactNumber;

  OTP({this.contactNumber});

  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  final codeController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool isEnable = false;

  String verificationId;

  @override
  void initState() {
    super.initState();
    phoneVerification(widget.contactNumber).then((value) {
      if (mounted)
        setState(() {
          verificationId = value;
          isEnable = true;
        });
    });
  }

  Future<String> phoneVerification(phoneNumber) async {
    final completer = Completer<String>();
    try {
      await FirebaseCredentials().auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: const Duration(seconds: 5),
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {},
          verificationFailed: (FirebaseAuthException authException) {
            completer.completeError(
                'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
          },
          codeSent: (String verificationId, [int forceResendingToken]) async {
            completer.complete(verificationId);
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            completer.complete(verificationId);
          });
    } catch (e) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 3),
        content: Text(
            "Failed to Verify Phone Number: ${e is FirebaseException ? e.message : e}"),
      ));
    }
    return completer.future;
  }

  void signInWithPhoneNumber(verificationId, code) async {
    print(FirebaseCredentials().auth.currentUser.phoneNumber);
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: code,
      );
      await FirebaseCredentials()
          .auth
          .currentUser
          .linkWithCredential(credential)
          .then((value) {
        Navigator.pushReplacementNamed(context, '/home');
      });
    } catch (e) {
      // ignore: deprecated_member_use
      scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 3),
        content: Text(
            "Failed to Verify Phone Number: ${e is FirebaseException ? e.message : e}"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        key: scaffoldKey,
          body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            image: new DecorationImage(
          fit: BoxFit.cover,
          image: new AssetImage("assets/icons/background.png"),
        )),
        child: Container(
          decoration: BoxDecoration(
              image: new DecorationImage(
            fit: BoxFit.cover,
            image: new AssetImage("assets/icons/bg_shade.png"),
          )),
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: white)),
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back_ios_outlined,
                          size: 12,
                          color: white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    child: Text(widget.contactNumber,
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      S.of(context).A_confirmation_code_has_been_sent_on_this_phone_number,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    child: TextFormField(
                        controller: codeController,
                        validator: (input) {
                          if (input.isEmpty)
                            return 'Required Field';
                          else
                            return null;
                        },
                        style: TextStyle(color: white),
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: white),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                              color: white,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: white, width: 2),
                          ),
                          hintText: S.of(context).Confirmation_Code,
                        )),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Container(
                        height: 50,
                        width: double.infinity,
                        child: RaisedButton(
                            color: yellow,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Text(
                              S.of(context).Check,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            onPressed: isEnable
                                ? () {
                                    signInWithPhoneNumber(
                                        verificationId, codeController.text);
                                  }
                                : null)),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      S.of(context).I_did_not_receive_confirmation_the_code,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
