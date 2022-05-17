import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supercab/generated/l10n.dart';
import 'package:supercab/utils/constants.dart';
import 'package:supercab/utils/firebaseCredentials.dart';
import 'package:supercab/utils/model/promoCardDataModel.dart';
import 'package:supercab/utils/userController.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:supercab/utils/calulatorFunctions.dart';
import 'package:flutter/scheduler.dart' as sch show SchedulerBinding;
import 'package:supercab/DataSource/Source.dart';

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

class ChooseVehicle extends StatefulWidget {
  final String transferType;

  ChooseVehicle({this.transferType});

  @override
  _ChooseVehicleState createState() => _ChooseVehicleState();
}

class _ChooseVehicleState extends State<ChooseVehicle> {
  CurrentUser user;
  bool isSelected = false;
  int selectedIndex = 0;
  SharedPreferences preferences;

  final contactController = TextEditingController();
  final emailController = TextEditingController();

  String name;
  String email;
  String phone;

  // bool isAlreadySelectedVehicle = true;
  List<String> vehicleImages = [
    'assets/icons/sedan.png',
    'assets/icons/prestige.png',
    'assets/icons/SUV.png',
    'assets/icons/van.png',
  ];

  List<String> vehicleDescription(context) => [
        S.of(context).Merc_E_Class_Lexus_ES_300_or_similar_etc,
        S.of(context).Merc_S_Class_BMW_7_Series_or_similar_etc,
        S.of(context).Audi_Q7_Merc_GL_or_similar_etc,
        S.of(context).Merc_Viano_LDV_or_similar_etc,
      ];

  List<String> airPortFareVehiclePrice = [];

  List<String> hourTransferVehiclePrice = [];

  List<String> vehiclePrice;

  int offerDiscount = 0;

  final formKey = GlobalKey<FormState>();

  bool validateForm() {
    final key = formKey.currentState;
    if (key.validate()) {
      return true;
    }
    return false;
  }

  void getUserInfo() async {
    await FirebaseCredentials()
        .firestore
        .collection('user')
        .doc(user.currentUserId)
        .get()
        .then((value) {
      if (value.exists) {
        Map<String, dynamic> data = value.data();
        name = data['name'];
        if (data['email'] != 'null') {
          email = data['email'];
        } else {
          email = 'null';
        }
        if (data['phone'] != 'null') {
          phone = data['phone'];
        } else {
          phone = 'null';
        }
      }
    }).catchError((onError) => print('Error Fetching Data'));
  }

  int calculateDiscount(int actualPrice) {
    int price = int.parse(vehiclePrice[0]);
    int newPrice = 0;

    int discount = ((offerDiscount / 100) * price).toInt();
    newPrice = price - discount;

    return newPrice;
  }

  void offerAvailablePriceMethod(BuildContext context) {
    //print('Inside Discount Area');
    if (user.isHourlyTransfer) {
      hourTransferVehiclePrice = checkPriceListForSelectedCityInHourlyTransfer(
          hourTransferVehiclePrice, context);
      vehiclePrice =
          costForHourlyTransfer(hourTransferVehiclePrice, user.selectedHours);
      user.selectedVehicle = vehicleNames(context)[0];
      user.selectedVehiclePrice = calculateDiscount(int.parse(vehiclePrice[0]));
      //int.parse(vehiclePrice[0]);
    } else if (user.isLocalTransfer) {
      vehiclePrice = costForLocalTransfer(vehicleNames(context), context);
      user.selectedVehicle = vehicleNames(context)[0];
      user.selectedVehiclePrice = calculateDiscount(int.parse(vehiclePrice[0]));
      user.userAlreadySelectedPrice =
          calculateDiscount(int.parse(vehiclePrice[0])); // for preBooking
    } else if (user.isAirportTransfer) {
      airPortFareVehiclePrice = checkPriceListForSelectedAirportInAirportFare(
          airPortFareVehiclePrice);
      vehiclePrice = airPortFareVehiclePrice;
      user.selectedVehicle = vehicleNames(context)[0];
      user.selectedVehiclePrice = calculateDiscount(int.parse(vehiclePrice[0]));
    }
  }

