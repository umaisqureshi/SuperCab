import 'package:flutter/material.dart';
import 'package:supercab/generated/l10n.dart';
import 'package:supercab/utils/constants.dart';

class PaymentOptions extends StatefulWidget {
  @override
  _PaymentOptionsState createState() => _PaymentOptionsState();
}

class _PaymentOptionsState extends State<PaymentOptions> {
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.arrow_back_ios_outlined,
                            size: 12,
                            color: white,
                          ),
                        ),
                      ),
                      Text(
                        S.of(context).My_payment_methods,
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
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        width: double.infinity,
                        child: RaisedButton(
                          color: yellow,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          onPressed: () => Navigator.pushNamed(context, '/l'),
                          child: Text(
                            S.of(context).Apple_Pay,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        width: double.infinity,
                        child: RaisedButton(
                          color: yellow,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          onPressed: () => Navigator.pushNamed(context, '/l'),
                          child: Text(
                            S.of(context).Google_Pay,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        width: double.infinity,
                        child: RaisedButton(
                          color: yellow,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          onPressed: () => Navigator.pushNamed(context, '/l'),
                          child: Text(
                            S.of(context).Pay_with_PAYPAL,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        width: double.infinity,
                        child: RaisedButton(
                          color: yellow,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          onPressed: () => Navigator.pushNamed(context, '/l'),
                          child: Text(
                            S.of(context).Credit_Card,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        width: double.infinity,
                        child: RaisedButton(
                          color: yellow,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          onPressed: () => Navigator.pushNamed(context, '/l'),
                          child: Text(
                            S.of(context).Pay_ID,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        width: double.infinity,
                        child: RaisedButton(
                          color: yellow,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          onPressed: () => Navigator.pushNamed(context, '/l'),
                          child: Text(
                            S.of(context).Pay_on_Pickup,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '${S.of(context).Promo_Code} :',
                            style: TextStyle(color: Colors.white),
                          ),
                          new Flexible(
                            child: Container(
                              width: 200,
                              child: new TextField(
                                  style: TextStyle(color: white),
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(color: white),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: BorderSide(
                                        color: white,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide:
                                          BorderSide(color: white, width: 2),
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '${S.of(context).Total}:',
                            style: TextStyle(color: Colors.white),
                          ),
                          new Flexible(
                            child: Container(
                              width: 200,
                              child: new TextField(
                                  style: TextStyle(color: white),
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(color: white),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: BorderSide(
                                        color: white,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide:
                                          BorderSide(color: white, width: 2),
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 50,
                        width: double.infinity,
                        child: RaisedButton(
                          color: yellow,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          onPressed: () =>
                              Navigator.pushNamed(context, '/scanCard'),
                          child: Text(
                            S.of(context).Place_Booking,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
