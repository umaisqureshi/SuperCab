import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:supercab/UIScreens/home.dart';
import 'package:supercab/UIScreens/signIn.dart';
import 'package:supercab/utils/userController.dart';
import 'package:supercab/utils/firebaseCredentials.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  bool check = false;
  bool isLocation = false;
  bool isFirstTime = true;

  CurrentUser user = CurrentUser();

  @override
  void initState() {
    super.initState();
    if(mounted) {
      user = Get.put(CurrentUser());
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
        await Future.delayed(Duration.zero);
        if (FirebaseCredentials().auth.currentUser == null) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => SignIn()));
        } else {
          user.userEmail = FirebaseCredentials().auth.currentUser.email;
          user.currentUserId = FirebaseCredentials().auth.currentUser.uid;
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => Home()));
        }
      });

    /*
      Future.delayed(Duration(microseconds: 0), () async {
        _alignment = Alignment.bottomRight;
      });
      locationIcon();
      checkFirstTime();*/

    }
  }

  locationIcon() {
    Future.delayed(Duration(seconds: 4), () async {
      setState(() {
        isLocation = true;
      });
    });
  }

 /* checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      if (FirebaseCredentials().auth.currentUser == null) {
        Future.delayed(Duration(seconds: 5), () async {
          Navigator.of(context).pushReplacementNamed('/signIn');
        });
      }
      else {
        user.userEmail = FirebaseCredentials().auth.currentUser.email;
        user.currentUserId = FirebaseCredentials().auth.currentUser.uid;

        Future.delayed(Duration(seconds: 5), () async {
          Navigator.of(context).pushReplacementNamed('/home');
        });
      }
  }*/

  var _alignment = Alignment.bottomLeft;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                image: new DecorationImage(
              fit: BoxFit.cover,
              image: new AssetImage("assets/icons/mainBG.png"),
            )),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10, top: 0),
                    child: Image.asset(
                      "assets/icons/3.png",
                      height: 100,
                      // width: width,
                      // fit: BoxFi t.fill,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/icons/mainLogo.png",
                    height: 200,
                    width: 200,
                    // fit: BoxFit.fill,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    "assets/icons/road.png",
                    width: width,
                    fit: BoxFit.fill,
                  ),
                ),
                AnimatedContainer(
                  padding: EdgeInsets.all(10.0),
                  duration: Duration(milliseconds: 1000),
                  alignment: _alignment,
                  child: Container(
                    height: 70.0,
                    child: Image.asset(
                      "assets/icons/2.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                isLocation
                    ? Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: Image.asset(
                            "assets/icons/location.png",
                            height: 50,
                            // width: width,
                            fit: BoxFit.fill,
                          ),
                        ),
                      )
                    : SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