  void offerNotAvailablePriceMethod(BuildContext context) {
    //print('Inside Non-Discount Area');
    if (user.isHourlyTransfer) {
      hourTransferVehiclePrice = checkPriceListForSelectedCityInHourlyTransfer(
          hourTransferVehiclePrice, context);
      vehiclePrice =
          costForHourlyTransfer(hourTransferVehiclePrice, user.selectedHours);
      user.selectedVehicle = vehicleNames(context)[0];
      user.selectedVehiclePrice =
          int.parse(vehiclePrice[0]); //int.parse(vehiclePrice[0]);
    } else if (user.isLocalTransfer) {
      vehiclePrice = costForLocalTransfer(vehicleNames(context), context);
      user.selectedVehicle = vehicleNames(context)[0];
      user.selectedVehiclePrice = int.parse(vehiclePrice[0]);
      user.userAlreadySelectedPrice =
          calculateDiscount(int.parse(vehiclePrice[0])); // for preBooking
    } else if (user.isAirportTransfer) {
      airPortFareVehiclePrice = checkPriceListForSelectedAirportInAirportFare(
          airPortFareVehiclePrice);
      vehiclePrice = airPortFareVehiclePrice;
      user.selectedVehicle = vehicleNames(context)[0];
      user.selectedVehiclePrice = int.parse(vehiclePrice[0]);
    }
  }

