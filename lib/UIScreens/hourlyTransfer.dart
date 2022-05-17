import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:supercab/generated/l10n.dart';
import 'package:supercab/utils/constants.dart';
import 'package:supercab/utils/model/cityModel.dart';
import 'package:supercab/utils/userController.dart';
import 'package:supercab/DataSource/Source.dart';


class HourlyTransfer extends StatefulWidget {
  @override
  _HourlyTransferState createState() => _HourlyTransferState();
}

class _HourlyTransferState extends State<HourlyTransfer> {

  GoogleMapController controller;

  String searchAddress;
  CurrentUser user;
  final formKey = GlobalKey<FormState>();
  String duration;
  String bookingDate;
  String selectedTime;
  String selectedHour;
  String selectedMinutes;

  final fromController = TextEditingController();

  String currentTime;
  String currentHour;
  String minutes;

  String today = 'Today';
  String _time;

  // Hourly Transfer Variables
  int selectedHours;
  String searchedCity;
  bool isHourSelected;
  bool isCitySelected;

  TimeOfDay _timeOfDay;
  List<String> hourList = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24'
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void getCurrentDateAndTime() {
    var dateAndTime = DateTime.now();
    var dateFormat = new DateFormat('MMM d,yyyy', "en");
    var timeFormat = new DateFormat('hh:mm aaa', "en");
    var hourFormat = new DateFormat('hh',"en");
    var minutesFormat = new DateFormat('mm',"en");

    bookingDate = dateFormat.format(dateAndTime);
    currentTime = timeFormat.format(dateAndTime);
    currentHour = hourFormat.format(dateAndTime);
    minutes = minutesFormat.format(dateAndTime);

    today = bookingDate.toString();
    _time = currentTime;

    user.hourlyBookingTime = _time;
    user.hourlyBookingDate = today;
  }

  @override
  void initState() {
    super.initState();
    user = Get.find<CurrentUser>();
    isCitySelected = false;
    isHourSelected = false;
    getCurrentDateAndTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            image: new DecorationImage(
          fit: BoxFit.cover,
          image: new AssetImage("assets/icons/background.png"),
        )),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              image: new DecorationImage(
            fit: BoxFit.cover,
            image: new AssetImage("assets/icons/bg_shade.png"),
          )),
          child: Stack(
            children: [

              SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 1.38,
                  margin: EdgeInsets.only(top: 70),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          S.of(context).Want_the_flexibility_of_upfront_fixed_fares_without_any_worry_of_surge_pricing_or_variations,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            border: Border.all(color: Colors.white),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Center(
                            child: DropdownButton(
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                ),
                                hint: Text(
                                  S.of(context).Duration,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                elevation: 5,
                                isExpanded: true,
                                underline: Container(
                                  color: Colors.transparent,
                                ),
                                focusColor: Colors.white,
                                dropdownColor: Colors.black,
                                value: duration,
                                isDense: true,
                                items: hourList.map((value) {
                                  return DropdownMenuItem(
                                      value: value,
                                      child: Text(
                                        value=='1'? '$value ${S.of(context).Hour}':'$value ${S.of(context).Hours}',
                                        style: TextStyle(color: yellow),
                                      ));
                                }).toList(),
                                onChanged: (input) {
                                  setState(() {
                                    int hour = int.parse(input);
                                    duration = input;
                                    user.selectedHours = hour;
                                    isHourSelected = true;
                                    print('************');
                                    print('Selected Hour : ' +
                                        user.selectedHours.toString());
                                  });
                                }),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                                      //locale: Locale("en",""),
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
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2025),
                                      initialDate: DateTime.now(),
                                    ).then((date) {
                                      String selectedDate =
                                          DateFormat('MMM dd,yyyy', "en")
                                              .format(date);
                                      setState(() {
                                        user.hourlyBookingDate = selectedDate;
                                        bookingDate = selectedDate;
                                      });
                                    });
                                  },
                                  child: Container(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width/1.6,
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
                                                color: Colors.white,
                                                fontSize: 17),
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
                                            currentHour = _timeOfDay
                                                .hourOfPeriod
                                                .toString();
                                          });

                                          if (_timeOfDay.period ==
                                              DayPeriod.am) {
                                            minutes =
                                                _timeOfDay.minute.toString() +
                                                    ' ' +
                                                    "AM";
                                            _time =
                                                currentHour + ' : ' + minutes;
                                          } else if (_timeOfDay.period ==
                                              DayPeriod.pm) {
                                            minutes =
                                                _timeOfDay.minute.toString() +
                                                    ' ' +
                                                    "PM";
                                            _time =
                                                currentHour + ' : ' + minutes;
                                          }

                                          user.hourlyBookingTime = _time;

                                          // show time in AM or PM format
                                          //String times = localizations.formatTimeOfDay(_timeOfDay);
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            border: Border.all(
                                                color: Colors.white, width: 1)),
                                        height: 50,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          _time.toString(),
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.white),
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
                      Spacer(),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          child: RaisedButton(
                            color: yellow,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            onPressed: () {
                              if (isHourSelected == true &&
                                  isCitySelected == true) {
                                user.isHourlyTransfer = true;
                                user.isAirportTransfer = false;
                                user.isLocalTransfer = false;
                                user.isLocalTransferPreBooking = false;
                                Navigator.pushNamed(context, "/chooseVehicle", arguments: 'hourly');
                              } else {
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(
                                    S.of(context).Some_Information_is_Missing,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ));
                              }
                            },
                            child: Text(
                              S.of(context).Estimated_Fare,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SingleChildScrollView(
                child: Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      border: Border.all(color: Colors.white),
                      borderRadius:
                      BorderRadius.all(Radius.circular(10.0)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Center(
                      child: DropdownButton<String>(
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                          hint: Text(S.of(context).Select_City, style: TextStyle(color: Colors.white,),),
                          elevation: 5,
                          isExpanded: true,
                          underline: Container(
                            color: Colors.transparent,
                          ),
                          focusColor: Colors.white,
                          dropdownColor: Colors.black,
                          value: searchedCity,
                          isDense: true,
                          items: cityNamesList(context).map((value) {
                            return DropdownMenuItem<String>(
                                value: value.index,
                                child: Text(
                                  value.name,
                                  style: TextStyle(color: yellow),
                                ));
                          }).toList(),
                          onChanged: (input) {
                            setState(() {
                              // List<String> value = input.split(' ');
                              // //int hour = int.parse(value[0]);
                              searchedCity = input;
                              user.selectedCity = int.parse(input);
                              isCitySelected = true;
                              print('************');

                              print('Selected City : ' + user.selectedCity.toString());

                            });
                          }),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
