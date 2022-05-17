import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supercab/DataSource/Source.dart';
import 'package:supercab/Invoices/AirportTransferInvoice.dart';
import 'package:supercab/Invoices/HourlyTransferInvoice.dart';
import 'package:supercab/Invoices/LocalTransferInvoice.dart';
import 'package:supercab/UIScreens/bookNow.dart';
import 'package:supercab/UIScreens/home.dart';
import 'package:supercab/generated/l10n.dart';
import 'package:supercab/utils/PaymentService.dart';
import 'package:supercab/utils/constants.dart';
import 'package:supercab/utils/firebaseCredentials.dart';
import 'package:supercab/utils/model/promoCardDataModel.dart';
import 'package:supercab/utils/userController.dart';
import 'package:supercab/widgets/radio_group.dart';
import 'package:pay/pay.dart' as pay;

enum BookingStatusEnum { PENDING, ACCEPT, DECLINE }

extension BookingStatusEnumName on BookingStatusEnum {
  String name() {
    return this.index == 0
        ? "Pending"
        : this.index == 1
            ? "Accept"
            : this.index == 2
                ? "Decline"
                : "";
  }
}

enum BookingCar { BUSINESS_SEDAN, EUROPEAN_PRESTIGE, SUV, MINI_VAN }

extension BookingCarEnumName on BookingCar {
  String name() {
    return this.index == 0
        ? "Business Sedan"
        : this.index == 1
            ? "European Prestige"
            : this.index == 2
                ? "Suv"
                : this.index == 3
                    ? "Mini Van"
                    : "";
  }
}

class BookCab extends StatefulWidget {
  @override
  _BookCabState createState() => _BookCabState();
}

class _BookCabState extends State<BookCab> {
  bool busniessCheck = false;
  bool checkBalance = false;
  String selectedPaymentMethod;

  final nameController = TextEditingController();
  final phController = TextEditingController();
  final emailController = TextEditingController();
  final selectedController = TextEditingController();
  final tripController = TextEditingController();

  final promoCodeController = TextEditingController();
  final totalAmountController = TextEditingController();

  final businessNameController = TextEditingController();
  final contactNameController = TextEditingController();
  final billingAddressController = TextEditingController();
  final stateNameController = TextEditingController();
  final countryNameController = TextEditingController();
  final businessPhoneController = TextEditingController();
  final businessEmailController = TextEditingController();

  SharedPreferences preferences;
  StripeService service = StripeService();

  bool visaCard = false;
  bool masterCard = false;
  bool discoverCard = false;
  bool americanCard = false;
  bool googlePayCard = false;
  bool applePayCard = false;
  bool isPayOnPickUp = false;
  CurrentUser user;
  bool alreadyActivated = false;
  bool isOfferAvailable = false;
  bool isPaymentMethodSelected = false;
  List<String> airPortFareVehiclePrice = [];
  List<String> hourTransferVehiclePrice = [];
  List<String> vehiclePrice;
  int offerDiscount = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic> _paymentSheetData;
  static final HttpsCallable PAYMENT_SHEET =
      FirebaseFunctions.instance.httpsCallable('paymenttsheet');
  static final HttpsCallable SETUP_INTENT =
      FirebaseFunctions.instance.httpsCallable('createsetupintent');

  var grpVal = RadioButtonBuilder(
      title: "Credit/Debit Card",
      textPosition: RadioButtonTextPosition.left,
      colors: Colors.white,
      list: [
        Image.asset(
          'assets/icons/visacard.png',
          width: 30,
          height: 30,
        ),
        Image.asset(
          'assets/icons/mastercard.png',
          width: 30,
          height: 30,
        ),
        Image.asset(
          'assets/icons/discoverCard.jpg',
          width: 30,
          height: 30,
        ),
        Image.asset(
          'assets/icons/americanExpress.png',
          width: 30,
          height: 30,
        ),
      ]);

  List<RadioButtonBuilder> list = [
    RadioButtonBuilder(
        title: "Credit/Debit Card",
        textPosition: RadioButtonTextPosition.left,
        colors: Colors.white,
        list: [
          Image.asset(
            'assets/icons/banks.png',
            height: 50,
            width: 150,
            fit: BoxFit.fill,
          ),
          // Image.asset('assets/icons/visacard.png',width: 30,height: 30,),
          // Image.asset('assets/icons/mastercard.png',width: 30,height: 30,),
          // Image.asset('assets/icons/discoverCard.jpg',width: 30,height: 30,),
          // Image.asset('assets/icons/americanExpress.png',width: 30,height: 30,),
        ]),
    RadioButtonBuilder(
        title: Platform.isIOS ? "Apple Pay" : "Google Pay",
        textPosition: RadioButtonTextPosition.left,
        colors: Colors.white,
        list: [
          Image.asset(
            Platform.isIOS
                ? 'assets/icons/applePay.jpg'
                : 'assets/icons/googlePay.png',
            width: 70,
            height: 70,
          ),
        ]),
    RadioButtonBuilder(
        title: "Pay On Pickup",
        textPosition: RadioButtonTextPosition.left,
        colors: Colors.white,
        list: [
          Image.asset(
            'assets/icons/cabcharge.png',
            width: 100,
            height: 70,
            fit: BoxFit.fill,
          ), //PayOnPickUp.png
        ]),
  ];

