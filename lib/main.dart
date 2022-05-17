import 'dart:io';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:supercab/utils/PaymentService.dart';
import 'package:supercab/utils/routeGenerator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supercab/generated/l10n.dart';
import 'package:supercab/utils/settings.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'utils/location_utils.dart';


main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Stripe.publishableKey = "pk_live_51IJcgHI3kUuPjRdVNvevID4sI4KaYo2HemI1xvt3ypMbaNmdXEZKAVtdoZ5CSoG1cPGzKZXA1iKHu5vtDRUQgcPX00ntlouHcv";
  Stripe.merchantIdentifier = Platform.isIOS ? 'test' : '17219220232680698158';
  //Stripe.stripeAccountId = "";
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _isCreateLink = false;

  String linkMessage;


  Future<void> createDynamicLink(bool short) async
  {
   setState(() {
     _isCreateLink = true;
   });
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: "https://mysupercab.page.link",
        link: Uri.parse("https://mysupercab.page.link/helloworld"),
        androidParameters: AndroidParameters(
          packageName: "com.example.super_cab",
          minimumVersion: 0,
        ),
        dynamicLinkParametersOptions: DynamicLinkParametersOptions(
            shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short
        ),
        socialMetaTagParameters: SocialMetaTagParameters(
            title: "Super Cab Link",
            description: "Description of SuperCab"
        )
    );

    Uri url;
    if(short)
      {
        final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
        url = shortDynamicLink.shortUrl;
      }
    else
      {
        url = await parameters.buildUrl();
      }

    setState(() {
      linkMessage = url.toString();
      _isCreateLink = false;
    });
  }

  getSHA1() async {
    await LocationUtils.getAppHeaders().then((value) => print(value['X-Android-Cert']));
  }

  @override
  void initState() {
    super.initState();
    getLanguage().then((value) {
      mobileLanguage.value = Locale(value,'');
      mobileLanguage.notifyListeners();
      print(value);
   //   getSHA1();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: mobileLanguage,
      builder:(context, Locale language,_)
      {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Super Cab',
            theme: ThemeData(
              primaryColor: Color.fromRGBO(250, 206, 0, 1),
              accentColor: Color.fromRGBO(250, 206, 0, 1),
              fontFamily: 'Montserrat',
              textTheme: TextTheme(),
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            locale: language,
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            initialRoute: '/splash',
            onGenerateRoute: RouteGenerator.generateRoute);
      } ,
    );
  }
}
