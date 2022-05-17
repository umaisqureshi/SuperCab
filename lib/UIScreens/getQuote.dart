import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supercab/generated/l10n.dart';
import 'package:supercab/utils/constants.dart';
import 'package:supercab/utils/firebaseCredentials.dart';
import 'package:supercab/utils/model/checkBoxModal.dart';
import 'package:supercab/utils/userController.dart';

class GetQuote extends StatefulWidget {
  @override
  _GetQuoteState createState() => _GetQuoteState();
}

class _GetQuoteState extends State<GetQuote> {
  TimeOfDay _timeOfDay;

  String bookingDate;
  String selectedTime;
  String selectedHour;
  String selectedMinutes;

  String currentTime;
  String currentHour;
  String minutes;
  String _time;

  String _date;

  List<CheckBoxModal> selectedType(context) => [
        CheckBoxModal(travelType: S.of(context).Stretch_Limo, isTrue: false),
        CheckBoxModal(travelType: S.of(context).bus, isTrue: false),
        CheckBoxModal(travelType: S.of(context).wedding, isTrue: false),
        CheckBoxModal(travelType: S.of(context).tours, isTrue: false),
      ];

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final informationController = TextEditingController();

  CurrentUser user;

  bool _status = false;
  bool isAnyItemSelected = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
        phoneController.text = data['phone'];
      }
    }).catchError((onError) => print('Error Fetching Data'));
  }

  void getCurrentDateAndTime() {
    var dateAndTime = DateTime.now();
    var dateFormat = new DateFormat('MMM d,yyyy', "en");
    var timeFormat = new DateFormat('hh:mm aaa', "en");
    var hourFormat = new DateFormat('hh');
    var minutesFormat = new DateFormat('mm');
    //var minutesFormat = new DateFormat('mm aaa');

    bookingDate = dateFormat.format(dateAndTime);
    currentTime = timeFormat.format(dateAndTime);
    currentHour = hourFormat.format(dateAndTime);
    minutes = minutesFormat.format(dateAndTime);

    _date = bookingDate.toString();
    _time = currentTime;
  }

  String stretchLimo = 'Stretch Limo';
  String bus = 'Bus';
  String wedding = 'Wedding';
  String tours = 'Tours';

  bool isStretchLimo = false;
  bool isBus = false;
  bool isWedding = false;
  bool isTours = false;

  void submit() async {
    if (_formKey.currentState.validate()) {
      List<String> list = [];

      selectedType(context)
          .where((element) => element.isTrue)
          .forEach((element) {
        list.add(element.travelType);
        print('Selected Types : ' + element.travelType.toString());
      });

      FirebaseCredentials().firestore.collection('getQuote').doc().set({
        'name': nameController.text,
        'phone': phoneController.text,
        'email': emailController.text,
        'time': _time,
        'date': _date,
        if(isStretchLimo)...{
          "Limo":isStretchLimo,
        },
        if(isBus)...{
          "Bus":isBus,
        },
        if(isWedding)...{
          "Wedding":isWedding,
        },
        if(isTours)...{
          "Tours":isTours,
        },
        // 'selectedType': list,
        'information': informationController.text
      }).then((value) {
        Navigator.of(context).pop();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    user = Get.find<CurrentUser>();
    getUserInfo();
    getCurrentDateAndTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
      height: MediaQuery.of(context).size.height,
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
                      height: 25,
                      width: 25,
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
                      S.of(context).Request_a_Quote,
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
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
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
                          hintText: S.of(context).Lorem_Ipsum,
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
                        height: 10,
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
                        height: 10,
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
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                                          DateFormat('MMM dd,yyyy', "en")
                                              .format(date);
                                      setState(() {
                                        bookingDate = selectedDate;
                                        _date = selectedDate;
                                      });
                                    });
                                  },
                                  child: Container(
                                    height: 60,
                                    width: MediaQuery.of(context).size.width /
                                        1.75,
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
                                            bookingDate ??
                                                S.of(context).Not_Selected,
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
                                  'Time',
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
                                        height: 60,
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
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children:
                          [
                            Row(
                              children:
                              [
                                Theme(
                                  data: ThemeData(unselectedWidgetColor: Colors.white),
                                  child: Checkbox(
                                    checkColor: Colors.black,
                                    activeColor: yellow,
                                    value: isStretchLimo,
                                      onChanged: (value) {
                                        setState(()
                                        {
                                          print(value.toString());
                                          isStretchLimo = value;
                                        });
                                      }),
                                ),
                                Text(S.of(context).Stretch_Limo,style: TextStyle(color: Colors.white),),
                              ],
                            ),
                            Row(
                              children:
                              [
                                Theme(
                                  data: ThemeData(unselectedWidgetColor: Colors.white),
                                  child: Checkbox(
                                      checkColor: Colors.black,
                                      activeColor: yellow,
                                      value: isBus,
                                      onChanged: (value) {
                                        setState(()
                                        {
                                          print(value.toString());
                                          isBus = value;
                                        });
                                      }),
                                ),
                                Text('40-65 '+S.of(context).bus,style: TextStyle(color: Colors.white),),
                              ],
                            ),
                            Row(
                              children:
                              [
                                Theme(
                                  data: ThemeData(unselectedWidgetColor: Colors.white),
                                  child: Checkbox(
                                      checkColor: Colors.black,
                                      activeColor: yellow,
                                      value: isWedding,
                                      onChanged: (value) {
                                        setState(()
                                        {
                                          print(value.toString());
                                          isWedding = value;
                                        });
                                      }),
                                ),
                                Text(S.of(context).wedding,style: TextStyle(color: Colors.white),),
                              ],
                            ),
                            Row(
                              children:
                              [
                                Theme(
                                  data: ThemeData(unselectedWidgetColor: Colors.white),
                                  child: Checkbox(
                                      checkColor: Colors.black,
                                      activeColor: yellow,
                                      value: isTours,
                                      onChanged: (value) {
                                        setState(()
                                        {
                                          print(value.toString());
                                          isTours = value;
                                        });
                                      }),
                                ),
                                Text(S.of(context).tours,style: TextStyle(color: Colors.white),),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: informationController,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(color: white),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          hintText: S.of(context).Additional_Comments,
                          hintStyle: TextStyle(color: white),
                          fillColor: Colors.white.withOpacity(0.1),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                        maxLines: 4,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8, 40, 8, 20),
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          child: RaisedButton(
                            color: yellow,
                                //isAnyItemSelected ? yellow : Colors.lime[900],
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            onPressed: () {
                              if(isStretchLimo || isBus || isWedding || isTours)
                                {
                                  submit();
                                  print('Done');
                                }
                              else
                                {
                                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text(
                                      'Please Select Any Service',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ));
                                }
                            },
                            child: Text(
                              S.of(context).Request_a_Quote,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

}

