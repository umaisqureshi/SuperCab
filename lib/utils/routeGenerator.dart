import 'package:flutter/material.dart';
import 'package:supercab/UIScreens/promotions.dart';
import 'package:supercab/UIScreens/bookCab.dart';
import 'package:supercab/UIScreens/bookNow.dart';
import 'package:supercab/UIScreens/chooseVehicle.dart';
import 'package:supercab/UIScreens/contact.dart';
import 'package:supercab/UIScreens/estimationFare.dart';
import 'package:supercab/UIScreens/extraService.dart';
import 'package:supercab/UIScreens/getQuote.dart';
import 'package:supercab/UIScreens/history.dart';
import 'package:supercab/UIScreens/invoice.dart';
import 'package:supercab/UIScreens/landingScreen.dart';
import 'package:supercab/UIScreens/paymentDetail.dart';
import 'package:supercab/UIScreens/paymentOptions.dart';
import 'package:supercab/UIScreens/preBooking.dart';
import 'package:supercab/UIScreens/qrCode.dart';
import 'package:supercab/UIScreens/signIn.dart';
import 'package:supercab/UIScreens/signUp.dart';
import 'package:supercab/UIScreens/home.dart';
import 'package:supercab/UIScreens/myCards.dart';
import 'package:supercab/UIScreens/splashScreen.dart';
import 'package:supercab/UIScreens/onBoard.dart';
import 'package:supercab/UIScreens/user.dart';
import 'package:supercab/UIScreens/airportFare.dart';
import 'package:supercab/UIScreens/OTP.dart';
import 'package:supercab/UIScreens/Wallet.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/landing':
        return MaterialPageRoute(builder: (_) => LandingScreen());
      case '/splash':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      // case '/onBoard':
      //   return MaterialPageRoute(builder: (_) => OnBoard());
      case '/signUp':
        return MaterialPageRoute(builder: (_) => SignUp());
      case '/signIn':
        return MaterialPageRoute(builder: (_) => SignIn());
      case '/scanCard':
        return MaterialPageRoute(builder: (_) => MyCards());
      case '/home':
        return MaterialPageRoute(builder: (_) => Home());
      case '/user':
        return MaterialPageRoute(builder: (_) => User());
      case '/estFare':
        return MaterialPageRoute(builder: (_) => EstimationFare());
      case '/chooseVehicle':
        return MaterialPageRoute(
            builder: (_) => ChooseVehicle(transferType: args));
      case '/bookCab':
        return MaterialPageRoute(builder: (_) => BookCab());
      case '/qrCode':
        return MaterialPageRoute(builder: (_) => QRCode());
      case '/payDetail':
        return MaterialPageRoute(builder: (_) => PaymentDetail());
      case '/contact':
        return MaterialPageRoute(builder: (_) => Contact());
      case '/invoice':
        return MaterialPageRoute(builder: (_) => InvoiceBilling());
      case '/payOptions':
        return MaterialPageRoute(builder: (_) => PaymentOptions());
      case '/extraService':
        return MaterialPageRoute(builder: (_) => ExtraService());
      case '/getQuote':
        return MaterialPageRoute(builder: (_) => GetQuote());
      case '/history':
        return MaterialPageRoute(builder: (_) => History());
      case '/bookNow':
        return MaterialPageRoute(builder: (_) => BookNow());
      case '/preBooking':
        return MaterialPageRoute(builder: (_) => PreBooking());
      case '/airportFare':
        return MaterialPageRoute(builder: (_) => AirportFare());
      case '/promotions':
        return MaterialPageRoute(builder: (_) => Promotions());
      case '/wallet':
        return MaterialPageRoute(builder: (_) => Wallet());
      case '/OTP':
        return MaterialPageRoute(
            builder: (_) => OTP(
                  contactNumber: args,
                ));
      default:
        return null;
    }
  }
}
