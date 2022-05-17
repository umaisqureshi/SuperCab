import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supercab/generated/l10n.dart';
import 'package:supercab/utils/constants.dart';
import 'package:supercab/utils/userController.dart';

import 'model/ReBookingDataModel.dart';

class DialogModel extends StatefulWidget {
  @override
  _DialogModelState createState() => _DialogModelState();
}
class _DialogModelState extends State<DialogModel> {

  CurrentUser user;

  ReBookingDataModel model;

  String currentTime;
  String currentHour;
  String minutes;
  String bookingDate;
  String today = 'Today';
  String _time;
  TimeOfDay _timeOfDay;

  final commentController = TextEditingController();

  void getCurrentDateAndTime() {
    var dateAndTime = DateTime.now();
    var dateFormat = new DateFormat('MMM d,yyyy',"en");
    var timeFormat = new DateFormat('hh:mm aaa',"en");
    var hourFormat = new DateFormat('hh');
    var minutesFormat = new DateFormat('mm');

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
    getCurrentDateAndTime();
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
          height: 400,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            //color: yellow,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Form(
            //key: formKey,
            child: ListView(
              primary: true,
              children: [
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    S.of(context).Reorder_Now,
                    style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                ),
                SizedBox(height: 15,),

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
                                DateFormat('MMM dd,yyyy',"en")
                                    .format(date);
                                setState(() {
                                  user.hourlyBookingDate = selectedDate;
                                  bookingDate = selectedDate;
                                });
                              });
                            },
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width/2.5,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white, width: 1)
                              ),
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
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10)),
                                    border: Border.all(
                                        color: Colors.white, width: 1)
                                  ),
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

                SizedBox(
                  height: 10,
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    controller: commentController,
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
                ),

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
                        onPressed: ()
                        {
                          model = ReBookingDataModel(date: bookingDate,time: _time,comment: commentController.text);
                          Navigator.of(context).pop(model);
                        },
                        child: Text(
                          S.of(context).Reorder,
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        color: yellow,
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
                          Navigator.of(context).pop(null);
                        },
                        child: Text(
                          S.of(context).Cancel,
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        color: yellow,
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
    );
  }
}


class ReorderModal extends ModalRoute<ReBookingDataModel> {
  @override
  Duration get transitionDuration => Duration(milliseconds: 400);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor {
    return Colors.white.withOpacity(0);
  }

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: SafeArea(
        minimum: EdgeInsets.only(top: 40),
        child: DialogModel(
        ),
      ),
    );
  }

  @override
  Widget buildTransitions(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    var begin = Offset(0.0, 1.0);
    var end = Offset.zero;
    var tween = Tween(begin: begin, end: end);
    Animation<Offset> offsetAnimation = animation.drive(tween);
    // You can add your own animations for the overlay content
    return SlideTransition(
      position: offsetAnimation,
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}
