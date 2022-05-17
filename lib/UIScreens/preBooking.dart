import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supercab/UIScreens/bookCab.dart';
import 'package:supercab/generated/l10n.dart';
import 'package:supercab/utils/constants.dart';
import 'package:supercab/utils/firebaseCredentials.dart';
import 'package:supercab/utils/userController.dart';
import 'dart:convert';
import 'package:http/http.dart';


enum MidNightPickUpEnumForPreBooking
{
  TRUE,FALSE
}
extension MidNightPickUpEnumName on MidNightPickUpEnumForPreBooking{
  String name(){
    return this.index==0?"Yes":this.index==1?"NO":"";
  }
}

enum BookingStatusEnumForPreBooking
{
  PENDING,ACCEPT,DECLINE
}
extension BookingStatusEnumName on BookingStatusEnumForPreBooking{
  String name(){
    return this.index==0?"Pending":this.index==1?"Accept":this.index==2?"Decline":"";
  }
}


class PreBooking extends StatefulWidget {
  @override
  _PreBookingState createState() => _PreBookingState();
}

class _PreBookingState extends State<PreBooking> {
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
  String currentTime;
  String currentHour;
  String minutes;
  String _time;

  final formKey = GlobalKey<FormState>();

  TimeOfDay _timeOfDay;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final companyNameController = TextEditingController();
  final flightNumberController = TextEditingController();
  final dayController = TextEditingController();
  final timeController = TextEditingController();
  final minutesController = TextEditingController();
  final commentsController = TextEditingController();

  bool _status = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  CurrentUser user;

  bool isPhoneNumberRequired = false;
  bool isEmailRequired = false;

  String _date;

  bool validateForm()
  {
    final key = formKey.currentState;
    if(key.validate())
    {
      return true;
    }
    return false;
  }

