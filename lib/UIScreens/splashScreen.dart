import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool check = false;
  bool isLocation = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3), () async {
      Navigator.pushReplacementNamed(context, '/landing');
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Container(
            decoration: BoxDecoration(
                image: new DecorationImage(
              fit: BoxFit.cover,
              image: new AssetImage("assets/icons/splashscreenone.png"),
            )),
            height: double.infinity,
            width: double.infinity,
            child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    image: new DecorationImage(
                  fit: BoxFit.cover,
                  image: new AssetImage("assets/icons/bg_shade.png"),
                )),
                child: Center(
                  child: Image.asset(
                    "assets/icons/mainLogo.png",
                    height: 200,
                    width: 200,
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
