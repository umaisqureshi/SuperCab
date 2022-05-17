import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_mlkit_language/firebase_mlkit_language.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supercab/generated/l10n.dart';
import 'package:supercab/utils/ReorderDateTime.dart';
import 'package:supercab/utils/constants.dart';
import 'package:supercab/utils/firebaseCredentials.dart';
import 'package:supercab/utils/model/ReBookingDataModel.dart';
import 'package:supercab/utils/settings.dart';
import 'package:supercab/utils/userController.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:supercab/DataSource/Source.dart';
import 'package:supercab/UIScreens/chooseVehicle.dart';
import 'package:supercab/UIScreens/airportFare.dart';



class AirportTransferHistory extends StatefulWidget {
  @override
  _AirportTransferHistoryState createState() => _AirportTransferHistoryState();
}
class _AirportTransferHistoryState extends State<AirportTransferHistory> {
  CurrentUser user;

  String name;
  String phone;
  String email;

  String getBookingStatus(String value)
  {
    if(value==BookingStatusEnum.DECLINE.name()){
      return S.of(context).Decline;
    }else if(value==BookingStatusEnum.ACCEPT.name()){
      return S.of(context).Accept;
    }else{
      return S.of(context).Pending;
    }
  }

  String getBookingCar(String value)
  {
    if(value==BookingCar.BUSINESS_SEDAN.name()){
      return S.of(context).Business_Sedan;
    }else if(value==BookingCar.EUROPEAN_PRESTIGE.name()){
      return S.of(context).European_Prestige;
    }else if(value==BookingCar.SUV.name()){
      return S.of(context).SUV;
    }else if(value==BookingCar.MINI_VAN.name()){
      return S.of(context).Mini_Van;
    }
    else
    {
      return "No Car";
    }
  }

