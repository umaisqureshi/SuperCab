import 'package:clipboard/clipboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supercab/generated/l10n.dart';
import 'package:supercab/utils/firebaseCredentials.dart';

import 'constants.dart';
import 'model/PromoCodeModel.dart';
import 'model/promoCardDataModel.dart';

class DialogModel extends StatefulWidget {
  @override
  _DialogModelState createState() => _DialogModelState();
}

class _DialogModelState extends State<DialogModel> {
  int expiryDate;
  String today = 'Today';

  final promoCodeController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  String promoCode;

  bool alreadyActivated = false;
  bool isOfferExpire = false;

  bool formValidation() {
    if (formKey.currentState.validate()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();

    //promoCode = shortid.generate();

    // print('***************');
    // print('Short ID : ' + promoCode.toString());
    // print('***************');
  }

  Future<Map<String, dynamic>>  getUser() async {
    return (await FirebaseCredentials()
            .firestore
            .collection('user')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .get())
        .data();
  }

  setUpFirstPromo(code) async {
    Map<String, dynamic> userData = await getUser();
    if (userData.containsKey('firstPromo') && userData['firstPromo']) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("You already used this promo code"),
        duration: Duration(seconds: 5),
      ));
    } else {
      PromoCodeDataModel promoModel = PromoCodeDataModel();
      bool alreadyActivated = await promoModel.isExist(code);
      if (!alreadyActivated) {
        promoModel
            .savePromoCode(PromoCodeDataModel.firstPromotion(code))
            .then((value) async {
          await FirebaseCredentials()
              .firestore
              .collection('user')
              .doc(FirebaseAuth.instance.currentUser.uid)
              .update({'firstPromo': true});
          print('Code Saved in Preferences');
          Navigator.of(context).pop();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
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
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            //color: yellow,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Form(
            key: formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Promo Code Activation",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 250,
                        child: TextFormField(
                          controller: promoCodeController,
                          autofocus: false,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            hintText: "Promo Code",
                            hintStyle: TextStyle(color: Colors.white),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Colors.white, width: 0.5)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Colors.white, width: 0.5)),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Colors.red, width: 0.5)),
                          ),
                          validator: (value) {
                            return value.isEmpty ? 'required' : null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.paste,
                          color: yellow,
                        ),
                        onPressed: () async {
                          promoCodeController.text =
                              await FlutterClipboard.paste();
                          print('Text Paste');
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Visibility(
                    visible: alreadyActivated,
                    child: Text(
                      S.of(context).Already_Activated_the_Offer,
                      style: TextStyle(color: Colors.red),
                    )),
                SizedBox(
                  height: 15,
                ),
                Visibility(
                    visible: isOfferExpire,
                    child: Text(S.of(context).Offer_is_Not_Available_Now,
                        style: TextStyle(color: Colors.red))),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ButtonTheme(
                      minWidth: 100,
                      height: 45,
                      child: RaisedButton(
                        onPressed: () async {
                          if (formValidation()) {
                            String code = promoCodeController.text;
                            if (code == firstRidePromoCode) {
                              await setUpFirstPromo(code);
                            }
                            else {
                              PromoCodeDataModel promoModel =
                                  PromoCodeDataModel();
                              await FirebaseCredentials()
                                  .firestore
                                  .collection('PromoCodes')
                                  .doc(code)
                                  .get()
                                  .then((value) async {
                                if (value.exists) {
                                  Map<String, dynamic> data = value.data();
                                  var model = getPromoCodeFromMap(data);
                                  bool isActiveAndNotExpire = await promoModel
                                      .isExpire(code, model.expiryDate);
                                  if (isActiveAndNotExpire) {
                                    await promoModel.savePromoCode(model).then(
                                        (value) => Navigator.of(context).pop());
                                  }else{
                                    final snackBar = SnackBar(content: Text('Promocode Expired!'));
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  }
                                }else{
                                  final snackBar = SnackBar(content: Text('Invalid Promocode!'));
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }
                              }).catchError((onError) =>
                                      print('Error Fetching Data'));
                            }
                          }
                        },
                        child: Text(
                          S.of(context).Activate,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        color: yellow,
                        elevation: 12.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                    ButtonTheme(
                      minWidth: 100,
                      height: 45,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          S.of(context).Cancel,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        color: yellow,
                        elevation: 12.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// send notification of discount offer to all users
// callOnFcmApiSendPushNotifications(id) async {
//   final postUrl = 'https://fcm.googleapis.com/fcm/send';
//
//   final data = {
//     "notification": {
//       "body": "New Discount From SuperCab",
//       "title": "New Booking"
//     },
//     "priority": "high",
//     "data": {
//       "click_action": "FLUTTER_NOTIFICATION_CLICK",
//       "status": "done",
//       "id": id,
//       "type" : 'promoCode'
//     },
//     "to": "\/topics\/superCabUser",
//   };
//
//   final headers = {
//     'content-type': 'application/json',
//     'Authorization':
//     'key=AAAAongebhA:APA91bH23Z8cjcfpQM4w7Aez1q6Dy5h3R2dr_V-jlj8NK7wU0VRT1X57wvpkO5bgP0KM2kTYOMwrk4b9pnVpWBv65jG72Z1K9uYpikoe7mb5KTdx_MsfA2DmsSWmxFAFuAhkWV6RvXCH'
//     // 'key=YOUR_SERVER_KEY'
//   };
//
//   try {
//     final response = await post(postUrl,
//         body: json.encode(data),
//         encoding: Encoding.getByName('utf-8'),
//         headers: headers);
//
//     if (response.statusCode == 200) {
//       print('CFM Succeed');
//       Navigator.of(context).pop();
//       return true;
//     } else {
//       print(response.body);
//       return false;
//     }
//   } catch (e) {
//     print(e.toString());
//   }
// }

}

class PromoCodeDataModal extends ModalRoute<PromoCodeModel> {
  @override
  Duration get transitionDuration => Duration(milliseconds: 400);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor {
    return Colors.white.withOpacity(0);
  }

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: SafeArea(
        minimum: EdgeInsets.only(top: 40),
        child: Scaffold(
          body: DialogModel(),
        ),
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    var begin = Offset(0.0, 1.0);
    var end = Offset.zero;
    var tween = Tween(begin: begin, end: end);
    Animation<Offset> offsetAnimation = animation.drive(tween);
    // You can add your own animations for the overlay content
    return SlideTransition(
      position: offsetAnimation,
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}
