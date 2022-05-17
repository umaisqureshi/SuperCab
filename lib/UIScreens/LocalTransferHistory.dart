import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_mlkit_language/firebase_mlkit_language.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supercab/UIScreens/bookNow.dart';
import 'package:supercab/UIScreens/chooseVehicle.dart';
import 'package:supercab/generated/l10n.dart';
import 'package:supercab/utils/ReorderDateTime.dart';
import 'package:supercab/utils/constants.dart';
import 'package:supercab/utils/firebaseCredentials.dart';
import 'package:supercab/utils/model/ReBookingDataModel.dart';
import 'package:supercab/utils/settings.dart';
import 'package:supercab/utils/userController.dart';
import 'dart:convert';
import 'package:http/http.dart';


class LocalTransferHistory extends StatefulWidget {
  @override
  _LocalTransferHistoryState createState() => _LocalTransferHistoryState();
}
class _LocalTransferHistoryState extends State<LocalTransferHistory> {

  CurrentUser user;

  String name;
  String phone;
  String email;

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

  String getBookingStatus(String value)
  {
    if(value==BookingStatusEnumForLocal.DECLINE.name()){
      return S.of(context).Decline;
    }else if(value==BookingStatusEnumForLocal.ACCEPT.name()){
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

  @override
  void initState() {
    super.initState();
    user = Get.find<CurrentUser>();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
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
                  .collection('booknow')
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
                        var to = list[index]['to'];
                        var time = list[index]['time'];
                        var cost = list[index]['tripCost'];
                        var date = list[index]['day'];
                        var transferType = list[index]['transferType'];
                        var vehicle = getBookingCar(list[index]['vehicle']);
                        var bookingStatus = getBookingStatus(list[index]['bookingStatus']);

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
                                    return Text('${S.of(context).From} :  ${snapshot.data}',maxLines: 3,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, color: Colors.white),);
                                  }
                              ),

                              SizedBox(
                                height: 10,
                              ),

                              FutureBuilder(
                                  future: getConvertedText(mobileLanguage.value.languageCode,to),
                                  builder: (context, snapshot) {
                                    return Text('${S.of(context).To} :  ${snapshot.data}',maxLines: 3,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, color: Colors.white),);
                                  }
                              ),

                              // Row(
                              //   children: [
                              //     Text(
                              //       '${S.of(context).To} : ',
                              //       style: TextStyle(
                              //           fontSize: 17, color: Colors.white),
                              //     ),
                              //     SizedBox(
                              //       width: 5,
                              //     ),
                              //     Text(
                              //       to,
                              //       style: TextStyle(
                              //           fontSize: 17, color: Colors.white),
                              //     ),
                              //   ],
                              // ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${S.of(context).Total_Cost}',
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    cost.toString(),
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
                                        onPressed: () async
                                        {
                                          ReBookingDataModel data = await Navigator.of(context).push(ReorderModal());

                                          var timeStamp = DateTime.now().millisecondsSinceEpoch;
                                          String bookingStatus = 'Pending';

                                          var id = FirebaseCredentials().firestore.collection('booknow').doc().id;
                                          await FirebaseCredentials().firestore.collection('booknow').doc(id).set({
                                            'name': name,
                                            'phone': phone,
                                            'email': email,
                                            'from' : from,
                                            'to' : to,
                                            'vehicle': vehicle,
                                            'tripCost': cost,
                                            'day': data.date,
                                            'time': data.time,
                                            'comments': data.comment,
                                            'currentUserID': user.currentUserId,
                                            'transferType': transferType,
                                            'timeStamp' : timeStamp,
                                            'bookingStatus' : bookingStatus
                                          }).then((value)
                                          async {
                                            print('Done');
                                            print("Cost :::::::::::::::: $cost" );
                                            //List<String> totalCost = cost.split(' ');
                                            user.selectedVehiclePrice = cost;
                                            user.selectedVehicle = vehicle;
                                            await callOnFcmApiSendPushNotifications(user.userDestinationAddress,user.userCurrentAddress, id);
                                            Navigator.pushNamed(context, "/bookCab");
                                          });
                                        }
                                    ),
                                  ),
                                ],
                              )

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