  init() async {
    preferences = await SharedPreferences.getInstance();

    if (preferences.containsKey('promoCode')) {
      PromoCodeDataModel model = PromoCodeDataModel.fromJson(
          json.decode(preferences.get('promoCode')));
      print('********** PromoCode : ${model.toMap()}');

      if (model.promoCode!=firstRidePromoCode && model.expiryDate < DateTime.now().millisecondsSinceEpoch) {
        user.alreadyGetDiscount = false;
        preferences.remove('promoCode');
      } else if (model.totalRides > 0) {
        offerDiscount = model.discount;

        if (offerDiscount > 0) {
          user.alreadyGetDiscount = true;
          offerAvailablePriceMethod(context);
        } else {
          offerNotAvailablePriceMethod(context);
        }
      } else {
        offerNotAvailablePriceMethod(context);
        user.alreadyGetDiscount = false;
      }
    } else {
      offerNotAvailablePriceMethod(context);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    user = Get.find<CurrentUser>();
    getUserInfo();
    if (mounted) {
      init();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 45, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
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
                    Text(
                      S.of(context).Select_vehicle_to_proceed,
                      style: TextStyle(color: white, fontSize: 17),
                    ),
                    Visibility(
                      visible: false,
                      child: Icon(Icons.eighteen_mp),
                    )
                  ],
                ),
              ),
              mounted
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: vehicleNames(context).length,
                      itemBuilder: (context, index) {
                        int price = int.parse(vehiclePrice[index]);
                        int newPrice = 0;
                        int ridePrice = 0;

                        if (offerDiscount > 0) {
                          int discount =
                              ((offerDiscount / 100) * price).toInt();
                          newPrice = price - discount;
                          ridePrice = newPrice;
                        } else {
                          ridePrice = price;
                        }

                        return GestureDetector(
                          onTap: () {
                            user.selectedVehicle =
                                BookingCar.values[index].name();
                            user.selectedVehiclePrice = ridePrice; // price

                            user.userAlreadySelectedPrice =
                                user.selectedVehiclePrice; // for preBooking

                            isSelected = true;
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          child: Container(
                            decoration: selectedIndex == index
                                ? BoxDecoration(
                                    border: Border.all(color: yellow, width: 1))
                                : null,
                            child: ClipRect(
                              child: offerDiscount > 0
                                  ? Banner(
                                      message:
                                          '${offerDiscount.toString() + ' %' + ' Off'}',
                                      location: BannerLocation.topStart,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 3),
                                        child: ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          leading:
                                              Image.asset(vehicleImages[index]),
                                          title: Text(
                                            vehicleNames(context)[index],
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          subtitle: Text(
                                            vehicleDescription(context)[index],
                                            style: TextStyle(
                                                color: yellow, fontSize: 12),
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              offerDiscount > 0
                                                  ? Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              '\$',
                                                              style: TextStyle(
                                                                  color:
                                                                      yellow),
                                                            ),
                                                            SizedBox(
                                                              width: 2,
                                                            ),
                                                            Text(
                                                                price
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .lineThrough)),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              '\$',
                                                              style: TextStyle(
                                                                  color:
                                                                      yellow),
                                                            ),
                                                            SizedBox(
                                                              width: 2,
                                                            ),
                                                            Text(
                                                                newPrice
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                )),
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                  : Row(
                                                      children: [
                                                        Text(
                                                          '\$',
                                                          style: TextStyle(
                                                              color: yellow),
                                                        ),
                                                        SizedBox(
                                                          width: 2,
                                                        ),
                                                        Text(
                                                          price.toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        )
                                                      ],
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 3),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading:
                                            Image.asset(vehicleImages[index]),
                                        title: Text(
                                          vehicleNames(context)[index],
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        subtitle: Text(
                                          vehicleDescription(context)[index],
                                          style: TextStyle(
                                              color: yellow, fontSize: 12),
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            offerDiscount > 0
                                                ? Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            '\$',
                                                            style: TextStyle(
                                                                color: yellow),
                                                          ),
                                                          SizedBox(
                                                            width: 2,
                                                          ),
                                                          Text(price.toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough)),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            '\$',
                                                            style: TextStyle(
                                                                color: yellow),
                                                          ),
                                                          SizedBox(
                                                            width: 2,
                                                          ),
                                                          Text(
                                                              newPrice
                                                                  .toString(),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              )),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                : Row(
                                                    children: [
                                                      Text(
                                                        '\$',
                                                        style: TextStyle(
                                                            color: yellow),
                                                      ),
                                                      SizedBox(
                                                        width: 2,
                                                      ),
                                                      Text(
                                                        price.toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )
                                                    ],
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        );
                      },
                    )
                  : Container(),
              SizedBox(
                height: 30,
              ),
              widget.transferType == 'local' ? OurRates() : SizedBox(),
              Spacer(),
              widget.transferType == 'local'
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 50,
                            width: (MediaQuery.of(context).size.width / 2) - 30,
                            child: RaisedButton(
                              color: yellow,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              onPressed: () {
                                user.selectedVehiclePrice =
                                    user.userAlreadySelectedPrice;
                                Navigator.pushNamed(context, '/bookNow');
                              },
                              child: Text(
                                S.of(context).Book_Now,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            width: (MediaQuery.of(context).size.width / 2) - 30,
                            child: RaisedButton(
                              color: yellow,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              onPressed: () {
                                user.selectedVehiclePrice =
                                    user.userAlreadySelectedPrice;
                                Navigator.pushNamed(context, '/preBooking');
                              },
                              child: Text(
                                S.of(context).Pre_Booking,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        child: RaisedButton(
                          color: yellow,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          onPressed: () {
                            if (widget.transferType == 'airport') {
                              Navigator.pushNamed(context, '/airportFare');
                            } else {
                              //hourlyDataSubmit();
                              if (phone != 'null' && email != 'null') {
                                Navigator.pushNamed(context, "/bookCab");
                              } else {
                                showGeneralDialog(
                                  barrierLabel: "Label",
                                  barrierDismissible: true,
                                  barrierColor: Colors.black.withOpacity(0.5),
                                  transitionDuration:
                                      Duration(milliseconds: 500),
                                  context: context,
                                  pageBuilder: (context, anim1, anim2) {
                                    return SafeArea(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20,
                                            bottom: 10,
                                            left: 20,
                                            right: 20),
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          child: Material(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Container(
                                              height: 250,
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: yellow,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Form(
                                                key: formKey,
                                                child: ListView(
                                                  primary: true,
                                                  children: [
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      S.of(context).Alert,
                                                      style: TextStyle(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    email == 'null'
                                                        ? Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10),
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  emailController,
                                                              autofocus: true,
                                                              decoration:
                                                                  InputDecoration(
                                                                      hintText: S
                                                                          .of(context)
                                                                          .Email),
                                                              validator:
                                                                  (value) {
                                                                return value
                                                                        .isEmpty
                                                                    ? 'required'
                                                                    : null;
                                                              },
                                                            ),
                                                          )
                                                        : SizedBox(),
                                                    phone == 'null'
                                                        ? Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10),
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  contactController,
                                                              autofocus: true,
                                                              decoration:
                                                                  InputDecoration(
                                                                      hintText: S
                                                                          .of(context)
                                                                          .Phone),
                                                              validator:
                                                                  (value) {
                                                                return value
                                                                        .isEmpty
                                                                    ? 'required'
                                                                    : null;
                                                              },
                                                            ),
                                                          )
                                                        : SizedBox(),
                                                    SizedBox(
                                                      height: 30,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        ButtonTheme(
                                                          minWidth: 100,
                                                          height: 45,
                                                          child: RaisedButton(
                                                            onPressed:
                                                                () async {
                                                              if (validateForm()) {
                                                                phone =
                                                                    contactController
                                                                        .text
                                                                        .trim();
                                                                email =
                                                                    emailController
                                                                        .text
                                                                        .trim();
                                                                await FirebaseCredentials()
                                                                    .firestore
                                                                    .collection(
                                                                        'user')
                                                                    .doc(user
                                                                        .currentUserId)
                                                                    .update({
                                                                  'phone':
                                                                      phone,
                                                                  'email': email
                                                                }).then((value) {
                                                                  Navigator.pushNamed(
                                                                      context,
                                                                      "/bookCab");
                                                                });
                                                              }
                                                            },
                                                            child: Text(
                                                              S
                                                                  .of(context)
                                                                  .Save,
                                                              style: TextStyle(
                                                                  fontSize: 17,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            color: Colors.black,
                                                            elevation: 12.0,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  new BorderRadius
                                                                          .circular(
                                                                      25.0),
                                                            ),
                                                          ),
                                                        ),
                                                        ButtonTheme(
                                                          minWidth: 100,
                                                          height: 45,
                                                          child: RaisedButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text(
                                                              S
                                                                  .of(context)
                                                                  .Cancel,
                                                              style: TextStyle(
                                                                  fontSize: 17,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            color: Colors.black,
                                                            elevation: 12.0,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  new BorderRadius
                                                                          .circular(
                                                                      25.0),
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
                                        ),
                                      ),
                                    );
                                  },
                                  transitionBuilder:
                                      (context, anim1, anim2, child) {
                                    return SlideTransition(
                                      position: Tween(
                                              begin: Offset(0, 1),
                                              end: Offset(0, 0))
                                          .animate(anim1),
                                      child: child,
                                    );
                                  },
                                );
                              }
                            }
                          },
                          child: Text(
                            widget.transferType == 'airport'
                                ? S.of(context).Book_Now
                                : S.of(context).Proceed_to_Payment,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
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
    );
  }

  Widget OurRates() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.92,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: yellow, width: 0.8)),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).Our_Rates,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            '-' + S.of(context).Business_Sedan + ' --(A) \$2.30/km + \$15',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          Text(
            '-' + S.of(context).European_Prestige + ' --(A) + \$25',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          Text(
            '-' + S.of(context).suv + ' --(A) + \$20',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          Text(
            '-' + S.of(context).Mini_Van + ' --(A) + \$40',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          Text(
            S.of(context).Minimum_Fare + ' -- \$55',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            S
                .of(context)
                .SuperCab_All_Inclusive_Fares_include_10_min_free_Waiting_Time,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  callOnFcmApiSendPushNotifications(city, hours, id) async {
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
          'key=AAAAongebhA:APA91bH23Z8cjcfpQM4w7Aez1q6Dy5h3R2dr_V-jlj8NK7wU0VRT1X57wvpkO5bgP0KM2kTYOMwrk4b9pnVpWBv65jG72Z1K9uYpikoe7mb5KTdx_MsfA2DmsSWmxFAFuAhkWV6RvXCH'
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
}