  Future<Map<String, dynamic>> _createPaymentSheet(price) async {
    HttpsCallableResult httpsCallableResult =
        await PAYMENT_SHEET.call({'amount': price, 'currency': 'aud'});
    return httpsCallableResult.data;
  }

  Future<Map<String, dynamic>> _createPaymentIntent(price) async {
    HttpsCallableResult httpsCallableResult = await SETUP_INTENT.call({
      'amount': price,
      'currency': 'aud',
      'email': user.userEmail,
      'description': user.userName
    });
    return httpsCallableResult.data;
  }

  Future<void> _initPaymentSheet(price, transferType, timeStamp, bookingStatus,
      invoiceStatus, invoiceNumber) async {
    try {
      _paymentSheetData = await _createPaymentSheet(price);
      if (_paymentSheetData['error'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error code: ${_paymentSheetData['error']}')));
        return;
      }
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          applePay: true,
          googlePay: true,
          style: ThemeMode.dark,
          merchantCountryCode: "AU",
          merchantDisplayName: user.userName,
          customerId: _paymentSheetData['paymentIntent']['customer'],
          paymentIntentClientSecret: _paymentSheetData['paymentIntent']
              ['client_secret'],
          customerEphemeralKeySecret: _paymentSheetData['ephemeralKey']['id'],
        ),
      );
      _displayPaymentSheet(
          transferType, timeStamp, bookingStatus, invoiceStatus, invoiceNumber);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }

  Future<void> _displayPaymentSheet(transferType, timeStamp, bookingStatus,
      invoiceStatus, invoiceNumber) async {
    try {
      await Stripe.instance
          .presentPaymentSheet(
              parameters: PresentPaymentSheetParameters(
        clientSecret: _paymentSheetData['paymentIntent']['client_secret'],
        confirmPayment: true,
      ))
          .then((value) async {
        await Stripe.instance.confirmPaymentSheetPayment().then((value) {
          uploadData(transferType, timeStamp, bookingStatus, invoiceStatus,
              invoiceNumber);
        }).catchError((error) {
          print("not confirm");
        });
      });
      setState(() {
        _paymentSheetData = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$e'),
        ),
      );
      rethrow;
    }
  }

