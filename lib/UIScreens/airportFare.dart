import 'package:flutter/material.dart';
import 'package:supercab/DataSource/Source.dart';
import 'package:supercab/generated/l10n.dart';
import 'package:supercab/utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:supercab/utils/firebaseCredentials.dart';
import 'package:supercab/utils/userController.dart';
import 'dart:convert';
import 'package:http/http.dart';


enum MidNightPickUpEnum
{
  TRUE,FALSE
}
extension MidNightPickUpEnumName on MidNightPickUpEnum{
  String name(){
    return this.index==0?"Yes":this.index==1?"NO":"";
  }
}

enum BookingStatusEnumForAirport
{
  PENDING,ACCEPT,DECLINE
}
extension BookingStatusEnumName on BookingStatusEnumForAirport{
  String name(){
    return this.index==0?"Pending":this.index==1?"Accept":this.index==2?"Decline":"";
  }
}


class AirportFare extends StatefulWidget {
  @override
  _AirportFareState createState() => _AirportFareState();
}

class _AirportFareState extends State<AirportFare> {

  bool isBabySeat = false;
  bool isBoosterSeat = false;
  bool isMidSeat = false;

  int babySeat = 0;
  int boosterSeat = 0;

  int babySeatCost = 12;
  int boosterSeatCost = 10;
  int midNightSeatCost = 15;

  int babySeatTotalCost = 0;
  int boosterSeatTotalCost = 0;

  String bookingDate;
  String selectedTime;
  String selectedHour;
  String selectedMinutes;

  String currentTime;
  String currentHour;
  String minutes;
  String _time;

  TimeOfDay _timeOfDay;

  String _date;

  CurrentUser user;

  String name;
  String email;
  String phone;

  final commentController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool validateForm()
  {
    final key = formKey.currentState;
    if(key.validate())
    {
      return true;
    }
    return false;
  }

  void getCurrentDateAndTime() {
    var dateAndTime = DateTime.now();
    var dateFormat = new DateFormat('MMM d,yyyy',"en");
    var timeFormat = new DateFormat('hh:mm aaa',"en");
    var hourFormat = new DateFormat('hh');
    var minutesFormat = new DateFormat('mm');
    //var minutesFormat = new DateFormat('mm aaa');

    bookingDate = dateFormat.format(dateAndTime);
    currentTime = timeFormat.format(dateAndTime);
    currentHour = hourFormat.format(dateAndTime);
    minutes = minutesFormat.format(dateAndTime);

    _date = bookingDate.toString();
    user.airportBookingDate = _date;
    _time = currentTime;
    user.airportBookingTime = _time;
  }