  String getMidNightPickUp(bool value)
  {
    if(value){
      return S.of(context).Yes;
    }else{
      return S.of(context).No;
    }
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
        email = data['email'];
        if(data['phone'] != 'N/A')
        {
          phone = data['phone'];
        }
      }
    }).catchError((onError) => print('Error Fetching Data'));
  }

  @override
  void initState() {
    super.initState();
    user = Get.find<CurrentUser>();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    // print('User ID : '+ user.currentUserId);
    return Container(
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
          child: Container(
            alignment: Alignment.center,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('airPortBooking')
                  .where('currentUserID', isEqualTo: user.currentUserId).orderBy('timeStamp',descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> querySnapshot) {
                if (querySnapshot.hasError) {
                  return Center(child: Text('Some Error'));
                }
                if (querySnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  final list = querySnapshot.data.docs;
                  if (querySnapshot.data.docs.length == 0)
                    return Center(
                      child: Text(
                        S.of(context).No_Bookings,
                        style: TextStyle(color: yellow, fontSize: 17),
                      ),
                    );
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: ListView.builder(
                      itemBuilder: (context, index) {

                        var from = list[index]['from'];
                        var airportIndex = list[index]['airport'];
                        var babySeat = list[index]['babySeat'];
                        var boosterSeat = list[index]['boosterSeat'];
                        var time = list[index]['time'];
                        var cost = list[index]['tripCost'];
                        var date = list[index]['day'];
                        var transferType = list[index]['transferType'];
                        var airPortTransferType = list[index]['airportTransferType'];

                        var isMidNightPickUp = list[index]['midNightPickup'];

                        var midNightPickUp = getMidNightPickUp(list[index]['midNightPickup']);
                        var vehicle = getBookingCar(list[index]['vehicle']);
                        var bookingStatus = getBookingStatus(list[index]['bookingStatus']);

                        var airport = airPortNamesListForCity(context)[airportIndex].name;

                        return Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                              border:
                              Border.all(color: Colors.white, width: 1)),
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              FutureBuilder(
                                future: getConvertedText(mobileLanguage.value.languageCode,from),
                                builder: (context, snapshot) {
                                  return Text(airPortTransferType == 'cityToAirport'?'${S.of(context).From} :  ${snapshot.data??""}':'${S.of(context).To} :  ${snapshot.data??""}',maxLines: 3,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, color: Colors.white),);
                                }
                              ),

                              SizedBox(
                                height: 10,
                              ),

                              Text('${S.of(context).airport} :  ${airport.toString()}',maxLines: 3,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, color: Colors.white),),

                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${S.of(context).baby_Seat} : ',
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    babySeat.toString(),
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${S.of(context).booster_Seat} : ',
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    boosterSeat.toString(),
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${S.of(context).MidNightPickUp} : ',
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    midNightPickUp.toString(),
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${S.of(context).Total_Cost} : ',
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '\$ ' + cost.toString(),
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${S.of(context).Date} : ',
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    date,
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${S.of(context).Time} : ',
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    time,
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${S.of(context).vehicle} : ',
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    vehicle,
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white),
                                  ),
                                ],
                              ),

                              SizedBox(height: 10,),

                              Row(
                                children:
                                [
                                  Text('${S.of(context).Booking_Status} : ', style: TextStyle(fontSize: 17, color: Colors.white),),
                                  SizedBox(width: 5,),
                                  Text(bookingStatus, style: TextStyle(fontSize: 17, color: Colors.white),),
                                ],
                              ),

                              SizedBox(height: 15,),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:
                                [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.7,
                                    child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8)
                                        ),
                                        color: yellow,
                                        child: Text(S.of(context).Reorder,style: TextStyle(fontWeight: FontWeight.bold),),
                                        onPressed: () async {

                                          ReBookingDataModel data = await Navigator.of(context).push(ReorderModal());

                                          // print('Comment : '+data.comment);
                                          // print('Date : '+data.date);
                                          // print('Time : '+data.time);

                                          var timeStamp = DateTime.now().millisecondsSinceEpoch;
                                          String bookingStatus = 'Pending';

                                          var id = FirebaseCredentials().firestore.collection('airPortBooking').doc().id;
                                          FirebaseCredentials().firestore.collection('airPortBooking').doc(id).set({
                                            'name': name,
                                            'phone': phone,
                                            'email': email,
                                            'vehicle': vehicle,
                                            'tripCost': cost,
                                            'day': data.date,
                                            'time': data.time,
                                            'airport': airportIndex,
                                            'from': user.userCurrentAddress,
                                            'babySeat': babySeat,
                                            'boosterSeat': boosterSeat,
                                            'midNightPickup': isMidNightPickUp,
                                            'comment': data.comment,
                                            'currentUserID': user.currentUserId,
                                            'transferType': transferType,
                                            'timeStamp' : timeStamp,
                                            'airportTransferType': airPortTransferType,
                                            'bookingStatus' : bookingStatus
                                          }).then((value)
                                          {
                                            print('Done');
                                            user.selectedVehiclePrice = cost;
                                            user.selectedVehicle = vehicle;

                                            callOnFcmApiSendPushNotifications(from, airport, id);

                                            Navigator.pushNamed(context, '/bookCab');
                                          });

                                          // callOnFcmApiSendPushNotifications(
                                          //     user.selectedCity, user.selectedHours, id);

                                        }
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(),

                            ],
                          ),
                        );
                      },
                      itemCount: list.length,
                    ),
                  );
                }
              },
            ),
          ),
        ));
  }

  callOnFcmApiSendPushNotifications(from, airPort, id) async {
    final postUrl = 'https://fcm.googleapis.com/fcm/send';

    final data = {
      "notification": {
        "body": "From $from  Airport $airPort",
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
  getConvertedText(lang, inputText) async {
    if (lang == "zh") {
      inputText = await FirebaseLanguage.instance
          .languageTranslator(
              SupportedLanguages.English, SupportedLanguages.Chinese)
          .processText(inputText);
    }
    return inputText;
  }
}