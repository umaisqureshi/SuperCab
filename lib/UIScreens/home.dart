import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' as sch show SchedulerBinding;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supercab/UIScreens/NotificationDetails_Airport.dart';
import 'package:supercab/UIScreens/NotificationDetails_Hourly.dart';
import 'package:supercab/UIScreens/NotificationDetails_LocalTransfer.dart';
import 'package:supercab/UIScreens/NotificationDetails_PreBooking.dart';
import 'package:supercab/UIScreens/airport.dart';
import 'package:supercab/UIScreens/drawer.dart';
import 'package:supercab/UIScreens/hourlyTransfer.dart';
import 'package:supercab/UIScreens/localTransfer.dart';
import 'package:supercab/utils/constants.dart';
import 'package:supercab/utils/firebaseCredentials.dart';
import 'package:supercab/utils/model/Language.dart';
import 'package:supercab/utils/model/NotificationModel.dart';
import 'package:supercab/generated/l10n.dart';
import 'package:supercab/utils/model/PromoCodeModel.dart';
import 'package:supercab/UIScreens/NotificationDetails_PromoCode.dart';
import 'package:supercab/utils/model/promoCardDataModel.dart';
import 'package:supercab/utils/settings.dart';
import 'package:supercab/utils/userController.dart';

class Home extends StatefulWidget {
  static String userEmail;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>
{
  String language;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  String flag;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final List<NotificationModel> messages = [];

  CurrentUser user;

  dynamicLinkMethod(String sharedUserID) async {
    String userId = FirebaseCredentials().auth.currentUser.uid;
    DocumentReference history =
    FirebaseCredentials().firestore.collection("shareHistory").doc("$sharedUserID-$userId");
   final getHistory =  await history.get();

    if(getHistory.exists)return;

    DocumentReference reference =
    FirebaseCredentials().firestore.collection("wallet").doc(sharedUserID);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final freshSnapshot = await transaction.get(reference);
      if (freshSnapshot.exists) {
        int cash = (freshSnapshot.data() as Map).containsKey('TotalCash')
            ? freshSnapshot['TotalCash']
            : 0;

        transaction.set(
            reference, {'TotalCash': cash + 10}, SetOptions(merge: true));
      }
      else {
        transaction.set(reference, {'TotalCash': 10}, SetOptions(merge: true));
      }
    });
    history.set({'share': true}, SetOptions(merge: true));
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;
      if (deepLink != null) {
        print("onLink${deepLink.queryParameters["id"]}");

        String sharedUserID = deepLink.queryParameters["id"];

        dynamicLinkMethod(sharedUserID);
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    await FirebaseDynamicLinks.instance.getInitialLink().then((value) async {
      final Uri deepLink = value?.link;
      if (deepLink != null) {
        print("initialLink${deepLink.queryParameters["id"]}");

        String sharedUserID = deepLink.queryParameters["id"];

        dynamicLinkMethod(sharedUserID);
      }
    }).catchError((error) {
      print('initialLinkError $error');
    });
  }

