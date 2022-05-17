import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:supercab/generated/l10n.dart';
import 'package:supercab/utils/constants.dart';
import 'package:supercab/utils/firebaseCredentials.dart';
import 'package:supercab/UIScreens/bookCab.dart';
import 'package:supercab/utils/userController.dart';

class BookNowFromHistory extends StatefulWidget {

  String from;
  String to;
  String totalCost;
  String vehicle;

  BookNowFromHistory({
    @required this.from,
    @required this.to,
    @required this.vehicle,
    @required this.totalCost
  });

  @override
  _BookNowFromHistoryState createState() => _BookNowFromHistoryState();
}

class _BookNowFromHistoryState extends State<BookNowFromHistory> {

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final vehicleController = TextEditingController();
  final tripCostController = TextEditingController();
  final dayController = TextEditingController();
  final timeController = TextEditingController();
  final minutesController = TextEditingController();
  final commentsController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String bookingDate;
  String currentTime;
  String currentHour;
  String minutes;

  String today = 'Today';
  String _time;

  CurrentUser user;

  void getCurrentDateAndTime() {
    var dateAndTime = DateTime.now();
    var dateFormat = new DateFormat('MMM d,yyyy');
    var timeFormat = new DateFormat('hh:mm aaa');
    var hourFormat = new DateFormat('hh');
    var minutesFormat = new DateFormat('mm');
    //var minutesFormat = new DateFormat('mm aaa');

    bookingDate = dateFormat.format(dateAndTime);
    currentTime = timeFormat.format(dateAndTime);
    currentHour = hourFormat.format(dateAndTime);
    minutes = minutesFormat.format(dateAndTime);

    today = bookingDate.toString();
    _time = currentTime;
  }

  void submit() async {
    if (_formKey.currentState.validate()) {

      String transferType = 'LocalTransfer';

      var timeStamp = DateTime.now().millisecondsSinceEpoch;
      String bookingStatus = 'Pending';

      user.selectedVehicle = widget.vehicle;
      List<String> cost = widget.totalCost.split(' ');
      //print('Total Cost : ' + cost[1]);
      user.selectedVehiclePrice = int.parse(cost[1]);

      var id = FirebaseCredentials().firestore.collection('booknow').doc().id;
      FirebaseCredentials().firestore.collection('booknow').doc(id).set({
        'name': nameController.text,
        'phone': phoneController.text,
        'email': emailController.text,
        'from' : widget.from,
        'to' : widget.to,
        'vehicle': widget.vehicle,
        'tripCost': widget.totalCost,
        'day': bookingDate,
        'time': _time,
        'comments': commentsController.text,
        'currentUserID': user.currentUserId,
        'transferType': transferType,
        'timeStamp' : timeStamp,
        'bookingStatus' : bookingStatus
      });

      callOnFcmApiSendPushNotifications(user.userDestinationAddress,user.userCurrentAddress, id);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BookCab()));
    }
  }

  // void getUserInfo() async {
  //   await FirebaseCredentials()
  //       .firestore
  //       .collection('user')
  //       .where('email', isEqualTo: '${user.userEmail}')
  //       .get()
  //       .then((value) {
  //     if (value.docs.isNotEmpty) {
  //       Map<String, dynamic> data = value.docs.single.data();
  //
  //       print('User Name : ' + data['firstName']);
  //       print('Email : ' + data['email']);
  //
  //       nameController.text = data['firstName'];
  //       emailController.text = data['email'];
  //       phoneController.text = data['phone'];
  //     }
  //   }).catchError((onError) => print('Error Fetching Data'));
  // }

  void getUserInfo() async {
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
        if(data['phone'] != 'N/A')
        {
          phoneController.text = data['phone'];
        }
      }
    }).catchError((onError) => print('Error Fetching Data'));
  }

  getDataFromHistory()
  {
    tripCostController.text = widget.totalCost;
    vehicleController.text = widget.vehicle;
  }


  @override
  void initState() {
    super.initState();

    user = Get.find<CurrentUser>();

    getCurrentDateAndTime();
    getUserInfo();
    getDataFromHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 60),
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
                            S.of(context).Book_Now,
                            style: TextStyle(color: white, fontSize: 17),
                          ),
                          Visibility(
                            visible: false,
                            child: Icon(Icons.ac_unit_rounded),
                          )
                        ],
                      ),
                    ),
                    Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).Name,
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              controller: nameController,
                              validator: (input) {
                                if (input.isEmpty)
                                  return 'Required Field';
                                else
                                  return null;
                              },
                              style: TextStyle(color: white),
                              decoration: InputDecoration(
                                hintText: 'Lorem Ipsum',
                                hintStyle: TextStyle(color: white),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.1),
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
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              S.of(context).Phone,
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              controller: phoneController,
                              validator: (input) {
                                if (input.isEmpty)
                                  return 'Required Field';
                                else
                                  return null;
                              },
                              style: TextStyle(color: white),
                              decoration: InputDecoration(
                                hintText: '(201)677 8524',
                                hintStyle: TextStyle(color: white),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.1),
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
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              S.of(context).Email,
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              controller: emailController,
                              validator: (input) {
                                if (input.isEmpty)
                                  return 'Required Field';
                                else
                                  return null;
                              },
                              style: TextStyle(color: white),
                              decoration: InputDecoration(
                                hintText: 'smith@gmail.com',
                                hintStyle: TextStyle(color: white),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.1),
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
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '${S.of(context).Selected_Vehicle} :',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              controller: vehicleController,
                              validator: (input) {
                                if (input.isEmpty)
                                  return 'Required Field';
                                else
                                  return null;
                              },
                              style: TextStyle(color: white),
                              decoration: InputDecoration(
                                hintText: 'No Vehicle Selected',
                                hintStyle: TextStyle(color: white),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.1),
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
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              S.of(context).Trip_Cost,
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              controller: tripCostController,
                              validator: (input) {
                                if (input.isEmpty)
                                  return 'Required Field';
                                else
                                  return null;
                              },
                              style: TextStyle(color: white),
                              decoration: InputDecoration(
                                hintText: '\$ 00',
                                hintStyle: TextStyle(color: white),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.1),
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
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        S.of(context).Date,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            border: Border.all(
                                                color: Colors.white, width: 1)),
                                        height: 60,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          today.toString(),
                                          style: TextStyle(
                                              fontSize: 17, color: Colors.white),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        S.of(context).Time,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            border: Border.all(
                                                color: Colors.white, width: 1)),
                                        height: 60,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          _time.toString(),
                                          style: TextStyle(
                                              fontSize: 17, color: Colors.white),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: commentsController,
                              maxLines: 5,
                              style: TextStyle(color: white),
                              decoration: InputDecoration(
                                hintText: S.of(context).Additional_Comments,
                                hintStyle: TextStyle(color: white),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.1),
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
                              ),
                            ),
                          ],
                        )),
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
                        onPressed: () => submit(),
                        child: Text(
                          S.of(context).Proceed_to_Payment,
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  callOnFcmApiSendPushNotifications(to, from, id) async {
    final postUrl = 'https://fcm.googleapis.com/fcm/send';

    final data = {
      "notification": {
        "body": "From $from  To $to",
        "title": "New Booking"
      },
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "status": "done",
        "id": id,
        "uid":user.currentUserId,
        "type" : 'booknow'
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
}
