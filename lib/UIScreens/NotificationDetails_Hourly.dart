import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:supercab/DataSource/Source.dart';
import 'package:supercab/generated/l10n.dart';
import 'dart:convert';
import 'package:supercab/utils/constants.dart';
import 'package:supercab/utils/firebaseCredentials.dart';


class NotificationDetails_Hourly extends StatefulWidget {

  String bookingType;
  String bookingId;
  String userId;
  String bookingStatus;
  String driverName;
  String vehicleNumber;
  String contactNumber;
  String arrivalTime;
  String comment;

  NotificationDetails_Hourly({
    @required this.bookingType,
    @required this.bookingId,
    @required this.userId,
    @required this.bookingStatus,
    @required this.driverName,
    @required this.vehicleNumber,
    @required this.contactNumber,
    @required this.arrivalTime,
    @required this.comment
  });

  @override
  _NotificationDetails_HourlyState createState() => _NotificationDetails_HourlyState();
}

class _NotificationDetails_HourlyState extends State<NotificationDetails_Hourly> {

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
                            S.of(context).Booking_Status,
                            style: TextStyle(color: white, fontSize: 17),
                          ),
                          Visibility(
                            visible: false,
                            child: Icon(Icons.ac_unit_rounded),
                          )
                        ],
                      ),
                    ),

                    Container(
                      alignment: Alignment.center,
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance.collection(widget.bookingType).doc(widget.bookingId).snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> querySnapshot)
                        {
                          if(querySnapshot.hasError)
                          {
                            return Center(child: Text('Some Error'));
                          }
                          if(querySnapshot.connectionState == ConnectionState.waiting)
                          {
                            return Center(child: CircularProgressIndicator(),);
                          }
                          else
                          {

                            final data = querySnapshot.data;

                            var cityIndex = data['city'];
                            var hours = data['hours'];
                            var time = data['time'];
                            var cost = data['tripcost'];
                            var date = data['day'];
                            var vehicle = data['vehicle'];
                            var transferType = data['transferType'];
                            var email = data['email'];
                            var phone = data['phone'];
                            var name = data['name'];
                            var bookingStatus = data['bookingStatus'];

                            String city = cityNamesList(context)[cityIndex].name;

                            return Container(
                              //height: 465,
                              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                              margin: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10)),
                                    border: Border.all(
                                        color: Colors.white, width: 1)),
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:
                                  [

                                    Row(
                                      children:
                                      [
                                        Text('${S.of(context).Booking_Type} : ', style: TextStyle(fontSize: 17, color: Colors.white),),
                                        SizedBox(width: 5,),
                                        Text(transferType, style: TextStyle(fontSize: 17, color: Colors.white),),
                                      ],
                                    ),

                                    SizedBox(height: 10,),

                                    Text('${S.of(context).Name} :  $name',maxLines: 3,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, color: Colors.white),),

                                    SizedBox(height: 10,),

                                    Text('${S.of(context).Email} :  $email',maxLines: 3,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, color: Colors.white),),

                                    SizedBox(height: 10,),

                                    Row(
                                      children:
                                      [
                                        Text('${S.of(context).Phone_Number} : ', style: TextStyle(fontSize: 17, color: Colors.white),),
                                        SizedBox(width: 5,),
                                        Text(phone.toString(), style: TextStyle(fontSize: 17, color: Colors.white),),
                                      ],
                                    ),

                                    SizedBox(height: 10,),

                                    Text('${S.of(context).City} :  $city',maxLines: 3,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, color: Colors.white),),

                                    SizedBox(height: 10,),

                                    Text('${S.of(context).Hour} :  $hours',maxLines: 3,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, color: Colors.white),),

                                    SizedBox(height: 10,),

                                    Row(
                                      children:
                                      [
                                        Text('${S.of(context).Total_Cost} : ', style: TextStyle(fontSize: 17, color: Colors.white),),
                                        SizedBox(width: 5,),
                                        Text('\$ '+cost.toString(), style: TextStyle(fontSize: 17, color: Colors.white),),
                                      ],
                                    ),

                                    SizedBox(height: 10,),

                                    Row(
                                      children:
                                      [
                                        Text('${S.of(context).Date} : ', style: TextStyle(fontSize: 17, color: Colors.white),),
                                        SizedBox(width: 5,),
                                        Text(date, style: TextStyle(fontSize: 17, color: Colors.white),),
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      children:
                                      [
                                        Text('${S.of(context).Time} : ', style: TextStyle(fontSize: 17, color: Colors.white),),
                                        SizedBox(width: 5,),
                                        Text(time, style: TextStyle(fontSize: 17, color: Colors.white),),
                                      ],
                                    ),

                                    SizedBox(height: 10,),

                                    Row(
                                      children:
                                      [
                                        Text('${S.of(context).vehicle} : ', style: TextStyle(fontSize: 17, color: Colors.white),),
                                        SizedBox(width: 5,),
                                        Text(vehicle, style: TextStyle(fontSize: 17, color: Colors.white),),
                                      ],
                                    ),

                                    SizedBox(height: 10,),

                                    Row(
                                      children:
                                      [
                                        Text('${S.of(context).Booking_Status} : ', style: TextStyle(fontSize: 17, color: Colors.white),),
                                        SizedBox(width: 5,),
                                        Text(bookingStatus, style: TextStyle(fontSize: 17, color: white),),
                                      ],
                                    ),

                                    SizedBox(height: 10,),

                                    bookingStatus == 'Accepted' ?
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:
                                      [
                                        Row(
                                          children:
                                          [
                                            Text('${S.of(context).driver_Name} : ', style: TextStyle(fontSize: 17, color: Colors.white),),
                                            SizedBox(width: 5,),
                                            Text(widget.driverName.toString(), style: TextStyle(fontSize: 17, color: white),),
                                          ],
                                        ),

                                        SizedBox(height: 10,),

                                        Text('${S.of(context).driver_Contact} : ${widget.contactNumber}',maxLines: 3,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, color: Colors.white),),

                                        SizedBox(height: 10,),

                                        Row(
                                          children:
                                          [
                                            Text('${S.of(context).vehicle_Number} : ', style: TextStyle(fontSize: 17, color: Colors.white),),
                                            SizedBox(width: 5,),
                                            Text(widget.vehicleNumber.toString(), style: TextStyle(fontSize: 17, color: white),),
                                          ],
                                        ),

                                        SizedBox(height: 10,),

                                        Text('${S.of(context).arrival_Time} : ${widget.arrivalTime}',maxLines: 3,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, color: Colors.white),),

                                        SizedBox(height: 10,),

                                        Text('${S.of(context).Admin_Message} :  ${widget.comment}',maxLines: 3,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, color: Colors.white),),

                                      ],
                                    ) : SizedBox(),

                                    SizedBox(height: 10,),

                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),

                    SizedBox(
                      height: 40,
                    ),

                  ],
                ),
              ),
            ),
          ),
        ));
  }

}