  Future onSelectNotification(String payload)
  {
    print('******* OutSide *****');
    Map<String, dynamic> genModel = json.decode(payload);
    print(genModel);
    if (genModel.containsKey("promoCode")) {
      PromoCodeModel model = PromoCodeModel.fromJson(json.decode(payload));

      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return NotificationDetails_PromoCode(
          promoCodeId: model.promoCode,
        );
      }));
    } else {
      print('******* Non PromoCode *****');
      NotificationModel model =
          NotificationModel.fromJson(json.decode(payload));
      if (model.type == 'booknow') {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return NotificationDetails_LocalTransfer(
            bookingType: model.type,
            bookingId: model.id,
            userId: model.userId,
            bookingStatus: model.bookingStatus,
            driverName: model.driverName,
            vehicleNumber: model.vehicleNumber,
            contactNumber: model.contactNumber,
            arrivalTime: model.arrivalTime,
            comment: model.comment,
          );
        }));
      }
      if (model.type == 'prebooking') {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return NotificationDetails_PreBooking(
            bookingType: model.type,
            bookingId: model.id,
            userId: model.userId,
            bookingStatus: model.bookingStatus,
            driverName: model.driverName,
            vehicleNumber: model.vehicleNumber,
            comment: model.comment,
          );
        }));
      }
      if (model.type == 'hourlyBooking') {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return NotificationDetails_Hourly(
            bookingType: model.type,
            bookingId: model.id,
            userId: model.userId,
            bookingStatus: model.bookingStatus,
            driverName: model.driverName,
            contactNumber: model.contactNumber,
            vehicleNumber: model.vehicleNumber,
            arrivalTime: model.arrivalTime,
            comment: model.comment,
          );
        }));
      }
      if (model.type == 'airPortBooking') {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return NotificationDetails_Airport(
            bookingType: model.type,
            bookingId: model.id,
            userId: model.userId,
            bookingStatus: model.bookingStatus,
            driverName: model.driverName,
            contactNumber: model.contactNumber,
            vehicleNumber: model.vehicleNumber,
            arrivalTime: model.arrivalTime,
            comment: model.comment,
          );
        }));
      }
    }
  }

  showNotification(NotificationModel model) async {
    var android = AndroidNotificationDetails('SB', 'Super_Cab ', 'SuperCab',
        priority: Priority.high, importance: Importance.max);
    var iOS = IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(
        0, model.title, model.body, platform,
        payload: json.encode(model.toJson()));
  }

  showNotificationForPromoCode(PromoCodeModel model) async {
    var android = AndroidNotificationDetails('SB', 'Super_Cab ', 'SuperCab',
        priority: Priority.high, importance: Importance.max);
    var iOS = IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(
        0, model.title, model.body, platform,
        payload: json.encode(model.toJson()));
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      user = Get.find<CurrentUser>();
      initDynamicLinks();
      getLanguage().then((value) => flag =value);
    }

    var initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');

    var initializationSettingsIOs = IOSInitializationSettings();

    var initSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOs);

    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onSelectNotification);

    _firebaseMessaging.requestPermission(
        sound: true, badge: true, alert: true);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage: $message");

      if (message.data['type'] == 'promoCode') {
        var promoModel = PromoCodeModel(
            promoCode: message.data['id'], title: 'title', body: 'body');
        showNotificationForPromoCode(promoModel);
      } else {
        var notification = NotificationModel(
            title: message.notification.title,
            body: message.notification.body,
            userId: message.data['uid'],
            id: message.data['id'],
            type: message.data['type'],
            bookingStatus: message.data['bookingStatus'],
            driverName: message.data['driverName'],
            vehicleNumber: message.data['drivervehicleNumber'],
            contactNumber: message.data['driverContact'],
            arrivalTime: message.data['arrivalTime'],
            comment:message.data['comment']);
        showNotification(notification);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data['type'] == 'promoCode') {
        var promoModel = PromoCodeModel(
            promoCode: message.data['id'], title: 'title', body: 'body');
        onSelectNotification(jsonEncode(promoModel.toJson()));

      } else {
        var notification = NotificationModel(
            title: message.notification.title,
            body: message.notification.body,
            userId: message.data['uid'],
            id: message.data['id'],
            type: message.data['type'],
            bookingStatus: message.data['bookingStatus'],
            driverName: message.data['driverName'],
            vehicleNumber: message.data['drivervehicleNumber'],
            contactNumber: message.data['driverContact'],
            arrivalTime: message.data['arrivalTime'],
            comment:message.data['comment']);
        onSelectNotification(jsonEncode(notification.toJson()));

      }
    });

    _firebaseMessaging.getToken().then((value) {
      FirebaseFirestore.instance
          .collection('token')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .set({
        'token': value,
      }, SetOptions(merge: true));
    });

    _firebaseMessaging.subscribeToTopic("superCabUser");

    sch.SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey('promoCode')) {
        PromoCodeDataModel model =
            PromoCodeDataModel.fromJson(json.decode(prefs.get('promoCode')));
        print('********** PromoCode : ${model.toMap()}');

        if (model.expiryDate < DateTime.now().millisecondsSinceEpoch) {
          prefs.remove('promoCode').then((value) {
            // print('*****************');
            // print('PromoCode Removed');
            // print('*****************');
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
     print('App Name : ' + S.of(context).app_name);

    return DefaultTabController(
      length: 3,
      child: SafeArea(
        top: true,
        child: Scaffold(
          key: _scaffoldKey,
          drawer: SideDrawer(),
          appBar: AppBar(
            elevation: 0.0,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: yellow,
                isScrollable: true,
                indicatorWeight: 2,
                tabs:
                [
                  Tab(
                    child: Row(
                      children: [
                        Icon(Icons.car_rental, size: 15, color: yellow),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          S.of(context).Local_Transfer,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      children: [
                        Icon(Icons.transfer_within_a_station_sharp,
                            size: 15, color: yellow),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          S.of(context).Hourly_Transfer,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      children: [
                        Icon(Icons.local_airport, size: 15, color: yellow),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          S.of(context).airport,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.black,
            leading: IconButton(
              onPressed: () => _scaffoldKey.currentState.openDrawer(),
              icon: Icon(Icons.menu),
              color: yellow,
            ),
            actions:
            [

              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Material(
                  elevation: 4.0,
                  shape: CircleBorder(),
                  clipBehavior: Clip.hardEdge,
                  color: Colors.transparent,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        flag = flag=="en"?"zh":"en";
                      });
                      setLangauge(flag).then((value) {
                        mobileLanguage.value = Locale(value,'');
                        mobileLanguage.notifyListeners();
                      });
                    },
                    child: Container(
                      height: 34,
                      width: 34,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: flag == 'en'
                                  ? AssetImage('assets/icons/australia.jpg')
                                  : AssetImage('assets/icons/china.png'))),
                    ),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () => Navigator.pushNamed(context, '/user'),
                  icon: SvgPicture.asset(
                    "assets/icons/profileIcon.svg",
                  )),
            ],
          ),
          body: TabBarView(children: [
            LocalTransfer(),
            HourlyTransfer(),
            Airport(),
          ]),
        ),
      ),
    );
  }
}