  void airportDataSubmit() async {
    String transferType;

    if (user.isLocalTransfer) {
      transferType = 'LocalTransfer';
    } else if (user.isHourlyTransfer) {
      transferType = 'HourlyTransfer';
    } else if (user.isAirportTransfer) {
      transferType = 'AirportFare';
    }

    String midSeat;

    // if (isMidSeat) {
    //   midSeat = midNightSeatCost.toString();
    // } else {
    //   midSeat = 'No';
    // }

    if(phone != 'null' && email != 'null')
      {
        var timeStamp = DateTime.now().millisecondsSinceEpoch;
        String bookingStatus = 'Pending';

        String destination = 'City';
        if(user.fromCityToAirport)
          {
            destination = user.userCurrentAddress;
          }
        if(user.fromMelbourneAirportsToAreas)
          {
            destination = user.areaNameForAirport;
          }

        var id = FirebaseCredentials().firestore.collection('airPortBooking').doc().id;
        FirebaseCredentials().firestore.collection('airPortBooking').doc(id).set({
          'name': name,
          'phone': phone,
          'email': email,
          'vehicle': user.selectedVehicle,
          'tripCost': user.selectedVehiclePrice,
          'day': user.airportBookingDate, //_date
          'time': user.airportBookingTime, //_time
          'airport': user.selectedAirport,
          'from': destination,//user.fromCityToAirport ? user.userCurrentAddress : 'City',
          'airportTransferType': user.fromCityToAirport ? 'cityToAirport' : 'airportToCity',
          'babySeat': user.babySeat, //babySeat
          'boosterSeat': user.boosterSeat, //boosterseat
          //if (isMidSeat) 'midNightPickup': midNightSeatCost,
          //'midNightPickup': midSeat,
          'midNightPickup': user.isMidSeat, //isMidSeat
          'comment': commentController.text,
          'currentUserID': user.currentUserId,
          'transferType': transferType,
          'timeStamp' : timeStamp,
          'bookingStatus' : bookingStatus
        }).then((value)
        {
          //print('User Selected Area : ${user.areaNameForAirport}');
          Navigator.pushNamed(context, '/bookCab');
        });

        String airportName;
        if(user.fromCityToAirport)
          {
            airportName = airPortNamesList(context)[user.selectedAirport].name;
          }
        else
          {
            airportName = airPortNamesListForCity(context)[user.selectedAirport].name;
          }

        callOnFcmApiSendPushNotifications(user.userCurrentAddress, airportName, id);
      }
    else
      {
        showGeneralDialog(
          barrierLabel: "Label",
          barrierDismissible: true,
          barrierColor: Colors.black.withOpacity(0.5),
          transitionDuration: Duration(milliseconds: 500),
          context: context,
          pageBuilder: (context, anim1, anim2) {
            return SafeArea(
              child: Padding(
                padding:
                const EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Material(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 250,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: yellow,
                        borderRadius: BorderRadius.circular(10),
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
                              style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            email == 'null'
                                ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: TextFormField(
                                controller: emailController,
                                autofocus: true,
                                decoration: InputDecoration(hintText: S.of(context).Email),
                                validator: (value)
                                {
                                  return value.isEmpty ? 'required' : null;
                                },
                              ),
                            ) : SizedBox(),

                            phone == 'null'
                                ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: TextFormField(
                                controller: contactController,
                                autofocus: true,
                                decoration: InputDecoration(hintText: S.of(context).Phone_Number),
                                validator: (value)
                                {
                                  return value.isEmpty ? 'required' : null;
                                },
                              ),
                            ) : SizedBox(),

                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ButtonTheme(
                                  minWidth: 100,
                                  height: 45,
                                  child: RaisedButton(
                                    onPressed: () async
                                    {
                                      if(validateForm())
                                      {
                                        phone = contactController.text.trim();
                                        email = emailController.text.trim();
                                        await FirebaseCredentials()
                                            .firestore
                                            .collection('user')
                                            .doc(user.currentUserId)
                                            .update({'phone' : phone,'email' : email}).then((value)
                                        {
                                          airportDataSubmit();
                                        });
                                      }
                                    },
                                    child: Text(
                                      S.of(context).Save,
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    color: Colors.black,
                                    elevation: 12.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(25.0),
                                    ),
                                  ),
                                ),
                                ButtonTheme(
                                  minWidth: 100,
                                  height: 45,
                                  child: RaisedButton(
                                    onPressed: ()
                                    {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      S.of(context).Cancel,
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    color: Colors.black,
                                    elevation: 12.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(25.0),
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
          transitionBuilder: (context, anim1, anim2, child) {
            return SlideTransition(
              position:
              Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
              child: child,
            );
          },
        );
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
        if(data['email'] != 'null')
        {
          email = data['email'];
        }
        else
        {
          email = 'null';
        }
        if(data['phone'] != 'null')
        {
          phone = data['phone'];
        }
        else
        {
          phone = 'null';
        }
      }
    }).catchError((onError) => print('Error Fetching Data'));
  }

  @override
  void initState() {
    super.initState();

    user = Get.find<CurrentUser>();

    getCurrentDateAndTime();
    getUserInfo();
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
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 60, bottom: 40),
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
                          S.of(context).Booking,
                          style: TextStyle(color: white, fontSize: 17),
                        ),
                        Visibility(
                          visible: false,
                          child: Icon(Icons.ac_unit_rounded),
                        )
                      ],
                    ),
                  ),
                  Text(
                    S.of(context).Airport_Pickup+' : ',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    style: TextStyle(color: white),
                    decoration: InputDecoration(
                      hintText: '${S.of(context).Flight_no} : 45645', // S.of(context).Flight_no
                      hintStyle: TextStyle(color: white),
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
                    height: 5,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).Date,
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  builder:
                                      (BuildContext context, Widget child) {
                                    return Theme(
                                      data: ThemeData.light().copyWith(
                                        colorScheme: ColorScheme.dark(
                                          primary: Colors.black,
                                          onPrimary: yellow,
                                          surface: yellow,
                                          onSurface: Colors.black,
                                        ),
                                        dialogBackgroundColor: Colors.white,
                                      ),
                                      child: child,
                                    );
                                  },
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2025),
                                ).then((date) {
                                  String selectedDate =
                                      DateFormat('MMM dd,yyyy', "en").format(date);
                                  setState(() {
                                    bookingDate = selectedDate;
                                    _date = bookingDate;
                                    user.airportBookingDate = _date;
                                  });
                                });
                              },
                              child: Container(
                                height: 60,
                                width: MediaQuery.of(context).size.width / 1.75,
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.white, width: 1)),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        bookingDate ?? S.of(context).Not_Selected,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 17),
                                      ),
                                    )),
                              ),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).Time,
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showTimePicker(
                                            context: context,
                                            builder: (BuildContext context,
                                                Widget child) {
                                              return Theme(
                                                data:
                                                    ThemeData.light().copyWith(
                                                  colorScheme: ColorScheme.dark(
                                                    primary: Colors.black,
                                                    onPrimary: yellow,
                                                    surface: yellow,
                                                    onSurface: Colors.black,
                                                  ),
                                                  dialogBackgroundColor:
                                                      Colors.white,
                                                ),
                                                child: child,
                                              );
                                            },
                                            initialTime: TimeOfDay.now())
                                        .then((time) {
                                      _timeOfDay = time;

                                      setState(() {
                                        currentHour =
                                            _timeOfDay.hourOfPeriod.toString();
                                      });

                                      if (_timeOfDay.period == DayPeriod.am) {
                                        minutes = _timeOfDay.minute.toString() +
                                            ' ' +
                                            "AM";
                                        _time = currentHour + ' : ' + minutes;
                                        user.airportBookingTime = _time;
                                      } else if (_timeOfDay.period ==
                                          DayPeriod.pm) {
                                        minutes = _timeOfDay.minute.toString() +
                                            ' ' +
                                            "PM";
                                        _time = currentHour + ' : ' + minutes;
                                        user.airportBookingTime = _time;
                                      }

                                      // show time in AM or PM format
                                      //String times = localizations.formatTimeOfDay(_timeOfDay);
                                    });
                                  },
                                  child: Container(
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
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Theme(
                              data: Theme.of(context).copyWith(
                                unselectedWidgetColor: Colors.white,
                              ),
                              child: Checkbox(
                                  checkColor: Colors.green,
                                  activeColor: Colors.white,
                                  value: isBabySeat,
                                  onChanged: (value) {
                                    setState(() {
                                      isBabySeat = value;
                                      if (isBabySeat == false) {
                                        babySeat = 0;
                                        user.babySeat = babySeat;
                                        //user.totalCostOfLocalTransfer -= babySeatTotalCost;
                                        user.selectedVehiclePrice -= babySeatTotalCost;
                                        babySeatTotalCost = 0;
                                        print(user.selectedVehiclePrice.toString());
                                      }
                                    });
                                  }),
                            ),
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: S.of(context).baby_Seat,
                                      style: TextStyle(fontSize: 15)),
                                  TextSpan(
                                      text: ' 12\$',
                                      style: TextStyle(color: Colors.yellow)),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                      //Spacer(),
                      Container(
                        child: Row(
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              child: RaisedButton(
                                child: Text(
                                  '+',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                color: Colors.black,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.white),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0))),
                                onPressed: () {
                                  setState(() {
                                    if (isBabySeat == true) {
                                      babySeat++;
                                      user.babySeat = babySeat;
                                      babySeatTotalCost += babySeatCost;

                                      user.selectedVehiclePrice += babySeatCost;
                                      print(user.selectedVehiclePrice.toString());
                                    }
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 30,
                              width: 30,
                              alignment: Alignment.center,
                              child: Text('$babySeat',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20)),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 30,
                              width: 30,
                              child: RaisedButton(
                                child: Text(
                                  '-',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                color: Colors.black,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.white),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0))),
                                onPressed: () {
                                  setState(() {
                                    if (isBabySeat == true) {
                                      if (babySeat != 0) {
                                        babySeat--;
                                        user.babySeat = babySeat;
                                        babySeatTotalCost -= babySeatCost;

                                        user.selectedVehiclePrice -= babySeatCost;
                                        print(user.selectedVehiclePrice.toString());
                                      }
                                    }
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Theme(
                        data: Theme.of(context).copyWith(
                          unselectedWidgetColor: Colors.white,
                        ),
                        child: Checkbox(
                            checkColor: Colors.green,
                            activeColor: Colors.white,
                            value: isBoosterSeat,
                            onChanged: (value) {
                              setState(() {
                                isBoosterSeat = value;
                                if (isBoosterSeat == false) {
                                  boosterSeat = 0;
                                  user.boosterSeat = boosterSeat;
                                  user.selectedVehiclePrice -= boosterSeatTotalCost;
                                  boosterSeatTotalCost = 0;
                                  print(user.selectedVehiclePrice.toString());

                                }
                              });
                            }),
                      ),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: S.of(context).Booster_Seat,
                                style: TextStyle(fontSize: 15)),
                            TextSpan(
                                text: ' 10\$',
                                style: TextStyle(color: Colors.yellow)),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        height: 30,
                        width: 30,
                        child: RaisedButton(
                          child: Text(
                            '+',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                          onPressed: () {
                            setState(() {
                              if (isBoosterSeat == true) {
                                boosterSeat++;
                                user.boosterSeat = boosterSeat;
                                boosterSeatTotalCost += boosterSeatCost;

                                user.selectedVehiclePrice += boosterSeatCost;
                                print(user.selectedVehiclePrice.toString());

                              }
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        height: 30,
                        width: 30,
                        alignment: Alignment.center,
                        child: Text('$boosterSeat',
                            style: TextStyle(color: Colors.white, fontSize: 20)),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        height: 30,
                        width: 30,
                        child: RaisedButton(
                          child: Text(
                            '-',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                          onPressed: () {
                            setState(() {
                              if (isBoosterSeat == true) {
                                if (boosterSeat != 0) {
                                  boosterSeat--;
                                  user.boosterSeat = boosterSeat;
                                  boosterSeatTotalCost -= boosterSeatCost;

                                  user.selectedVehiclePrice -= boosterSeatCost;
                                  print(user.selectedVehiclePrice.toString());

                                }
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Theme(
                        data: Theme.of(context).copyWith(
                          unselectedWidgetColor: Colors.white,
                        ),
                        child: Checkbox(
                            checkColor: Colors.green,
                            activeColor: Colors.white,
                            value: isMidSeat,
                            onChanged: (value) {
                              setState(() {
                                isMidSeat = value;
                                user.isMidSeat = isMidSeat;
                                if(isMidSeat)
                                {
                                  user.selectedVehiclePrice += 15;
                                  print(user.selectedVehiclePrice.toString());
                                }
                                else if(!isMidSeat)
                                {
                                  user.selectedVehiclePrice -= 15;
                                  print(user.selectedVehiclePrice.toString());
                                }
                              });
                            }),
                      ),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: S.of(context).MidNight_5_AM_pick_up_sucharge,
                                style: TextStyle(fontSize: 15)),
                            TextSpan(
                                text: ' 15\$',
                                style: TextStyle(color: Colors.yellow)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: commentController,
                    maxLines: 3,
                    style: TextStyle(color: white),
                    decoration: InputDecoration(
                      hintText: S.of(context).Pick_up_instructions,
                      hintStyle: TextStyle(color: white),
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
                  Spacer(),
                  Container(
                    height: 50,
                    width: double.infinity,
                    child: RaisedButton(
                      color: yellow,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      onPressed: () {

                        if (phone != 'null' && email != 'null')
                          {
                            user.isHourlyTransfer = false;
                            user.isLocalTransfer = false;
                            user.isAirportTransfer = true;
                            user.isLocalTransferPreBooking = false;

                            user.airportBookingComments = commentController.text;

                            Navigator.pushNamed(context, '/bookCab');
                          }
                        else
                        {
                          showGeneralDialog(
                            barrierLabel: "Label",
                            barrierDismissible: true,
                            barrierColor: Colors.black.withOpacity(0.5),
                            transitionDuration: Duration(milliseconds: 500),
                            context: context,
                            pageBuilder: (context, anim1, anim2) {
                              return SafeArea(
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Material(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        height: 250,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: yellow,
                                          borderRadius: BorderRadius.circular(10),
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
                                                style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              email == 'null'
                                                  ? Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 10),
                                                child: TextFormField(
                                                  controller: emailController,
                                                  autofocus: true,
                                                  decoration: InputDecoration(hintText: S.of(context).Email),
                                                  validator: (value)
                                                  {
                                                    return value.isEmpty ? 'required' : null;
                                                  },
                                                ),
                                              ) : SizedBox(),

                                              phone == 'null'
                                                  ? Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 10),
                                                child: TextFormField(
                                                  controller: contactController,
                                                  autofocus: true,
                                                  decoration: InputDecoration(hintText: S.of(context).Phone_Number),
                                                  validator: (value)
                                                  {
                                                    return value.isEmpty ? 'required' : null;
                                                  },
                                                ),
                                              ) : SizedBox(),

                                              SizedBox(
                                                height: 30,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  ButtonTheme(
                                                    minWidth: 100,
                                                    height: 45,
                                                    child: RaisedButton(
                                                      onPressed: () async
                                                      {
                                                        if(validateForm())
                                                        {
                                                          user.isLocalTransferPreBooking = false;
                                                          phone = contactController.text.trim();
                                                          email = emailController.text.trim();
                                                          await FirebaseCredentials()
                                                              .firestore
                                                              .collection('user')
                                                              .doc(user.currentUserId)
                                                              .update({'phone' : phone,'email' : email}).then((value)
                                                          {
                                                            Navigator.pushNamed(context, '/bookCab');
                                                          });
                                                        }
                                                      },
                                                      child: Text(
                                                        S.of(context).Save,
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                      color: Colors.black,
                                                      elevation: 12.0,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: new BorderRadius.circular(25.0),
                                                      ),
                                                    ),
                                                  ),
                                                  ButtonTheme(
                                                    minWidth: 100,
                                                    height: 45,
                                                    child: RaisedButton(
                                                      onPressed: ()
                                                      {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text(
                                                        S.of(context).Cancel,
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                      color: Colors.black,
                                                      elevation: 12.0,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: new BorderRadius.circular(25.0),
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
                            transitionBuilder: (context, anim1, anim2, child) {
                              return SlideTransition(
                                position:
                                Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
                                child: child,
                              );
                            },
                          );
                        }

                        // print('************');
                        // print('Total Cost : ' +
                        //     user.selectedVehiclePrice.toString());
                        // print('************');

                      },
                      child: Text(
                        S.of(context).Proceed_to_Payment,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
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
      ),
    ));
  }

  callOnFcmApiSendPushNotifications(from, airPort, id) async {
    final postUrl = 'https://fcm.googleapis.com/fcm/send';

    String cityORAirport;
    if(user.fromCityToAirport)
      {
        cityORAirport = "From $from  Airport $airPort";
      }
    else if(user.fromAirportToCity)
      {
        if(user.fromMelbourneAirportsToAreas)
          {
            cityORAirport = "Airport $airPort To $from  ";
          }
        else
          {
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
