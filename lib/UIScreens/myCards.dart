import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supercab/generated/l10n.dart';
import 'package:supercab/utils/constants.dart';

class MyCards extends StatefulWidget {
  @override
  _MyCardsState createState() => _MyCardsState();
}

class _MyCardsState extends State<MyCards> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _addressLineOneController = TextEditingController();
  final _addressLineTwoController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();

  CardFieldInputDetails _card;
  SetupIntent _setupIntentResult;
  static final HttpsCallable CREATE_INTENT =
      FirebaseFunctions.instance.httpsCallable('createsetupintent');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
          child: ListView(
            shrinkWrap: true,
            children: [
              SizedBox(
                height: 30,
              ),
              Center(child: Image.asset('assets/icons/mainLogo.png')),
              SizedBox(
                height: 30,
              ),
              Text(
                S.of(context).Email,
                style: TextStyle(color: white),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: _emailController,
                style: TextStyle(color: white),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(
                      color: white,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: white, width: 2),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                S.of(context).card_detail,
                style: TextStyle(color: white),
              ),
              SizedBox(
                height: 5,
              ),
              Theme(
                data: ThemeData.light().copyWith(),
                child: CardField(
                  onCardChanged: (card) {
                    setState(() {
                      _card = card;
                    });
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.1)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                        color: white,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: white, width: 2),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                S.of(context).Phone_Number,
                style: TextStyle(
                  color: white,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                keyboardType: TextInputType.phone,
                controller: _phoneNumberController,
                style: TextStyle(color: white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(
                      color: white,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: white, width: 2),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                S.of(context).city,
                style: TextStyle(
                  color: white,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                keyboardType: TextInputType.text,
                controller: _cityController,
                style: TextStyle(color: white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(
                      color: white,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: white, width: 2),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                S.of(context).Country,
                style: TextStyle(
                  color: white,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                keyboardType: TextInputType.text,
                controller: _countryController,
                style: TextStyle(color: white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(
                      color: white,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: white, width: 2),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                S.of(context).address_line_one,
                style: TextStyle(
                  color: white,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                keyboardType: TextInputType.text,
                controller: _addressLineOneController,
                style: TextStyle(color: white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(
                      color: white,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: white, width: 2),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                S.of(context).address_line_two,
                style: TextStyle(
                  color: white,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                keyboardType: TextInputType.text,
                controller: _addressLineTwoController,
                style: TextStyle(color: white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(
                      color: white,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: white, width: 2),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                S.of(context).State,
                style: TextStyle(
                  color: white,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                keyboardType: TextInputType.text,
                controller: _stateController,
                style: TextStyle(color: white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(
                      color: white,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: white, width: 2),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                S.of(context).postal_code,
                style: TextStyle(
                  color: white,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                keyboardType: TextInputType.text,
                controller: _postalCodeController,
                style: TextStyle(color: white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(
                      color: white,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: white, width: 2),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  child: RaisedButton(
                    color: yellow,
                    disabledColor: yellow.withOpacity(0.7),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    onPressed: _card != null && _card.complete
                        ? () async {
                            _handlePayPress();
                          }
                        : null,
                    child: Text(
                      S.of(context).Save_Card,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handlePayPress() async {
    if (_card == null) {
      return;
    }
    try {
      final clientSecret =
          await _createSetupIntentOnBackend(_emailController.text);

      final billingDetails = BillingDetails(
        email: _emailController.text,
        phone: _phoneNumberController.text,
        address: Address(
          city: _cityController.text,
          country: _countryController.text,
          line1: _addressLineOneController.text,
          line2: _addressLineTwoController.text,
          state: _stateController.text,
          postalCode: _postalCodeController.text,
        ),
      );
      await Stripe.instance
          .confirmSetupIntent(clientSecret,
              PaymentMethodParams.card(billingDetails: billingDetails))
          .then((value) {
        setState(() {
          _setupIntentResult = value;

          //  print(value.toString());
        });
      });
    } catch (error, s) {
      log('Error while saving payment', error: error, stackTrace: s);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error code: $error')));
    }
  }

  Future<String> _createSetupIntentOnBackend(String email) async {
    String client_key = '';
    HttpsCallableResult httpsCallableResult = await CREATE_INTENT
        .call({"email": email, "description": "this is test customer"}).then(
            (value) async {
      //customer: cus_JqQYN96GyBXuyO
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString("customerId", value.data['customer']);
      print("Andu Bakra " + sharedPreferences.getString("customerId"));

      return value;
    });

    client_key = httpsCallableResult.data['client_secret'];
    return client_key;
  }
}