  void submit() async {
    if (_formKey.currentState.validate()) {


      if(isPhoneNumberRequired)
      {
        print('Updating Phone Number');
        FirebaseCredentials().firestore.collection('user').doc(user.currentUserId).update({'phone' : phoneController.text});
      }

      if(isEmailRequired)
      {
        print('Updating Email');
        FirebaseCredentials().firestore.collection('user').doc(user.currentUserId).update({'email' : emailController.text});
      }

      user.isLocalTransferPreBooking = true;
      user.isLocalTransfer = false;

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BookCab())
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
        nameController.text = data['name'];
        if(data['email'] != 'null')
        {
          emailController.text = data['email'];
        }
        else
        {
          isEmailRequired = true;
        }
        if(data['phone'] != 'null')
        {
          phoneController.text = data['phone'];
        }
        else
          {
            isPhoneNumberRequired = true;
          }
      }
    }).catchError((onError) => print('Error Fetching Data'));
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
  //       nameController.text = data['firstName'];
  //       emailController.text = data['email'];
  //       phoneController.text = data['phone'];
  //     }
  //   }).catchError((onError) => print('Error Fetching Data'));
  // }

  void getCurrentDateAndTime() {
    var dateAndTime = DateTime.now();
    var dateFormat = new DateFormat('MMM d,yyyy',"en");
    var timeFormat = new DateFormat('hh:mm aaa',"en");
    var hourFormat = new DateFormat('hh');
    var minutesFormat = new DateFormat('mm aaa');

    bookingDate = dateFormat.format(dateAndTime);
    currentTime = timeFormat.format(dateAndTime);
    currentHour = hourFormat.format(dateAndTime);
    minutes = minutesFormat.format(dateAndTime);

    timeController.text = currentHour.toString();
    minutesController.text = minutes.toString();

    _date = bookingDate.toString();
    user.preBookingDate = _date;
    _time = currentTime;
    user.preBookingTime = _time;

  }

  // int calculateCost(String selectedVehicle, int selectedVehiclePrice,
  //     int totalKilometers) {
  //   double pricePerKM = 2.30;
  //   double totalKMCost = pricePerKM * totalKilometers;
  //   double totalPrice = totalKMCost + 15;
  //
  //   if (selectedVehicle == 'Business Sedan') {
  //     return totalPrice.toInt();
  //   }
  //   if (selectedVehicle == 'European Prestige') {
  //     totalPrice = totalPrice + 20;
  //     return totalPrice.toInt();
  //   } else if (selectedVehicle == 'SUV') {
  //     totalPrice = totalPrice + 25;
  //     return totalPrice.toInt();
  //   } else if (selectedVehicle == 'Mini Van') {
  //     totalPrice = totalPrice + 40;
  //     return totalPrice.toInt();
  //   }
  //
  //   return totalPrice.toInt();
  // }

  @override
  void initState() {
    super.initState();
    user = Get.find<CurrentUser>();

    getCurrentDateAndTime();
    getUserInfo();

    if (user.selectedVehicle != null) {
       user.totalCostOfLocalTransfer = user.selectedVehiclePrice;
       //print('First Total Cost : '+user.totalCostOfLocalTransfer.toString());
    }
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
                        S.of(context).Pre_Booking,
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
                          '${S.of(context).Airport_Pickup}:',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: flightNumberController,
                          // validator: (input) {
                          //   if (input.isEmpty)
                          //     return 'Required Field';
                          //   else
                          //     return null;
                          // },
                          style: TextStyle(color: white),
                          decoration: InputDecoration(
                            hintText: 'Flight no:45654',
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
                                  GestureDetector(
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        builder: (BuildContext context,
                                            Widget child) {
                                          return Theme(
                                            data: ThemeData.light().copyWith(
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
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2025),
                                      ).then((date) {
                                        String selectedDate =
                                            DateFormat('MMM d,yyyy',"en")
                                                .format(date);
                                        bookingDate = selectedDate;
                                        setState(() {
                                          _date = bookingDate;
                                          user.preBookingDate = _date;
                                        });
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
                                        _date.toString(),
                                        style: TextStyle(
                                            fontSize: 17, color: Colors.white),
                                      ),
                                    ),
                                  ),
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
                                  GestureDetector(
                                    onTap: () {
                                      showTimePicker(
                                              context: context,
                                              builder: (BuildContext context,
                                                  Widget child) {
                                                return Theme(
                                                  data: ThemeData.light()
                                                      .copyWith(
                                                    colorScheme:
                                                        ColorScheme.dark(
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
                                          currentHour = _timeOfDay.hourOfPeriod.toString();
                                        });

                                        if (_timeOfDay.period == DayPeriod.am) {
                                          minutes =
                                              _timeOfDay.minute.toString() +
                                                  ' ' +
                                                  "AM";
                                          _time = currentHour + ' : ' + minutes;
                                          user.preBookingTime = _time;
                                        } else if (_timeOfDay.period == DayPeriod.pm)
                                        {
                                          minutes =
                                              _timeOfDay.minute.toString() +
                                                  ' ' +
                                                  "PM";
                                          _time = currentHour + ' : ' + minutes;
                                          user.preBookingTime = _time;
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
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
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
                                              user.babySeatPreBooking = babySeat;
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
                                            text: '12\$',
                                            style: TextStyle(
                                                color: Colors.yellow)),
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0))),
                                      onPressed: () {
                                        setState(() {

                                          if (isBabySeat == true) {
                                            babySeat++;
                                            user.babySeatPreBooking = babySeat;
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0))),
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
                                        user.boosterSeatPreBooking = boosterSeat;
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
                                      text: S.of(context).booster_Seat,
                                      style: TextStyle(fontSize: 15)),
                                  TextSpan(
                                      text: '10\$',
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
                                    if (isBoosterSeat == true) {
                                      boosterSeat++;
                                      user.boosterSeatPreBooking = boosterSeat;
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
                                    if (isBoosterSeat == true) {
                                      if (boosterSeat != 0) {
                                        boosterSeat--;
                                        user.boosterSeatPreBooking = boosterSeat;
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
                                      user.isMidSeatPreBooking = isMidSeat;
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
                                      text: '15\$',
                                      style: TextStyle(color: Colors.yellow)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: commentsController,
                          maxLines: 3,
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
                    onPressed: ()
                    {
                      if (!isEmailRequired && !isPhoneNumberRequired)
                      {
                        user.isHourlyTransfer = false;
                        user.isLocalTransfer = false;
                        user.isAirportTransfer = false;
                        user.isLocalTransferPreBooking = true;

                        user.airportBookingComments = commentsController.text;

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
                                            isEmailRequired == true
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

                                            isPhoneNumberRequired == true
                                                ? Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 10),
                                              child: TextFormField(
                                                controller: phoneController,
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
                                                        user.isLocalTransferPreBooking = true;
                                                        String phone = phoneController.text.trim();
                                                        String email = emailController.text.trim();
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
                    },
                    child: Text(
                      S.of(context).Proceed_to_Payment,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
        "type" : 'prebooking'
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
