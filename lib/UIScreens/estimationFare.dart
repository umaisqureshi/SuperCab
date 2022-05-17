import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:supercab/generated/l10n.dart';
import 'package:supercab/utils/constants.dart';

class EstimationFare extends StatefulWidget {
  @override
  _EstimationFareState createState() => _EstimationFareState();
}

class _EstimationFareState extends State<EstimationFare>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
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
                        onTap: ()=> Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back_ios_outlined,
                          size: 12,
                          color: white,
                        ),
                      ),
                    ),
                    Text(
                      S.of(context).Estimate_Fare,
                      style: TextStyle(color: white, fontSize: 17),
                    ),
                    Visibility(
                      visible: false,
                      child: Icon(Icons.eighteen_mp),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Text(S.of(context).All_inclusive_fares_including_10_mints_free_waiting_time_Tolls_GST_and_EFTpos_free,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Image.asset('assets/icons/car.png'),
                      title: Text(
                        S.of(context).Business_Sedan,
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Text(
                        '\$56',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Image.asset('assets/icons/car.png'),
                      title: Text(
                        S.of(context).European_Prestige,
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Text(
                        '\$76',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Image.asset('assets/icons/car.png'),
                      title: Text(
                        S.of(context).SUV,
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Text(
                        '\$76',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Image.asset('assets/icons/car.png'),
                      title: Text(
                        S.of(context).Mini_Van,
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Text(
                        '\$90',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 50,
                                width: (MediaQuery.of(context).size.width / 2) -
                                    14,
                                child: RaisedButton(
                                  color: yellow,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/bookNow');
                                  },
                                  child: Text(
                                    S.of(context).Book_Now,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                              Container(
                                height: 50,
                                width: (MediaQuery.of(context).size.width / 2) -
                                    14,
                                child: RaisedButton(
                                  color: yellow,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/preBooking');
                                  },
                                  child: Text(
                                    S.of(context).Pre_Booking,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                            ],
                          ),
              SizedBox(
                height: 5,
              )
            ],
          ),
        ),
      ),
    );
  }
}
