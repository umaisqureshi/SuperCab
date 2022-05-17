import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_mlkit_language/firebase_mlkit_language.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supercab/UIScreens/HourlyTransferHistory.dart';
import 'package:supercab/UIScreens/chooseVehicle.dart';
import 'package:supercab/UIScreens/drawer.dart';
import 'package:supercab/generated/l10n.dart';
import 'package:supercab/utils/constants.dart';
import 'package:supercab/utils/settings.dart';
import 'package:supercab/utils/userController.dart';

import 'AirportHistory.dart';
import 'LocalTransferHistory.dart';
import 'package:supercab/UIScreens/preBooking.dart';

class History extends StatefulWidget {
  static String userEmail;

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: SafeArea(
        top: true,
        child: Scaffold(
          key: _scaffoldKey,
          //drawer: SideDrawer(),
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 10,
                width: 10,
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
            ),
            title: Text(
              S.of(context).My_Bookings,
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            elevation: 0.0,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: yellow,
                isScrollable: true,
                indicatorWeight: 2,
                tabs: [
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
                        Icon(Icons.car_rental, size: 15, color: yellow),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          S.of(context).Pre_Booking,
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
          ),
          body: TabBarView(children: [
            LocalTransferHistory(),
            LocalPreBookingTransferHistory(),
            HourlyTransferHistory(),
            AirportTransferHistory()
          ]),
        ),
      ),
    );
  }
}



class LocalPreBookingTransferHistory extends StatefulWidget {
  @override
  _LocalPreBookingTransferHistoryState createState() => _LocalPreBookingTransferHistoryState();
}
class _LocalPreBookingTransferHistoryState extends State<LocalPreBookingTransferHistory> {
  CurrentUser user;


  String getBookingStatus(String value)
  {
    if(value==BookingStatusEnumForPreBooking.DECLINE.name()){
      return S.of(context).Decline;
    }else if(value==BookingStatusEnumForPreBooking.ACCEPT.name()){
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


  @override
  void initState() {
    super.initState();
    user = Get.find<CurrentUser>();
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
                  .collection('prebooking')
                  .where('currentUserID', isEqualTo: user.currentUserId).orderBy('timeStamp',descending: true)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> querySnapshot) {
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

                        var babySeat = list[index]['babySeat'];
                        var boosterSeat = list[index]['boosterSeat'];
                        //var flightNumber = list[index]['flightnumber'];
                        var from = list[index]['from'];
                        var to = list[index]['to'];
                        var time = list[index]['time'];
                        var cost = list[index]['tripcost'];
                        var date = list[index]['day'];
                        var transferType = list[index]['transferType'];
                        var comments = list[index]['comments'];

                        var midNightPickUp = getMidNightPickUp(list[index]['midNightPickup']);
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

                              SizedBox(
                                height: 10,
                              ),
                              Text('${S.of(context).baby_Seat} : $babySeat',maxLines: 3,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, color: Colors.white),),
                              SizedBox(height: 10,),
                              Text('${S.of(context).Booster_Seat} : $boosterSeat',maxLines: 3,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, color: Colors.white),),
                              SizedBox(height: 10,),
                              Text('${S.of(context).MidNightPickUp} : $midNightPickUp',maxLines: 3,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, color: Colors.white),),
                              SizedBox(height: 10,),
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
                                    '\$ '+cost.toString(),
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









