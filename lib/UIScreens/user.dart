import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supercab/generated/l10n.dart';
import 'package:supercab/utils/constants.dart';
import 'package:supercab/UIScreens/drawer.dart';
import 'package:supercab/utils/userController.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'ShareScreen.dart';


class User extends StatefulWidget
{
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User>
{

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final Completer<WebViewController> _controller = Completer<WebViewController>();

  final privacyPolicyLink = "https://supercab.com.au/support/privacy-policy/";
  final termsAndConditionsLink = "https://supercab.com.au/support/terms-conditions/";
  final faqLink = "https://supercab.com.au/support/faqs/";
  final contactUsLink = "support@supercab.com.au";
  final emailLink = "mailto:support@supercab.com.au?subject=Greetings&body=Welcome%20To%20SuperCab";

  CurrentUser user;

  RateMyApp _rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 3,
    minLaunches: 7,
    remindDays: 2,
    remindLaunches: 5,
  );

  @override
  void initState() {
    super.initState();

    user = Get.find<CurrentUser>();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      key: _scaffoldKey,
      // drawer: SideDrawer(),
      body: Container(
        height: MediaQuery.of(context).size.height,
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                children:
                [
                  SizedBox(
                    height: 50,
                  ),

                  Center(child: Image.asset('assets/icons/mainLogo.png')),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () async
                    {
                      if(await canLaunch(privacyPolicyLink))
                        {
                          await launch(privacyPolicyLink);
                        }
                      else
                        {
                          throw 'Could not lauch $privacyPolicyLink';
                        }
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: white),
                          color: white.withOpacity(0.1)),
                      child: Center(
                        child: Text(
                          S.of(context).PRIVACY_POLICY,
                          style: TextStyle(
                            color: white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () async
                    {
                      if(await canLaunch(termsAndConditionsLink))
                      {
                      await launch(termsAndConditionsLink);
                      }
                      else
                      {
                      throw 'Could not lauch $termsAndConditionsLink';
                      }
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: white),
                          color: white.withOpacity(0.1)),
                      child: Center(
                        child: Text(
                          S.of(context).TERMS_AND_CONDITIONS,
                          style: TextStyle(
                            color: white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () async
                    {
                      if(await canLaunch(faqLink))
                      {
                      await launch(faqLink);
                      }
                      else
                      {
                      throw 'Could not lauch $faqLink';
                      }
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: white),
                          color: white.withOpacity(0.1)),
                      child: Center(
                        child: Text(
                          S.of(context).FAQ,
                          style: TextStyle(
                            color: white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: ()
                    {
                      showAboutDialog(
                        context: context,
                        applicationIcon: Image.asset('assets/icons/mainLogo.png',height: 40,width: 50,fit: BoxFit.fill,),
                        applicationVersion: '1.0.0',
                        applicationLegalese: 'Developed by Utechware team',
                        children: <Widget>
                        [
                          SizedBox(height: 15,),
                          Text('Australian owned Melbourne Based Chauffeur Car Network.'
                      ' SUPER CAB provides professional Chauffeur Transfers at the most competitive rates Australia wide '
                      'Skip the Taxi Queue , get pampered in Luxury Sedans, SUV, Buses with your private Chauffeur for'
                      ' your next trip whether traveling for business or leisure, airport, hotel, or events.'
                      ' The SUPER CAB app allows you to book, pay for, and manage all your rides with just a few taps.'
                      ' Use Promo code FIRST for 10% on your first ride. Referral System :  GET \$10 for every person you'
                      'share the app !! Isn’t that great ?'
                      'Airport Transfers, Weddings, Hourly hire, Stretch Limousines, Coaches, Winery Tours, Local Transfers and Events.',style: TextStyle(fontSize: 12),),
                        ]
                      );
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: white),
                          color: white.withOpacity(0.1)),
                      child: Center(
                        child: Text(
                          S.of(context).ABOUT,
                          style: TextStyle(
                            color: white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: ()
                    {
                      _rateMyApp.init().then((_)
                      {
                        _rateMyApp.showStarRateDialog(
                          context,
                          title: 'Do you like the app?',
                          message: 'Let us know what you think',
                          actionsBuilder: (context,stars)
                          {
                            return
                              [
                                FlatButton(
                                  child: Text('Ok'),
                                  onPressed: ()
                                  {
                                    if(stars != null)
                                    {
                                      _rateMyApp.save().then((value) => Navigator.of(context).pop());
                                    }
                                    else
                                    {
                                      Navigator.of(context).pop();
                                    }
                                  },
                                ),
                              ];
                          },
                          dialogStyle: DialogStyle(
                            titleAlign: TextAlign.center,
                            messageAlign: TextAlign.center,
                            messagePadding: EdgeInsets.all(20),
                          ),
                          starRatingOptions: StarRatingOptions(),
                        );
                      });
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: white),
                          color: white.withOpacity(0.1)),
                      child: Center(
                        child: Text(
                          S.of(context).RATE_OUR_APP,
                          style: TextStyle(
                            color: white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap : ()
                    {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_)=> ShareScreen()));
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: white),
                          color: white.withOpacity(0.1)),
                      child: Center(
                        child: Text(
                          S.of(context).SHARE_OUR_APP,
                          style: TextStyle(
                            color: white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () async
                    {
                      if(await canLaunch(emailLink))
                      {
                        await launch(emailLink);
                      }
                      else
                      {
                        throw 'Could not lauch $emailLink';
                      }
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: white),
                          color: white.withOpacity(0.1)),
                      child: Center(
                        child: Text(
                          S.of(context).CONTACT_US,
                          style: TextStyle(
                            color: white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(8, 40, 8, 20),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      child: RaisedButton(
                        color: yellow,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        onPressed: () async
                        {
                          SharedPreferences preferences = await SharedPreferences.getInstance();
                          preferences.clear();
                          user.alreadyGetDiscount = false;
                          await FirebaseAuth.instance.signOut();

                          Navigator.pushNamedAndRemoveUntil(context, "/signIn", (route) => false);
                        },
                        child: Text(
                          S.of(context).LOG_OUT,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