  uploadData(
      transferType, timeStamp, bookingStatus, invoiceStatus, invoiceNumber) {
    var id = FirebaseCredentials().firestore.collection('booknow').doc().id;
    FirebaseCredentials().firestore.collection('booknow').doc(id).set({
      'payment_type': selectedPaymentMethod,
      'name': nameController.text,
      'phone': phController.text,
      'email': emailController.text,
      'from': user.userCurrentAddress,
      'to': user.userDestinationAddress,
      'vehicle': user.selectedVehicle, // vehicleController
      'tripCost': user.selectedVehiclePrice, //costController
      'day': user.localBookingDate, //bookingDate
      'time': user.localBookingTime, //_time
      'comments': user.localBookingComments,
      'currentUserID': user.currentUserId,
      'transferType': transferType,
      'timeStamp': timeStamp,
      'bookingStatus': bookingStatus,
      'invoiceStatus': invoiceStatus,
      'invoiceNumber': invoiceNumber,
      // new code
      'isBusinessCheck': busniessCheck,
      'businessName': !busniessCheck ? businessNameController.text : "No",
      'businessContactName': !busniessCheck ? contactNameController.text : "No",
      'billingAddress': !busniessCheck ? billingAddressController.text : "No",
      'state': !busniessCheck ? stateNameController.text : "No",
      'country': !busniessCheck ? countryNameController.text : "No",
      'businessPhone': !busniessCheck ? businessPhoneController.text : "No",
      'businessEmail': !busniessCheck ? businessEmailController.text : "No",
    }).then((value) async {
      callOnFcmApiSendPushNotificationsForLocalBooking(
          user.userDestinationAddress, user.userCurrentAddress, id);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: yellow,
              title: Center(
                  child: Text(
                S.of(context).Thank_You,
                style: TextStyle(color: Colors.black),
              )),
              content: Text(
                S.of(context).Booking_Confirmation_Message,
                style: TextStyle(color: Colors.black),
              ),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      S.of(context).Ok,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )),
              ],
            );
          }).then((value) {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => Home()));
      });
    });
  }

  int calculateCost() {
    if (user.isLocalTransfer) {
      return user.totalCostOfLocalTransfer;
    }
    if (user.isHourlyTransfer) {
      int totalCost = user.selectedVehiclePrice * user.selectedHours;
      return totalCost;
    }
    if (user.isAirportTransfer) {
      int totalCost = user.selectedVehiclePrice;
      return totalCost;
    }
    return 0;
    //return user.selectVehiclePrice;
  }

  void getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await FirebaseCredentials()
        .firestore
        .collection('user')
        .doc(user.currentUserId)
        .get()
        .then((value) {
      if (value.exists) {
        Map<String, dynamic> data = value.data();
        nameController.text = data['name'];
        emailController.text = data['email'];
        phController.text = data['phone'];
        /*if(value.data().containsKey("firstPromo") && value.data()['firstPromo']){
          user.alreadyGetDiscount = true;
        }else
          user.alreadyGetDiscount = false;*/
      }
    }).catchError((onError) => print('Error Fetching Data'));

    /*if(prefs.containsKey("alreadyGetDiscount")){
      user.alreadyGetDiscount = prefs.getBool("alreadyGetDiscount");
    }*/
  }

  Future<void> onGooglePayResult(paymentResult, price, transferType, timeStamp,
      bookingStatus, invoiceStatus, invoiceNumber) async {
    try {
      final response = await _createPaymentIntent(price);
      final clientSecret = response['paymentIntent']['client_secret'];
      final token =
          paymentResult['paymentMethodData']['tokenizationData']['token'];
      final tokenJson = Map.castFrom(json.decode(token));
      print(tokenJson);

      final params = PaymentMethodParams.cardFromToken(
        token: tokenJson['id'],
      );
      final status = await Stripe.instance.confirmPaymentMethod(
        clientSecret,
        params,
      );
      if (status.status == PaymentIntentsStatus.Succeeded) {
        uploadData(transferType, timeStamp, bookingStatus, invoiceStatus,
            invoiceNumber);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  googlePay(
      transferType, timeStamp, bookingStatus, invoiceStatus, invoiceNumber) {
    final price = (user.selectedVehiclePrice * 100).toString();
    final _pay = pay.Pay.withAssets(['google_pay_payment_profile.json']);

    _pay.showPaymentSelector(paymentItems: [
      pay.PaymentItem(
          // label: 'Total',
          amount: price,
          status: pay.PaymentItemStatus.final_price,
          type: pay.PaymentItemType.total)
    ]).then((value) {
      onGooglePayResult(value, price, transferType, timeStamp, bookingStatus,
          invoiceStatus, invoiceNumber);
    });
  }

  void localTransferDataSubmit() async {
    String transferType = "LocalTransfer";

    var rng = new Random();
    var invoiceNumber = rng.nextInt(900000) + 100000;

    bool isBookingPlaced = await Navigator.of(context).push(InvoiceDataModal(
        passengerName: nameController.text,
        passengerEmail: emailController.text,
        phoneNumber: phController.text,
        date: user.localBookingDate,
        time: user.localBookingTime,
        from: user.userCurrentAddress,
        to: user.userDestinationAddress,
        cost: user.selectedVehiclePrice.toString(),
        bookingType: transferType,
        invoiceNumber: invoiceNumber,
        isBusinessCheck: busniessCheck,
        businessName: businessNameController.text,
        businessPhone: businessPhoneController.text,
        businessContact: contactNameController.text,
        businessEmail: businessEmailController.text,
        state: stateNameController.text,
        country: countryNameController.text,
        billingAddress: billingAddressController.text));

    if (isBookingPlaced != null && isBookingPlaced) {
      var timeStamp = DateTime.now().millisecondsSinceEpoch;
      String bookingStatus = BookingStatusEnumForLocal.PENDING.name();
      String invoiceStatus = "Not Send";

      if (selectedPaymentMethod == "Credit/Debit Card") {
        _initPaymentSheet(
            (user.selectedVehiclePrice * 100).toString(),
            transferType,
            timeStamp,
            bookingStatus,
            invoiceStatus,
            invoiceNumber);
      } else if (selectedPaymentMethod == "Pay On Pickup") {
        uploadData(transferType, timeStamp, bookingStatus, invoiceStatus,
            invoiceNumber);
      } else if (selectedPaymentMethod == "Google Pay") {
        googlePay(transferType, timeStamp, bookingStatus, invoiceStatus,
            invoiceNumber);
      }
    }
  }

  void prebookingSubmit() async {
    String transferType = "Local Transfer";
    var rng = new Random();
    var invoiceNumber = rng.nextInt(900000) + 100000;

    bool isBookingPlaced = await Navigator.of(context).push(InvoiceDataModal(
        passengerName: nameController.text,
        passengerEmail: emailController.text,
        phoneNumber: phController.text,
        date: user.preBookingDate,
        time: user.preBookingTime,
        from: user.userCurrentAddress,
        to: user.userDestinationAddress,
        cost: user.selectedVehiclePrice.toString(),
        bookingType: transferType,
        invoiceNumber: invoiceNumber,

        // new code
        isBusinessCheck: busniessCheck,
        businessName: businessNameController.text,
        businessPhone: businessPhoneController.text,
        businessContact: contactNameController.text,
        businessEmail: businessEmailController.text,
        state: stateNameController.text,
        country: countryNameController.text,
        billingAddress: billingAddressController.text));

    if (isBookingPlaced != null && isBookingPlaced) {
      var timeStamp = DateTime.now().millisecondsSinceEpoch;
      String bookingStatus = 'Pending';
      String invoiceStatus = "Not Send";

      if (selectedPaymentMethod == "Credit/Debit Card") {
        _initPaymentSheet(
            (user.selectedVehiclePrice * 100).toString(),
            transferType,
            timeStamp,
            bookingStatus,
            invoiceStatus,
            invoiceNumber);
      } else if (selectedPaymentMethod == "Pay On Pickup") {
        uploadData(transferType, timeStamp, bookingStatus, invoiceStatus,
            invoiceNumber);
      } else if (selectedPaymentMethod == "Google Pay") {
        googlePay(transferType, timeStamp, bookingStatus, invoiceStatus,
            invoiceNumber);
      }
    }
  }

  void hourlyDataSubmit() async {
    var rng = new Random();
    var invoiceNumber = rng.nextInt(900000) + 100000;

    String transferType = "HourlyTransfer";
    String city = cityNamesList(context)[user.selectedCity].name;

    bool isBookingPlaced =
        await Navigator.of(context).push(HourlyTransferInvoiceDataModal(
            passengerName: nameController.text,
            passengerEmail: emailController.text,
            phoneNumber: phController.text,
            date: user.hourlyBookingDate,
            time: user.hourlyBookingTime,
            city: city,
            hours: user.selectedHours.toString(),
            cost: user.selectedVehiclePrice.toString(),
            bookingType: transferType,
            invoiceNumber: invoiceNumber,

            // new code
            isBusinessCheck: busniessCheck,
            businessName: businessNameController.text,
            businessPhone: businessPhoneController.text,
            businessContact: contactNameController.text,
            businessEmail: businessEmailController.text,
            state: stateNameController.text,
            country: countryNameController.text,
            billingAddress: billingAddressController.text));

    if (isBookingPlaced != null && isBookingPlaced) {
      var timeStamp = DateTime.now().millisecondsSinceEpoch;

      String bookingStatus = BookingStatusEnum.PENDING.name();
      String invoiceStatus = "Not Send";

      if (selectedPaymentMethod == "Credit/Debit Card") {
        _initPaymentSheet(
            (user.selectedVehiclePrice * 100).toString(),
            transferType,
            timeStamp,
            bookingStatus,
            invoiceStatus,
            invoiceNumber);
      } else if (selectedPaymentMethod == "Pay On Pickup") {
        uploadData(transferType, timeStamp, bookingStatus, invoiceStatus,
            invoiceNumber);
      } else if (selectedPaymentMethod == "Google Pay") {
        googlePay(transferType, timeStamp, bookingStatus, invoiceStatus,
            invoiceNumber);
      }
    }
  }

  void airportDataSubmit() async {
    String transferType = "AirportFare";

    var rng = new Random();
    var invoiceNumber = rng.nextInt(900000) + 100000;

    var timeStamp = DateTime.now().millisecondsSinceEpoch;
    String bookingStatus = 'Pending';
    String invoiceStatus = "Not Send";
    String destination = 'City';

    if (user.fromCityToAirport) {
      destination = user.userCurrentAddress;
    }
    if (user.fromMelbourneAirportsToAreas) {
      destination = user.areaNameForAirport;
    }

    String airportName;
    if (user.fromCityToAirport) {
      airportName = airPortNamesList(context)[user.selectedAirport].name;
    } else {
      airportName = airPortNamesListForCity(context)[user.selectedAirport].name;
    }

    bool isBookingPlaced =
        await Navigator.of(context).push(AirportTransferInvoiceDataModal(
            passengerName: nameController.text,
            passengerEmail: emailController.text,
            phoneNumber: phController.text,
            date: user.airportBookingDate,
            time: user.airportBookingTime,
            from: destination,
            airport: airportName,
            cost: user.selectedVehiclePrice.toString(),
            bookingType: transferType,
            isFromCityToAirport: user.fromCityToAirport,
            invoiceNumber: invoiceNumber,

            // new code
            isBusinessCheck: busniessCheck,
            businessName: businessNameController.text,
            businessPhone: businessPhoneController.text,
            businessContact: contactNameController.text,
            businessEmail: businessEmailController.text,
            state: stateNameController.text,
            country: countryNameController.text,
            billingAddress: billingAddressController.text));

    if (isBookingPlaced != null && isBookingPlaced) {
      if (selectedPaymentMethod == "Credit/Debit Card") {
        _initPaymentSheet(
            (user.selectedVehiclePrice * 100).toString(),
            transferType,
            timeStamp,
            bookingStatus,
            invoiceStatus,
            invoiceNumber);
      } else if (selectedPaymentMethod == "Pay On Pickup") {
        uploadData(transferType, timeStamp, bookingStatus, invoiceStatus,
            invoiceNumber);
      } else if (selectedPaymentMethod == "Google Pay") {
        googlePay(transferType, timeStamp, bookingStatus, invoiceStatus,
            invoiceNumber);
      }
    }
  }

  int calculateDiscount(int actualPrice) {
    int price = actualPrice;
    int newPrice = 0;

    int discount = ((offerDiscount / 100) * price).toInt();
    newPrice = price - discount;

    return newPrice;
  }

  void offerAvailablePriceMethod(int actualPrice) {
    user.selectedVehiclePrice = calculateDiscount(actualPrice);
    totalAmountController.text = user.selectedVehiclePrice.toString();
    print('###### Discounted price : ' + user.selectedVehiclePrice.toString());
  }

  void offerNotAvailablePriceMethod(int actualPrice) {
    user.selectedVehiclePrice = actualPrice;
    totalAmountController.text = user.selectedVehiclePrice.toString();
    print('###### Non - Discounted price : ' +
        user.selectedVehiclePrice.toString());
  }

  Future<void> init() async {
    preferences = await SharedPreferences.getInstance();

    if (preferences.containsKey('promoCode')) {
      PromoCodeDataModel model = PromoCodeDataModel.fromJson(
          json.decode(preferences.get('promoCode')));
      if (model.promoCode != firstRidePromoCode &&
          model.expiryDate < DateTime.now().millisecondsSinceEpoch) {
        user.alreadyGetDiscount = false;
        preferences.remove('promoCode');
        //preferences.remove("alreadyGetDiscount");
      } else if (model.totalRides > 0) {
        offerDiscount = model.discount;

        if (offerDiscount > 0) {
          user.alreadyGetDiscount = true;
          offerAvailablePriceMethod(user.selectedVehiclePrice);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Promo Code Applied!",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            duration: Duration(seconds: 5),
            elevation: 4,
          ));
          preferences.setBool("alreadyGetDiscount", user.alreadyGetDiscount);
        } else {
          offerNotAvailablePriceMethod(user.selectedVehiclePrice);
        }
      } else {
        offerNotAvailablePriceMethod(user.selectedVehiclePrice);
        user.alreadyGetDiscount = false;
        //preferences.setBool("alreadyGetDiscount", user.alreadyGetDiscount);
      }
    } else {
      offerNotAvailablePriceMethod(user.selectedVehiclePrice);
    }
  }

  @override
  void initState() {
    super.initState();
    user = Get.find<CurrentUser>();
    getUserInfo();
    selectedController.text = user.selectedVehicle;
    tripController.text = '\$ ' + user.selectedVehiclePrice.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: BoxDecoration(
            image: new DecorationImage(
          fit: BoxFit.cover,
          image: new AssetImage("assets/icons/background.png"),
        )),
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: new DecorationImage(
            fit: BoxFit.cover,
            image: new AssetImage("assets/icons/bg_shade.png"),
          )),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/icons/mainLogo.png',
                      height: 150,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    S.of(context).Contact_Details,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.yellow,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Flexible(
                        child: new TextField(
                            controller: nameController,
                            style: TextStyle(color: white),
                            decoration: InputDecoration(
                              hintText: 'Name',
                              hintStyle: TextStyle(color: white),
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
                            )),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      new Flexible(
                        child: new TextField(
                            controller: phController,
                            style: TextStyle(color: white),
                            decoration: InputDecoration(
                              hintText: '${S.of(context).phone}:',
                              hintStyle: TextStyle(color: white),
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
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: emailController,
                    style: TextStyle(color: white),
                    decoration: InputDecoration(
                      hintText: 'smith@gmail.com',
                      hintStyle: TextStyle(color: white),
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
                  TextField(
                    controller: selectedController,
                    style: TextStyle(color: white),
                    decoration: InputDecoration(
                      hintText: '${S.of(context).Selected_vehicle_class}',
                      hintStyle: TextStyle(color: white),
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
                  TextField(
                    controller: tripController,
                    style: TextStyle(color: white),
                    decoration: InputDecoration(
                      hintText: '${S.of(context).Trip_Cost} :',
                      hintStyle: TextStyle(color: white),
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
                    height: 20,
                  ),
                  Text(
                    S.of(context).Invoice_Billing_Details,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.yellow,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        S.of(context).Same_as_above,
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Theme(
                        data: Theme.of(context).copyWith(
                          unselectedWidgetColor: Colors.white,
                        ),
                        child: Checkbox(
                            checkColor: Colors.black,
                            activeColor: yellow,
                            value: busniessCheck,
                            onChanged: (value) {
                              setState(() {
                                busniessCheck = value;
                              });
                            }),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Flexible(
                        child: new TextField(
                            style: TextStyle(color: white),
                            controller: businessNameController,
                            enabled: busniessCheck ? false : true,
                            decoration: InputDecoration(
                              hintText: S.of(context).company_Name,
                              hintStyle: TextStyle(color: white),
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
                            )),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      new Flexible(
                        child: new TextField(
                            style: TextStyle(color: white),
                            controller: contactNameController,
                            enabled: busniessCheck ? false : true,
                            decoration: InputDecoration(
                              hintText: S.of(context).Contact_Name,
                              hintStyle: TextStyle(color: white),
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
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    style: TextStyle(color: white),
                    controller: billingAddressController,
                    enabled: busniessCheck ? false : true,
                    decoration: InputDecoration(
                      hintText: S.of(context).Billing_Address,
                      hintStyle: TextStyle(color: white),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Flexible(
                        child: new TextField(
                            controller: stateNameController,
                            enabled: busniessCheck ? false : true,
                            style: TextStyle(color: white),
                            decoration: InputDecoration(
                              hintText: S.of(context).State,
                              hintStyle: TextStyle(color: white),
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
                            )),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      new Flexible(
                        child: new TextField(
                            controller: countryNameController,
                            enabled: busniessCheck ? false : true,
                            style: TextStyle(color: white),
                            decoration: InputDecoration(
                              hintText: S.of(context).Country,
                              hintStyle: TextStyle(color: white),
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
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Flexible(
                        child: new TextField(
                            controller: businessPhoneController,
                            enabled: busniessCheck ? false : true,
                            style: TextStyle(color: white),
                            decoration: InputDecoration(
                              hintText: 'Ph:',
                              hintStyle: TextStyle(color: white),
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
                            )),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      new Flexible(
                        child: new TextField(
                            controller: businessEmailController,
                            enabled: busniessCheck ? false : true,
                            style: TextStyle(color: white),
                            decoration: InputDecoration(
                              hintText: S.of(context).Email,
                              hintStyle: TextStyle(color: white),
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
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.of(context).Payment_Option,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.yellow,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RadioGroup<RadioButtonBuilder>.builder(
                        groupValue: grpVal,
                        onChanged: (value) {
                          setState(() {
                            print(value.title);
                            grpVal = value;
                            selectedPaymentMethod = value.title;
                            isPaymentMethodSelected = true;
                          });
                        },
                        items: list,
                        itemBuilder: (item) => RadioButtonBuilder(
                            title: item.title,
                            list: item.list,
                            textPosition: item.textPosition,
                            colors: item.colors),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '${S.of(context).Promo_Code}',
                            style: TextStyle(color: Colors.white),
                          ),
                          new Flexible(
                            child: Container(
                              width: 200,
                              child: new TextField(
                                  controller: promoCodeController,
                                  style: TextStyle(color: white),
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(color: white),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: BorderSide(
                                        color: white,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide:
                                          BorderSide(color: white, width: 2),
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    width: double.infinity,
                    child: RaisedButton(
                      color: yellow,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      onPressed: () async {
                        if (isPaymentMethodSelected) {
                          bool isAvailable = (await checkIsPromoAvailable());
                          if (isAvailable) {
                            await init();
                          }
                          if (user.isLocalTransfer) {
                            localTransferDataSubmit();
                          } else if (user.isLocalTransferPreBooking) {
                            prebookingSubmit();
                          } else if (user.isHourlyTransfer) {
                            hourlyDataSubmit();
                          } else if (user.isAirportTransfer) {
                            airportDataSubmit();
                          } else {
                            print('***************** Invalid Booking type');
                          }
                        } else {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text('First Select Payment Method...'),
                          ));
                        }
                      },
                      child: Text(
                        S.of(context).Place_Booking,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> checkIsPromoAvailable() async {
    final prefs = await SharedPreferences.getInstance();

    String promoCode = promoCodeController.text;
    if (promoCode.isEmpty) return false;

    if (promoCode == firstRidePromoCode) {
      var userData = (await FirebaseCredentials()
              .firestore
              .collection('user')
              .doc(FirebaseAuth.instance.currentUser.uid)
              .get())
          .data();
      if (userData.containsKey('firstPromo') && userData['firstPromo']) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "You already used this promo code",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          duration: Duration(seconds: 5),
        ));
        await prefs.setBool("alreadyGetDiscount", false);
        return false;
      } else {
        Map<String, dynamic> data = {
          "comment": "First Ride Offer",
          "discount": 10,
          "expiryDate": 1620435246,
          "promoCode": firstRidePromoCode,
          "totalRides": 1
        };
        PromoCodeDataModel model = PromoCodeDataModel.fromJson(data);
        final prefs = await SharedPreferences.getInstance();
        if (prefs.containsKey('promoCode')) {
          PromoCodeDataModel newModel =
              PromoCodeDataModel.fromJson(json.decode(prefs.get('promoCode')));
          alreadyActivated = newModel.promoCode == promoCode;
        }
        if (!alreadyActivated) {
          String jsonObject = json.encode(model.toMap());
          prefs.setString('promoCode', jsonObject).then((value) async {
            await FirebaseCredentials()
                .firestore
                .collection('user')
                .doc(FirebaseAuth.instance.currentUser.uid)
                .update({'firstPromo': true});
            print('Code Saved in Preferences for first ride discount');
            //Navigator.of(context).pop();
          });
          return true;
        }
        // else return false;
      }
    } else {
      var value = (await FirebaseCredentials()
          .firestore
          .collection('PromoCodes')
          .doc(promoCode)
          .get());

      if (!value.exists) return false;
      print('Data Exist');
      Map<String, dynamic> data = value.data();
      var model = PromoCodeDataModel.fromJson(data);

      if (prefs.containsKey('promoCode')) {
        PromoCodeDataModel newModel =
            PromoCodeDataModel.fromJson(json.decode(prefs.get('promoCode')));
        alreadyActivated = newModel.promoCode == model.promoCode;
      }
      isOfferAvailable =
          DateTime.now().millisecondsSinceEpoch >= (model.expiryDate);

      return (alreadyActivated || isOfferAvailable)
          ? false
          : prefs.setString('promoCode', json.encode(model.toMap()));
    }
    return false;
  }

  // Future<bool> checkIsPromoAvailable() async
  // {
  //   final prefs = await SharedPreferences.getInstance();
  //
  //   String promoCode = promoCodeController.text;
  //   if(promoCode.isEmpty)return false;
  //   var value =  (await FirebaseCredentials()
  //       .firestore
  //       .collection('PromoCodes')
  //       .doc(promoCode)
  //       .get());
  //
  //   if (!value.exists)return false;
  //     print('Data Exist');
  //     Map<String, dynamic> data = value.data();
  //     var model =  PromoCodeDataModel.fromJson(data);
  //
  //     bool promoStatus = await getPromoCodeStatus();
  //     if(!promoStatus)
  //       {
  //
  //       }
  //
  //     if(prefs.containsKey('promoCode'))
  //     {
  //       PromoCodeDataModel newModel = PromoCodeDataModel.fromJson(json.decode(prefs.get('promoCode')));
  //       alreadyActivated = newModel.promoCode == model.promoCode;
  //     }
  //     isOfferAvailable = DateTime.now().millisecondsSinceEpoch >= (model.expiryDate);
  //
  //   return (alreadyActivated || isOfferAvailable)
  //       ? false
  //       : prefs.setString('promoCode', json.encode(model.toJson()));
  // }

  /*Future<bool> userPaymentMethods(int amount) async {
    final prefs = await SharedPreferences.getInstance();

    if (selectedPaymentMethod == "Credit/Debit Card") {
      if (prefs.containsKey(creditCardKey)) {
        try {
          var totalCost = amount * 100;
          PaymentMethod payment = PaymentMethod.fromJson(
              json.decode(prefs.getString(paymentMethod)));
          print("Customer Id :::::::::::::::::::::::::::::::::: ${payment.customerId}");
          await service.confirmPayment(
              amount: totalCost.toString(),
              currency: 'usd',
              id: payment.id,
              customerId: payment.customerId);
          return true;
        } catch (error) {
          return false;
        }
      } else {
        bool isCardInfoGet =
            await Navigator.of(context).push(CardInfoDataModel());
        if (isCardInfoGet != null && isCardInfoGet) {
          if (prefs.containsKey(creditCardKey)) {
            try {
              var totalCost = amount * 100;
              PaymentMethod payment = PaymentMethod.fromJson(
                  json.decode(prefs.getString(paymentMethod)));
              print("Customer Id BookNow :::::::::::::::::::::::::::::::::: ${payment.customerId}");
              await service.confirmPayment(
                  amount: totalCost.toString(),
                  currency: 'usd',
                  id: payment.id,
                  customerId: payment.customerId);
              return true;
            } catch (error) {
              return false;
            }
          }
          return false;
        }
      }
    } else if (selectedPaymentMethod == "Google Pay") {
      await service.nativePay(user.selectedVehiclePrice);
    } else if (selectedPaymentMethod == "Pay On Pickup") {
      return true;
    }
    return false;
  }*/

  callOnFcmApiSendPushNotificationsForHourlyBooking(city, hours, id) async {
    final postUrl = 'https://fcm.googleapis.com/fcm/send';

    final data = {
      "notification": {
        "body": "City $city  Hours $hours",
        "title": "New Booking"
      },
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "status": "done",
        "id": id,
        "uid": user.currentUserId,
        "type": 'hourlyBooking'
      },
      "to": "\/topics\/superCab",
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAAsJCTwtE:APA91bGjxrSX65kLJfnUzGh1kqJNX6yY4m0obVxFUpicSyNI5Q04Xt1d2pTLwVSsTXXqNzEuQNsBOIvk634RFI4M9_f4XQlEAa7PXchZ5xDiM74MHI3mu0SW1PraYi8YrijOzR2tenIs'
      // 'key=YOUR_SERVER_KEY'
    };

    try {
      final response = await post(Uri.parse(postUrl),
          body: json.encode(data),
          encoding: Encoding.getByName('utf-8'),
          headers: headers);

      if (response.statusCode == 200) {
        print('CFM Succeed');
        //Navigator.of(context).pop();
        return true;
      } else {
        print(response.body);
        return false;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  callOnFcmApiSendPushNotificationsForAirportBooking(from, airPort, id) async {
    final postUrl = 'https://fcm.googleapis.com/fcm/send';

    String cityORAirport;
    if (user.fromCityToAirport) {
      cityORAirport = "From $from  Airport $airPort";
    } else if (user.fromAirportToCity) {
      if (user.fromMelbourneAirportsToAreas) {
        cityORAirport = "Airport $airPort To $from  ";
      } else {
        cityORAirport = "Airport $airPort To City  ";
      }
    }

    final data = {
      "notification": {
        "body": cityORAirport, //"From $from  Airport $airPort",
        "title": "New Booking"
      },
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "status": "done",
        "id": id,
        "uid": user.currentUserId,
        "type": 'airPortBooking'
      },
      "to": "\/topics\/superCab",
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAAsJCTwtE:APA91bGjxrSX65kLJfnUzGh1kqJNX6yY4m0obVxFUpicSyNI5Q04Xt1d2pTLwVSsTXXqNzEuQNsBOIvk634RFI4M9_f4XQlEAa7PXchZ5xDiM74MHI3mu0SW1PraYi8YrijOzR2tenIs'
      // 'key=YOUR_SERVER_KEY'
    };

    try {
      final response = await post(Uri.parse(postUrl),
          body: json.encode(data),
          encoding: Encoding.getByName('utf-8'),
          headers: headers);

      if (response.statusCode == 200) {
        print('CFM Succeed');
        //Navigator.of(context).pop();
        return true;
      } else {
        print(response.body);
        return false;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  callOnFcmApiSendPushNotificationsForLocalBooking(to, from, id) async {
    final postUrl = 'https://fcm.googleapis.com/fcm/send';

    final data = {
      "notification": {"body": "From $from  To $to", "title": "New Booking"},
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "status": "done",
        "id": id,
        "uid": user.currentUserId,
        "type": 'booknow'
      },
      "to": "\/topics\/superCab",
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAAsJCTwtE:APA91bGjxrSX65kLJfnUzGh1kqJNX6yY4m0obVxFUpicSyNI5Q04Xt1d2pTLwVSsTXXqNzEuQNsBOIvk634RFI4M9_f4XQlEAa7PXchZ5xDiM74MHI3mu0SW1PraYi8YrijOzR2tenIs'
      // 'key=YOUR_SERVER_KEY'
    };

    try {
      final response = await post(Uri.parse(postUrl),
          body: json.encode(data),
          encoding: Encoding.getByName('utf-8'),
          headers: headers);

      if (response.statusCode == 200) {
        print('FCM Succeed');
        Navigator.of(context).pop();
        return true;
      } else {
        print(response.body);
        return false;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  callOnFcmApiSendPushNotificationsForPreBooking(to, from, id) async {
    final postUrl = 'https://fcm.googleapis.com/fcm/send';

    final data = {
      "notification": {"body": "From $from  To $to", "title": "New Booking"},
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "status": "done",
        "id": id,
        "uid": user.currentUserId,
        "type": 'prebooking'
      },
      "to": "\/topics\/superCab",
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAAsJCTwtE:APA91bGjxrSX65kLJfnUzGh1kqJNX6yY4m0obVxFUpicSyNI5Q04Xt1d2pTLwVSsTXXqNzEuQNsBOIvk634RFI4M9_f4XQlEAa7PXchZ5xDiM74MHI3mu0SW1PraYi8YrijOzR2tenIs'
      // 'key=YOUR_SERVER_KEY'
    };

    try {
      final response = await post(Uri.parse(postUrl),
          body: json.encode(data),
          encoding: Encoding.getByName('utf-8'),
          headers: headers);

      if (response.statusCode == 200) {
        print('CFM Succeed');
        Navigator.of(context).pop();
        return true;
      } else {
        print(response.body);
        return false;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> getPromoCodeStatus() async {
    String status = "";
    var document = FirebaseCredentials()
        .firestore
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser.uid);

    await document.get().then((data) {
      print(data["firstPromo"]);
      status = data["firstPromo"];
    });

    if (status == "true") return true;
    if (status == "false") return false;
    // if(status == "") return false;

    return false;
  }
}
